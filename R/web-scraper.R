library(rvest)
library(dplyr)
library(stringr)
library(telegram)

# Coletando informações de promoções da página do hardmob
hardmob <- read_html("https://www.hardmob.com.br/forums/407-Promocoes")

promocoes <- hardmob %>% 
  html_nodes(".threadtitle") %>% 
  html_text() %>% 
  tibble::enframe(name = NULL) %>% 
  .[4:nrow(.),] %>% 
  pull(value) %>% 
  str_replace_all("\n", "") %>% 
  paste(collapse = "\n\n")


# Iniciando o Bot
# o token está definido no arquivo .Renviron:
# user_renviron <- path.expand(file.path("~", ".Renviron"))
# file.edit(user_renviron) 
bot <- TGBot$new(token = bot_token('hardmob_promos_bot'))

# Buscando os chat_ids dos usuários conectados no bot
msgs <- bot$getUpdates()
chat_ids <- msgs$message$chat$id 


initial_message <- "NOVAS PROMOÇÕES, APROVEITE!"
message <- paste(initial_message, promocoes, sep = "\n\n")

# Enviando mensagem para os usuários
for (id in chat_ids){
  bot$set_default_chat_id(id)
  bot$sendMessage(message)
}
