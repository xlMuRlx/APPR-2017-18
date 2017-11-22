# Analiza podatkov s programom R, 2017/18

Avtor: Andraž Mur

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

ANALIZA SVETOVNIH PRVENSTEV V NOGOMETU

Odločil sem se, da bom v projektu analiziral zgodovino Fifinih svetovnih prvenstev v nogometu, saj je nogomet najverjetneje globalno najbolj priljubljen šport in tudi meni najljubši, svetovna prvenstva pa so največji in najbolj zanimivi dogodek v tem športu. Natančneje bom analiziral uspešnost svetovnih držav pri kvalificiranju na prvenstva ter njihovo uspešnost na njih. Posebej si bom ogledal tudi najuspešnejše države v zgodovini svetovnih prvenstev, njihove najboljše uvrstitve ter njihovo učinkovitost.

Podatke bom črpal z Wikipedije, uporabil pa bom tudi podatke, ki so dostopni na uradni strani Mednarodne nogometne federacije (FIFA):
* https://en.wikipedia.org/wiki/FIFA_World_Cup
* https://en.wikipedia.org/wiki/National_team_appearances_in_the_FIFA_World_Cup#Comprehensive_team_results_by_tournament
* http://resources.fifa.com/mm/document/fifafacts/mencompwc/01/18/03/18/143975-factsheet-fifaworldcupall-timeranking_neutral.pdf


## Tabele

TABELA 1: USPEŠNOST DRŽAV PRI KVALIFICIRANJU NA SVETOVNA PRVENSTVA
Stolpci: 
* Država
* Leto prve uvrstitve na svetovno prvenstvo
* Število udeležb na svetovnih prvenstvih
* Procentualna uspešnost pri kvalificiranju

TABELA 2: USPEŠNOST DRŽAV NA ZAKLJUČNIH TURNIRJIH
Stolpci:
* Država
* Najboljša uvrstitev na svetovnem prvenstvu
* Število zmag na zaključnih turnirjih
* Število porazov na zaključnih turnirjih
* Število remijev na zaključnih turnirjih
* Dodatno bom še države, ki so kadarkoli osvojile naslov svetovnega prvaka, prikazal na zemljevidu.

TABELA 3: UČINKOVITOST DRŽAV NA SVETOVNIH PRVENSTVIH
Stolpci:
* Država
* Število odigranih tekem na zaključnih turnirjih
* Število vseh danih zadetkov na svetovnih prvenstvih
* Število vseh prejetih zadetkov na svetovnih prvenstvih
* Povprečno število zadetkov doseženih na tekmo


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
