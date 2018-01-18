# 4. faza: Analiza podatkov

zadetki <- read_excel("podatki/Zadetki.xlsx")
colnames(zadetki) <- c("leto", "ekipe", "tekme", "zadetki", "povp_zadetki", "udelezba")
zadetki$leto <- gsub("FIFA([^)]*)™", "", zadetki$leto)








# podatki <- obcine %>% transmute(obcina, povrsina, gostota,
#                                 gostota.naselij = naselja/povrsina) %>%
#   left_join(povprecja, by = "obcina")
# row.names(podatki) <- podatki$obcina
# podatki$obcina <- NULL

# Število skupin
# n <- 5
# skupine <- hclust(dist(scale(podatki))) %>% cutree(n)
