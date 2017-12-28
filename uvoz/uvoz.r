# 2. faza: Uvoz podatkov


# Uvoz podatkov in Wikipedije

link <- "https://en.wikipedia.org/wiki/National_team_appearances_in_the_FIFA_World_Cup#Comprehensive_team_results_by_tournament"
stran <- html_session(link) %>% read_html()
uvrstitve <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>%
  .[[2]] %>% html_table(dec = ",", fill = TRUE)
for (i in 1:ncol(uvrstitve)) {
  if (is.character(uvrstitve[[i]])) {
    Encoding(uvrstitve[[i]]) <- "UTF-8"
  }
}
colnames(uvrstitve) <- c("ekipa", seq(1930, 1938, 4), seq(1950, 2018, 4),
                          "skupne_uvr", "proc_uspesnost")
uvrstitve <- uvrstitve[-c(25, 53, 82), ]
uvrstitve <- uvrstitve %>% separate(skupne_uvr, c("st_uvr", "st_kval"), "/")
uvrstitve$st_uvr <- parse_integer(uvrstitve$st_uvr)
uvrstitve$st_kval <- parse_integer(uvrstitve$st_kval)
uvrstitve$proc_uspesnost <- parse_number(uvrstitve$proc_uspesnost)


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
prvenstva <- prvenstva[-c(48, 78, 79, 80), ]
prvenstva$zmaga <- round(prvenstva$zmaga)
prvenstva <- prvenstva %>% add_row()
prvenstva <- prvenstva %>% add_row()
prvenstva$ekipa[77] <- "Panama"
prvenstva$ekipa[78] <- "Iceland"
prvenstva$odigrane[77] <- 0
prvenstva$odigrane[78] <- 0
prvenstva$zmaga[77] <- 0
prvenstva$zmaga[78] <- 0
prvenstva$remi[77] <- 0
prvenstva$remi[78] <- 0
prvenstva$poraz[77] <- 0
prvenstva$poraz[78] <- 0
prvenstva$st_dosezeni[77] <- 0
prvenstva$st_dosezeni[78] <- 0
prvenstva$st_prejeti[77] <- 0
prvenstva$st_prejeti[78] <- 0
prvenstva <- prvenstva %>% arrange(ekipa)


ucinkovitost <- prvenstva[c(1, 6, 7)]
ucinkovitost <- melt(ucinkovitost, id = "ekipa", na.rm = TRUE)
colnames(ucinkovitost) <- c("ekipa", "tip", "stevilo")
ucinkovitost$tip <- gsub("st_dosezeni", "dosezeni", ucinkovitost$tip)
ucinkovitost$tip <- gsub("st_prejeti", "prejeti", ucinkovitost$tip)
ucinkovitost <- ucinkovitost %>% arrange(ekipa)

koncne.uvrstitve <- melt(prvenstva[, -c(2:7)], na.rm = TRUE,
                         variable.name = "leto", value.name = "uvrstitev") %>%
  mutate(leto = parse_number(leto))
koncne.uvrstitve <- rbind(koncne.uvrstitve,
                          data.frame(ekipa = uvrstitve[uvrstitve[,"2018"] == "q", "ekipa"] %>%
                                       strapplyc("(^[^[]+)") %>% unlist(),
                                     leto = 2018, uvrstitev = NA))
koncne.uvrstitve <- koncne.uvrstitve %>% arrange(ekipa)

tekme <- prvenstva[c(1, 3, 4, 5)]
tekme <- melt(tekme, id = "ekipa", na.rm = TRUE)
colnames(tekme) <- c("ekipa", "izid", "stevilo")
tekme <- tekme %>% arrange(ekipa)

potegovanja <- uvrstitve[c(1, length(uvrstitve)-1)]
colnames(potegovanja) <- c("ekipa", "st_nastopov")
potegovanja$ekipa <- gsub("\\[([^)]*)\\]", "", potegovanja$ekipa)
potegovanja$ekipa <- gsub("Bosnia and Herzegovina", "Bosnia & Herzegovina", potegovanja$ekipa)
potegovanja$ekipa <- gsub("DR Congo", "Congo DR", potegovanja$ekipa)
potegovanja$ekipa <- gsub("Ivory Coast", "Cote d Ivoire", potegovanja$ekipa)
potegovanja$ekipa <- gsub("North Korea", "Korea DPR", potegovanja$ekipa)
potegovanja$ekipa <- gsub("South Korea", "Korea Republic", potegovanja$ekipa)
potegovanja <- potegovanja[-c(22), ]
potegovanja <- potegovanja %>% arrange(ekipa)
potegovanja$ekipa <- prvenstva$ekipa


