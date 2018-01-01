# 3. faza: Vizualizacija podatkov


# Tabele:

prva <- tekme %>% filter(izid == "zmaga")
prva <- prva[-2]
prva <- prva %>% arrange(stevilo)
prva <- prva[c((nrow(prva)-19):nrow(prva)), ]
prva <- prva %>% arrange(ekipa)

druga <- data.frame(table(koncne.uvrstitve$ekipa))
colnames(druga) <- c("ekipa", "st_udelezb")
druga <- right_join(druga, potegovanja) %>% group_by(ekipa) %>% 
  summarise(proc_uspesnost = round(st_udelezb / st_nastopov * 100, 2))
druga <- druga %>% arrange(proc_uspesnost)
druga <- druga[c((nrow(druga)-19):nrow(druga)), ]

tretja <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Brazil"))

cetrta <- data.frame(koncne.uvrstitve %>% filter(ekipa == "Germany"))

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


# Grafi:

graf.zmage <- ggplot(prva, aes(x = ekipa, y = stevilo)) + geom_bar(stat="identity")
graf.zmage <- graf.zmage + xlab("Država") + ylab("Število zmag") + 
  ggtitle("Število zmag 20 ekip z največ zmagami")

graf.kvalificiranja <- ggplot(druga, aes(x = ekipa, y = proc_uspesnost)) + 
  geom_bar(stat="identity")
graf.kvalificiranja <- graf.zmage + xlab("Država") + ylab("Procentualna uspešnost") + 
  ggtitle("Procentualna uspešnost pri kvalificiranju 20 najuspešnejših držav")

graf.brazil <- ggplot(tretja, aes(x = leto, y = uvrstitev)) + geom_line(color = 'blue')
graf.brazil <- graf.brazil + xlab("Leto") + ylab("Končna uvrstitev") + 
  ggtitle("Končne uvrstitve Brazilije na svetovnih prvenstvih")

graf.nemcija <- ggplot(cetrta, aes(x = leto, y = uvrstitev)) + geom_line(color = 'red')
graf.nemcija <- graf.nemcija + xlab("Leto") + ylab("Končna uvrstitev") +
  ggtitle("Končne uvrstitve Nemčije na svetovnih prvenstvih")

graf.uvrstitve <- ggplot(peta, aes(x = ekipa, y = povp_uvrstitev)) + 
  geom_bar(stat = "identity", color = 'black', fill = 'blue')
graf.uvrstitve <- graf.uvrstitve + xlab("Država") + ylab("Povprečna uvrstitev") + 
  ggtitle("Povprečne uvrstitve najuspešnejših 20 držav")


# Zemljevidi:

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",
                             "ne_110m_admin_0_countries") %>% pretvori.zemljevid()


# Uvozimo zemljevid.
# zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
#                              "OB/OB", encoding = "Windows-1250")
# levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#   { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
# zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
# zemljevid <- pretvori.zemljevid(zemljevid)

