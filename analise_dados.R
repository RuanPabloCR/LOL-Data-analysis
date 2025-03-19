library(jsonlite)
library(httr)
library(dplyr)
library(ggplot2)

api_key <- "SUA_CHAVE_AQUI"
PUUID_TITAN <- "f1PNl5iEdTEEJ0hJ9804N94E0O9mHqjGCe_vPlRkv9zO0pEg8XHyuJrNVgKmoxEk3a7xzpoFH2zJNQ"

matches_info <- fromJSON("C:/Users/RuanP/OneDrive/Área de Trabalho/projeto LOL/Pain Titan/matches.json")
matches_ids <- unlist(matches_info)

# Meu Data Frame vai conter essas informacoes: ID da partida,
# Duracao da partida, TIME VENCEDOR, CAMPEOES DA EQUIPE DO JOGADOR,
# KDA, VERSAO DO JOGO

df_matches <- data.frame(match_Id = character(),
                         match_Duration = numeric(),
                         match_Win = logical(),
                         player_Champion = character(),
                         team_Champions = character(),
                         player_Mk = character(),
                         stringsAsFactors = FALSE
                         )

for(i in seq_along(matches_ids)){
  match_id = trimws(matches_ids[i])
  file_path <- paste0("matches_data/", match_id, ".json")
  if(file.exists(file_path)){
    match_data <- fromJSON(file_path)
    
    duration <- match_data$info$gameDuration / 60
    #Encontrar os participantes e verificar se o jogador e um deles
    participants <- match_data$info$participants
    
    if (!is.data.frame(participants)) {
      participants <- as.data.frame(do.call(rbind, participants))
    }
    
    player_data <- participants[participants$puuid == PUUID_TITAN,]
    
    if(nrow(player_data) == 0) {
      next
    }
    #Verificar se o jogador venceu e identificar o campeao usado
    match_result = player_data$win
    player_champion <- player_data$championName
    
    #Identificar o time e os campeaos utilizados pela equipe
    player_Team_Id <- as.numeric(player_data$teamId)
    participants$teamId <- as.numeric(participants$teamId)
    
    player_team_champions <- participants[participants$teamId == player_Team_Id, c("championName","puuid")]
    if (nrow(player_team_champions) == 0) {
      print(paste("Time do jogador não encontrado em", match_id))
      next
    }
    #destinguir o jogador dos outros
    player_team_champions$IsPlayer <- ifelse(player_team_champions$puuid == PUUID_TITAN, 1, 0)
    
    #salvar as informações no dataframe
    df_matches <- rbind(df_matches, data.frame(
      match_Id = match_id,
      match_Duration = duration,
      match_Win = ifelse(length(match_result) > 0, match_result, FALSE),
      player_Champion = ifelse(length(player_champion) > 0, player_champion, "Desconhecido"),
      team_Champions = ifelse(nrow(player_team_champions) > 0, paste(player_team_champions$championName, collapse = ","), "Nenhum"),
      player_Mk = ifelse(nrow(player_team_champions) > 0, paste(player_team_champions$IsPlayer, collapse = ","), "Nenhum"),
      stringsAsFactors = FALSE
    ))
  }
  else{
    print(paste("match: ", match_id, "not found!"))
  }
}
# Criacao de um dataframe auxiliar com as informacoes de visualizacao

df_aux <- df_matches %>%
  select(match_Duration, match_Win, player_Champion) %>%
  group_by(player_Champion) %>%
  summarize(total_Games = n(),
            champion_Winrate = mean(match_Win)) %>%
        filter(total_Games >= 3)

graph1 <- ggplot(df_aux, aes(x = reorder(player_Champion, -champion_Winrate), y = champion_Winrate, fill = player_Champion)) +
  geom_col() +
  labs(
    title = "Winrate por Campeão com pelo menos 3 partidas",
    x = "Campeão",
    y = "Taxa de Vitória"
  ) +
  theme_minimal() +
  ylim(0, 1) +
  theme(legend.position = "none") +
  coord_flip()
graph2 <- ggplot(df_aux, aes(x = total_Games, y = champion_Winrate, 
                                             color = factor(player_Champion), size = total_Games)) +
  geom_point(alpha = 0.7) +  # Deixa os pontos levemente transparentes para melhor visualização
  scale_size(range = c(3, 10)) +  # Ajusta a variação do tamanho dos pontos
  labs(
    title = "Winrate por Campeão vs Total de Partidas",
    x = "Total de Partidas",
    y = "Taxa de Vitória",
    color = "Campeão",
    size = "Total de Partidas"
  ) +
  ylim(0, 1) +
  theme_minimal() +
  theme(legend.position = "bottom")

graph1
graph2

