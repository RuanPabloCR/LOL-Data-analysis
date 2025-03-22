# Projeto LOL - Pain Titan

Este projeto tem como objetivo analisar dados de partidas do jogo League of Legends (LOL) utilizando a linguagem R. A análise será focada em um jogador específico, o **Titan**. No entanto, qualquer pessoa pode clonar o repositório e realizar suas próprias análises a partir de qualquer jogador. Abaixo está a estrutura do projeto e uma breve descrição dos arquivos principais.

O projeto ainda está em andamento!!! Logo, por enquanto você precisará importar o arquivo **matches.json** através da API da Riot.

**Esta análise foi realizada com base em dados públicos obtidos através da Riot Games API. Os dados não incluem informações privadas e seguem os Termos de Serviço e Políticas da Riot.**


## Descrição dos Arquivos

- **analise_dados.R**: Script R responsável por analisar os dados das partidas e gerar gráficos.
- **graph1.png**: Primeiro gráfico gerado pela análise dos dados.
- **graph2.png**: Segundo gráfico gerado pela análise dos dados.
- **Matches_Data_Save.R**: Script R responsável por baixar e salvar os dados das partidas em formato JSON.
- **README.md**: Este arquivo, contendo a descrição do projeto.
- **matches_data/**: Pasta contendo os arquivos JSON das partidas.
- **matches.json**: Arquivo contendo uma lista de partidas.

## Como Executar

1. **Baixar os Dados das Partidas**:
   - Entre em `Matches_Data_Save.R` na variável api_key 
   - Execute o script `Matches_Data_Save.R` para baixar e salvar os dados das partidas na pasta `matches_data/`.

2. **Analisar os Dados**:
   - Execute o script `analise_dados.R` para analisar os dados das partidas e gerar os gráficos `graph1.png` e `graph2.png`.

## Dependências

- **R**: Certifique-se de ter o R instalado em sua máquina.
- **Pacotes R**: Os seguintes pacotes são necessários:
  - `httr`
  - `jsonlite`
  - `ggplot2`

Para instalar os pacotes necessários, você pode usar o seguinte comando no R:

```r
install.packages(c("httr", "jsonlite", "ggplot2"))
```
