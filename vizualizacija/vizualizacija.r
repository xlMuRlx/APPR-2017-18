# 3. faza: Vizualizacija podatkov

prva <- tekme %>% filter(izid == "zmaga")
prva <- prva[-2]
prva <- prva %>% filter(stevilo > 10)
graf.zmage <- ggplot(prva, aes(x = ekipa, y = stevilo)) + geom_bar(stat="identity")
graf.zmage <- graf.zmage + xlab("Država") + ylab("Število zmag")

druga <- data.frame(table(koncne.uvrstitve$ekipa))
colnames(druga) <- c("ekipa", "st_udelezb")
druga <- right_join(druga, potegovanja) %>% group_by(ekipa) %>% 
  summarise(proc_uspesnost = round(st_udelezb / st_nastopov * 100, 2))
graf.kvalificiranja <- ggplot(druga, aes(x = ekipa, y = proc_uspesnost)) + 
  geom_bar(stat="identity")
graf.kvalificiranja <- graf.zmage + xlab("Država") + ylab("Procentualna uspešnost")



# Uvozimo zemljevid.
# zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
#                              "OB/OB", encoding = "Windows-1250")
# levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#   { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
# zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
# zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
# povprecja <- druzine %>% group_by(obcina) %>%
#  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
