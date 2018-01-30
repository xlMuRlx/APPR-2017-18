# 4. faza: Analiza podatkov

zadetki <- read_excel("podatki/Zadetki.xlsx")
colnames(zadetki) <- c("leto", "ekipe", "tekme", "stevilo", "povp_zadetki", "udelezba")
zadetki$leto <- gsub("FIFA([^)]*)™", "", zadetki$leto)
zadetki <- zadetki %>% arrange(leto)

graf.zadetki <- ggplot(zadetki, aes(x = leto, y = stevilo)) + 
  geom_point() + xlab("Leto") + ylab("Število zadetkov") + 
  ggtitle("Število zadetkov na posameznem prvenstvu") +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.5))

graf.zadetki <- graf.zadetki + geom_smooth(method = lm, formula = stevilo ~ leto)

napoved <- lm(data = zadetki[c(1, 4)], stevilo ~ leto)




skupine <- left_join(peta %>% drop_na, tekme %>% filter(izid == "zmaga"))
skupine <- skupine[-3] %>% arrange(ekipa)
colnames(skupine) <- c("ekipa", "povp_uvrstitev", "st_zmage")
k <- kmeans(skupine[3], 4, nstart = 1000)

razvrstitev <- data.frame(ekipa = skupine$ekipa, skupina = factor(k$cluster), 
                          povp_uvrstitev = skupine$povp_uvrstitev)
graf.povezava <- ggplot(razvrstitev, aes(x = ekipa, 
                                         y = povp_uvrstitev)) + 
  geom_point(colour = razvrstitev$skupina, size = 5) + xlab("Država") + 
  ylab("Povprečna uvrstitev") + ggtitle("Graf povprečnih uvrstitev") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5))



# podatki <- obcine %>% transmute(obcina, povrsina, gostota,
#                                 gostota.naselij = naselja/povrsina) %>%
#   left_join(povprecja, by = "obcina")
# row.names(podatki) <- podatki$obcina
# podatki$obcina <- NULL

# Število skupin
# n <- 5
# skupine <- hclust(dist(scale(podatki))) %>% cutree(n)
