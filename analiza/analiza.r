# 4. faza: Analiza podatkov

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




zadetki <- read_excel("podatki/Zadetki.xlsx")
colnames(zadetki) <- c("leto", "ekipe", "tekme", "st_golov", "povp_zadetki", "udelezba")
zadetki$leto <- gsub("FIFA([^)]*)™", "", zadetki$leto)
zadetki <- zadetki %>% arrange(leto)
zadetki$leto <- as.numeric(zadetki$leto)
zadetki$udelezba <- zadetki$udelezba * 1000


graf.zadetki <- ggplot(zadetki, aes(x = leto, y = st_golov)) + 
  geom_point() + xlab("Leto") + ylab("Število zadetkov") 
graf.zadetki <- graf.zadetki + geom_smooth(method = 'lm', color = "red")


pomozna.napoved <- lm(data = zadetki[c(1, 4)], st_golov ~ leto)
leta <- data.frame(leto = seq(2018, 2026, 4))
napoved <- leta %>% mutate(st_golov = round(predict(pomozna.napoved, .)))


graf.povp_zadetki <- ggplot(zadetki, aes(x = leto, y = povp_zadetki)) + 
  geom_point() + xlab("Leto") + ylab("Povprečno število zadetkov")
graf.povp_zadetki <- graf.povp_zadetki + geom_smooth(method = 'lm', color = "red")

pomozna.napoved2 <- lm(data = zadetki[c(1, 5)], povp_zadetki ~ leto)
napoved <- napoved %>% mutate(povp_goli = round(predict(pomozna.napoved2, .), 2))


graf.udelezba <- ggplot(zadetki, aes(x = leto, y = udelezba)) + 
  geom_point() + xlab("Leto") + ylab("Udelezba")
graf.udelezba <- graf.udelezba + geom_smooth(method = 'lm', color = "red")

pomozna.napoved3 <- lm(data = zadetki[c(1, 6)], udelezba ~ leto)
napoved <- napoved %>% mutate(udelezba = round(predict(pomozna.napoved3, .)))



tabela.graf <- bind_rows(zadetki[c(1, 4)],napoved[c(1,2)])

graf.porocilo <- ggplot(tabela.graf, aes(x = leto, y = st_golov)) + 
  geom_point() + xlab("Leto") + ylab("Število zadetkov") +
  ggtitle("Število zadetkov na posameznem prvenstvu") +
  geom_smooth(method = 'lm', color = "red")




colnames(napoved) <- c("Leto", "Število zadetkov", 
                       "Povprečno število zadetkov na tekmo", "Udeležba")

pom_skupine <- aggregate(uvrstitev ~ ekipa, drop_na(koncne.uvrstitve), min)
pom_skupine <- merge(pom_skupine, drop_na(koncne.uvrstitve))
pom_skupine <- left_join(pom_skupine, skupine)
pom_skupine <- pom_skupine[-c(4, 5)]
pom_skupine1 <- aggregate(leto ~ ekipa, pom_skupine, max)
pom_skupine <- merge(pom_skupine, pom_skupine1)

prizorisca = c("v Urugvaju", "v Italiji", "v Franciji", "v Braziliji", "v Švici",
               "na Švedskem", "v Čilu", "v Angliji", "v Mehiki", "v ZDA", 
               "v Južni Koreji in na Japonskem", "v Nemčiji", "v Južni Afriki", 
               "v Argentini", "v Španiji")

pom_skupine$prizorisce <- NA
for (i in 1:length(pom_skupine$prizorisce)) {
  if (pom_skupine$leto[i] == 1930) {
    pom_skupine$prizorisce[i] <- prizorisca[1]
  } else if (pom_skupine$leto[i] == 1934 || pom_skupine$leto[i] == 1990) {
    pom_skupine$prizorisce[i] <- prizorisca[2]
  } else if (pom_skupine$leto[i] == 1938 || pom_skupine$leto[i] == 1998) {
    pom_skupine$prizorisce[i] <- prizorisca[3]
  } else if (pom_skupine$leto[i] == 1950 || pom_skupine$leto[i] == 2014) {
    pom_skupine$prizorisce[i] <- prizorisca[4]
  } else if (pom_skupine$leto[i] == 1954) {
    pom_skupine$prizorisce[i] <- prizorisca[5]
  } else if (pom_skupine$leto[i] == 1958) {
    pom_skupine$prizorisce[i] <- prizorisca[6]
  } else if (pom_skupine$leto[i] == 1962) {
    pom_skupine$prizorisce[i] <- prizorisca[7]
  } else if (pom_skupine$leto[i] == 1966) {
    pom_skupine$prizorisce[i] <- prizorisca[8]
  } else if (pom_skupine$leto[i] == 1970 || pom_skupine$leto[i] == 1986) {
    pom_skupine$prizorisce[i] <- prizorisca[9]
  } else if (pom_skupine$leto[i] == 1994) {
    pom_skupine$prizorisce[i] <- prizorisca[10]
  } else if (pom_skupine$leto[i] == 2002) {
    pom_skupine$prizorisce[i] <- prizorisca[11]
  } else if (pom_skupine$leto[i] == 1974 || pom_skupine$leto[i] == 2006) {
    pom_skupine$prizorisce[i] <- prizorisca[12]
  } else if (pom_skupine$leto[i] == 2010) {
    pom_skupine$prizorisce[i] <- prizorisca[13]
  } else if (pom_skupine$leto[i] == 1978) {
    pom_skupine$prizorisce[i] <- prizorisca[14]
  } else if (pom_skupine$leto[i] == 1982) {
    pom_skupine$prizorisce[i] <- prizorisca[15]
  }
}
