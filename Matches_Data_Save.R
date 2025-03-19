library(httr)
library(jsonlite)

api_key <- "CHAVE_AQUI"

matches_data <- fromJSON("C:/Users/RuanP/OneDrive/Área de Trabalho/projeto LOL/Pain Titan/matches.json")
matches_ids <- unlist(matches_data$matches)

dir.create("matches_data",showWarnings = FALSE)

for(i in seq_along(matches_ids)){
  match_id <- trimws(matches_ids[i])
  file_path <- paste0("matches_data/", match_id, ".json")
  
  if(file.exists(file_path)){
    print(paste("match: ", match_id, " - Already exists "))
    next
  }
  match_endpoint <- paste0("https://americas.api.riotgames.com/lol/match/v5/matches/",
                           match_id,"?api_key=",api_key)
  response = GET(match_endpoint)
  if(status_code(response) == 200){
    match_data <- fromJSON(content(response,"text"))
    
    if(match_data$info$queueId == 420){
      write(toJSON(match_data, pretty = TRUE),file_path)
      print(paste("created:",match_id ))
    }
  }
  else if(status_code(response) == 429){
    Sys.sleep(1.5)
  }
  Sys.sleep(1.3)
}
