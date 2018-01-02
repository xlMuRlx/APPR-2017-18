# 3. faza: Vizualizacija podatkov


# Tabele:

prva <- tekme %>% filter(izid == "zmaga")
prva <- prva[-2]
prva <- prva %>% arrange(stevilo)
prva <- prva[c((nrow(prva)-19):nrow(prva)), ]

druga <- data.frame(table(koncne.uvrstitve$ekipa))
colnames(druga) <- c("ekipa", "st_udelezb")
druga <- right_join(druga, potegovanja) %>% group_by(ekipa) %>% 
  summarise(proc_uspesnost = round(st_udelezb / st_nastopov * 100, 2))
druga <- druga %>% arrange(proc_uspesnost)
druga <- druga[c((nrow(druga)-19):nrow(druga)), ]

tretja <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Brazil")) %>% 
  drop_na(uvrstitev)
tretja <- tretja[c(1, 3)]

cetrta <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Germany")) %>%
  drop_na(uvrstitev)
cetrta <- cetrta[c(1, 3)]

peta <- koncne.uvrstitve %>% group_by(ekipa) %>% 
  summarise(vsota = sum(uvrstitev, na.rm = TRUE))
peta <- left_join(peta, as.data.frame
                  (table((koncne.uvrstitve %>% filter(leto != 2018))$ekipa, 
                         dnn = c("ekipa"))))
peta <- peta %>% group_by(ekipa) %>% summarise(povp_uvrstitev = round(vsota / Freq, 1))
peta <- peta %>% arrange(povp_uvrstitev)
peta <- peta[c(1:20), ]

sesta <- koncne.uvrstitve %>% filter(uvrstitev == 1)
sesta <- sesta[1]
sesta <- as.data.frame(table(sesta), dnn = "ekipa")
colnames(sesta) <- c("ekipa", "st_naslovov")

sedma <- ucinkovitost %>% filter(tip == "dosezeni")
sedma <- sedma[c(1, 3)] %>% arrange(stevilo)
sedma <- sedma %>% filter(ekipa %in% peta$ekipa)




# Grafi:

graf.zmage <- ggplot(prva, aes(x = ekipa, y = stevilo)) + geom_bar(stat="identity")
graf.zmage <- graf.zmage + xlab("Država") + ylab("Število") + 
  ggtitle("Število zmag 20 ekip z največ zmagami")

graf.brazil <- ggplot(tretja, aes(x = leto, y = uvrstitev)) + geom_line(color = 'blue')
graf.brazil <- graf.brazil + xlab("Leto") + ylab("Uvrstitev") + 
  ggtitle("Končne uvrstitve Brazilije na svetovnih prvenstvih")

graf.nemcija <- ggplot(cetrta, aes(x = leto, y = uvrstitev)) + geom_line(color = 'red')
graf.nemcija <- graf.nemcija + xlab("Leto") + ylab("Uvrstitev") +
  ggtitle("Končne uvrstitve Nemčije na svetovnih prvenstvih")

graf.uvrstitve <- ggplot(peta, aes(x = ekipa, y = povp_uvrstitev)) + 
  geom_bar(stat = "identity", color = 'black', fill = 'blue')
graf.uvrstitve <- graf.uvrstitve + xlab("Država") + ylab("Uvrstitev") + 
  ggtitle("Povprečne uvrstitve najuspešnejših 20 držav")

graf.goli <- ggplot(sedma, aes(x = ekipa, y = stevilo)) + 
  geom_bar(stat = "identity", color = 'black', fill = 'blue')
graf.goli <- graf.goli + xlab("Država") + ylab("Število") + 
  ggtitle("Število doseženih zadetkov najuspešnejših 20 držav")


# Zemljevidi:

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",
                             "ne_110m_admin_0_countries") %>% pretvori.zemljevid()
zemljevid$SOVEREIGNT <- gsub("United States of America", "USA", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("North Korea", "Korea DPR", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("South Korea", "Korea Republic", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("Bosnia and Herzegovina", "Bosnia & Herzegovina",
                             zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("Ivory Coast", "Cote d Ivoire", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("Democratic Republic of the Congo", "Congo DR", 
                             zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("China", "China PR", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("Ireland", "Republic of Ireland", zemljevid$SOVEREIGNT)
zemljevid$SOVEREIGNT <- gsub("United Kingdom", "England", zemljevid$SOVEREIGNT)
# Zadnji korak storimo za približno ujemanje zemljevida in podatkov

graf.prvaki <- ggplot() + 
  geom_polygon(data = left_join(zemljevid, sesta, by = c("SOVEREIGNT" = "ekipa")),
               aes(x = long, y = lat, group = group, fill = st_naslovov)) +
  ggtitle("Vse zmagovalke svetovnih prvenstev") + xlab("") + ylab("") +
  guides(fill = guide_colorbar(title = "Število naslovov"))

graf.kvalificiranja <- ggplot() + 
  geom_polygon(data = left_join(zemljevid, druga, by = c("SOVEREIGNT" = "ekipa")),
               aes(x = long, y = lat, group = group, fill = proc_uspesnost)) +
  ggtitle("Procentualna uspešnost pri kvalificiranju") + xlab("") + ylab("") +
  guides(fill = guide_colorbar(title = "Procentualna uspešnost"))

