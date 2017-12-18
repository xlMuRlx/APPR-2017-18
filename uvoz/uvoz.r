# 2. faza: Uvoz podatkov


# Uvoz podatkov iz Wikipedije

link1 <- "https://en.wikipedia.org/wiki/FIFA_World_Cup"
stran1 <- html_session(link1) %>% read_html()
top4 <- stran1 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table(dec = ",", fill = TRUE)
for (i in 1:ncol(top4)) {
  if (is.character(top4[[i]])) {
    Encoding(top4[[i]]) <- "UTF-8"
  }
}
colnames(top4) <- c("ekipa", "st_prvak", "st_druga","st_tretja",
                    "st_cetrta","st_top4","st_top3", "st_top2")

top4$ekipa <- gsub("[#^]", "", top4$ekipa)
top4$st_top3 <- as.numeric(top4$st_top3)
top4$st_top2 <- as.numeric(top4$st_top2)
top4$st_prvak <- gsub("^&", NA, top4$st_prvak)
top4$st_druga <- gsub("^&", NA, top4$st_druga)
top4$st_tretja <- gsub("^&", NA, top4$st_tretja)
top4$st_cetrta <- gsub("^&", NA, top4$st_cetrta)


  
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


link2 <- "https://en.wikipedia.org/wiki/National_team_appearances_in_the_FIFA_World_Cup#Comprehensive_team_results_by_tournament"
stran2 <- html_session(link2) %>% read_html()
uvrstitve <- stran2 %>% html_nodes(xpath="//table[@class='wikitable']") %>%
  .[[2]] %>% html_table(dec = ",", fill = TRUE)
for (i in 1:ncol(uvrstitve)) {
  if (is.character(uvrstitve[[i]])) {
    Encoding(uvrstitve[[i]]) <- "UTF-8"
  }
}
stolpci <- c("ekipa", seq(1930, 1938, 4), seq(1950, 2018, 4),
             "skupne_uvr", "proc_uspesnost")
colnames(uvrstitve) <- stolpci
uvrstitve <- uvrstitve[-c(25, 53, 82), ]




# Uvoz podatkov iz datoteke Excel

prvenstva <- read_excel("podatki/SvetovnaPrvenstva.xlsx", 1)
prvenstva <- prvenstva[-c(1, 2, 10, 11, 12)]
for (i in 1:ncol(prvenstva)) {
  if (is.character(prvenstva[[i]])) {
    Encoding(prvenstva[[i]]) <- "UTF-8"
  }
}
colnames(prvenstva) <- c("ekipa", "odigrane", "zmaga", "remi", "poraz", "st_dosezeni",
                         "st_prejeti", seq(1930, 1938, 4), seq(1950, 2014, 4))
prvenstva <- prvenstva[-c(78, 79, 80), ]
prvenstva$zmaga <- round(prvenstva$zmaga)


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

