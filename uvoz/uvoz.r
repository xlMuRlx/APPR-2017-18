# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi podatke iz Wikipedije
uvozi.top4 <- function() {
  link <- "https://en.wikipedia.org/wiki/FIFA_World_Cup"
  stran <- html_session(link) %>% read_html()
  top4 <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[2]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(top4)) {
    if (is.character(top4[[i]])) {
      Encoding(top4[[i]]) <- "UTF-8"
    }
  }
  colnames(top4) <- c("ekipa", "st_prvak", "st_druga","st_tretja",
                             "st_cetrta","st_top4","st_top3", "st_top2")
}
  
#  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#    tabela[[col]] <- parse_number(tabela[[col]], na = "-", locale = sl)
#  }
#  for (col in c("obcina", "pokrajina", "regija")) {
#    tabela[[col]] <- factor(tabela[[col]])
#  }
#  return(tabela)
#}

uvozi.uvrstitve <- function() {
  link <- "https://en.wikipedia.org/wiki/National_team_appearances_in_the_FIFA_World_Cup#Comprehensive_team_results_by_tournament"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>%
    .[[2]] %>% html_table(dec = ",", fill = TRUE)
  for (i in 1:ncol(uvrstitve)) {
    if (is.character(uvrstitve[[i]])) {
      Encoding(uvrstitve[[i]]) <- "UTF-8"
    }
  }
  colnames(uvrstitve) <- c("ekipa", seq(1930, 1938, 4), seq(1950, 2018, 4),
                           "skupne_uvr", "proc_uspesnost")
}
# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.prvenstva <- function() {
  prvenstva <- read.xlsx("podatki/SvetovnaPrvenstva.xlsx", 1,
                                header = TRUE)
  prvenstva[-c(1, 33:39)]
  for (i in 1:ncol(prvenstva)) {
    if (is.character(prvenstva[[i]])) {
      Encoding(prvenstva[[i]]) <- "UTF-8"
    }
  }

}

#uvozi.druzine <- function(obcine) {
#  data <- read_csv2("podatki/druzine.csv", col_names = c("obcina", 1:4),
#                    locale = locale(encoding = "Windows-1250"))
#  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
#  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
#  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
#                        value.name = "stevilo.druzin")
#  data$velikost.druzine <- parse_number(data$velikost.druzine)
#  data$obcina <- factor(data$obcina, levels = obcine)
#  return(data)
#}

# Zapišimo podatke v razpredelnico obcine
#obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
#druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
