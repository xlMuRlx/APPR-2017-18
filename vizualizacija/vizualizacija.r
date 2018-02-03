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
druga$ekipa <- gsub("Northern  Ireland", "Northern Ireland", druga$ekipa)

tretja <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Brazil")) %>% 
  drop_na(uvrstitev)
tretja <- tretja[c(2, 3)]

cetrta <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Germany")) %>%
  drop_na(uvrstitev)
cetrta <- cetrta[c(2, 3)]

peta <- koncne.uvrstitve %>% group_by(ekipa) %>% 
  summarise(vsota = sum(uvrstitev, na.rm = TRUE))
peta <- left_join(peta, as.data.frame
                  (table((koncne.uvrstitve %>% filter(leto != 2018))$ekipa, 
                         dnn = c("ekipa"))))
peta <- peta %>% group_by(ekipa) %>% summarise(povp_uvrstitev = round(vsota / Freq, 1))
peta <- peta %>% arrange(povp_uvrstitev)

sesta <- koncne.uvrstitve %>% filter(uvrstitev == 1)
sesta <- sesta[1]
sesta <- as.data.frame(table(sesta), dnn = "ekipa")
colnames(sesta) <- c("ekipa", "st_naslovov")

sedma <- ucinkovitost %>% filter(tip == "dosezeni")
sedma <- sedma[c(1, 3)] %>% arrange(stevilo)
sedma <- sedma %>% filter(ekipa %in% peta$ekipa)




# Grafi:

graf.zmage <- ggplot(prva, aes(x = reorder(ekipa, -stevilo), y = stevilo)) + geom_col() +
  xlab("Država") + ylab("Število zmag") + ggtitle("Število zmag 20 ekip z največ zmagami") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

graf.brazil <- ggplot(tretja, aes(x = leto, y = uvrstitev)) + geom_line(color = 'blue')
graf.brazil <- graf.brazil + xlab("Leto") + ylab("Uvrstitev") + 
  ggtitle("Končne uvrstitve Brazilije na svetovnih prvenstvih")

graf.nemcija <- ggplot(cetrta, aes(x = leto, y = uvrstitev)) + geom_line(color = 'red')
graf.nemcija <- graf.nemcija + xlab("Leto") + ylab("Uvrstitev") +
  ggtitle("Končne uvrstitve Nemčije na svetovnih prvenstvih")

graf.uvrstitve <- ggplot(peta[c(1:20), ], aes(x = reorder(ekipa, povp_uvrstitev),
                                   y = povp_uvrstitev)) + geom_col(color = 'black', 
                                                                   fill = 'blue')
graf.uvrstitve <- graf.uvrstitve + xlab("Država") + ylab("Uvrstitev") + 
  ggtitle("Povprečne uvrstitve najuspešnejših 20 držav") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

graf.goli <- ggplot(inner_join(peta[c(1:20), ], sedma), 
                    aes(x = reorder(ekipa, povp_uvrstitev), y = stevilo)) + 
  geom_col(color = 'black', fill = 'blue')
graf.goli <- graf.goli + xlab("Država") + ylab("Zadetki") + 
  ggtitle("Število doseženih zadetkov najuspešnejših 20 držav") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



# Zemljevidi:

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_map_units.zip",
                             "ne_110m_admin_0_map_units", encoding = "UTF-8") %>%
  pretvori.zemljevid()
zemljevid$NAME_LONG <- gsub("United States", "USA", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Dem. Rep. Korea", "Korea DPR", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Republic of Korea", "Korea Republic", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Bosnia and Herzegovina", "Bosnia & Herzegovina",
                             zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Côte d'Ivoire", "Cote d Ivoire", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Democratic Republic of the Congo", "Congo DR", 
                             zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("China", "China PR", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Ireland", "Republic of Ireland", zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Northern Republic of Ireland", "Northern Ireland", 
                            zemljevid$NAME_LONG)
zemljevid$NAME_LONG <- gsub("Russian Federation", "Russia", zemljevid$NAME_LONG)


graf.prvaki <- ggplot(data = zemljevid %>% filter(CONTINENT %in% c("Europe", "South America"),
                                                  NAME_LONG != "Russia") %>%
                        left_join(sesta, by = c("NAME_LONG" = "ekipa"))) + 
  geom_polygon(aes(x = long, y = lat, group = group, fill = st_naslovov), color = "black") +
  geom_text(data = inner_join(zemljevid, sesta, by = c("NAME_LONG" = "ekipa")) %>%
              group_by(NAME_LONG, CONTINENT) %>%
              summarise(avg_long = mean(long), avg_lat = mean(lat)),
            aes(x = avg_long, y = avg_lat, label = NAME_LONG), color = "red") +
  facet_wrap(~ reorder(CONTINENT, -as.numeric(CONTINENT)), scales = "free") +
  ggtitle("Vse zmagovalke svetovnih prvenstev") + xlab("") + ylab("") +
  guides(fill = guide_colorbar(title = "Število naslovov"))

graf.kvalificiranja <- ggplot() + 
  geom_polygon(data = left_join(zemljevid, druga, by = c("NAME_LONG" = "ekipa")),
               aes(x = long, y = lat, group = group, fill = proc_uspesnost)) +
  ggtitle("Procentualna uspešnost pri kvalificiranju") + xlab("") + ylab("") +
  guides(fill = guide_colorbar(title = "Procentualna uspešnost"))

seznam <- as.list(skupine$povp_uvrstitev)
for (i in 1:length(seznam)) {
  seznam[i] = paste("Povprečna uvrstitev izbrane ekipe je", as.character(skupine$povp_uvrstitev),
                    ", ekipa pa je na prvenstvih skupno zmagala", 
                    as.character(skupine$st_zmage), "zmag.")
}
names(seznam) <- skupine$ekipa