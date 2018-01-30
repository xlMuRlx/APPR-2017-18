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


