rm(list=ls())
# vycisti pracovni prostor

# Nacteni databaze Policie.RData
#   vysledky testu na rychlost reakce spolu s fyziologickymi udaji

# aktivace knihovny s popisnymi statistikami
library(DescTools)

##########################
### Opakovai z minula

## Popisne statistiky polohy
# Vyzkousejte na promenne vaha (weight)

vaha <- Policie$weight
summary(vaha) # základní popisné statistiky polohy
boxplot(vaha,main="Krabicovy graf vahy policistu", ylab="Vaha v kg", col="wheat",border="tan4")
hist(vaha, main="Histogram vahy policistu", xlab="Vaha v kg", ylab="Pocty",col="palegreen", border="darkgreen")
  # co mohu o promenne rici?

##########################
## Popisne statistiky variability
# rozptyl - my budeme brát výběrový rozptyl (https://www.datova-akademie.cz/slovnik-pojmu/rozptyl/)
# směrodatná ochylka
# mezikvartalové rozpětí

# Jaka je variabilita promenne vaha?
var(vaha) # nemá interpretaci (vyberovy rozptyl) - výsledek v kg^2
sd(vaha) # směrodatná odchylka (odmocnina z rozptylu) - výsledek v kg
  # Zakladni charakteristiky variability odvozene od prumeru 
  # Vyberovy rozptyl a smerodatna odchylka
  # Jake maji jednotky, jak je interpretovat?
  prop.table(table(vaha>(mean(vaha)-sd(vaha)) & vaha<(mean(vaha)+sd(vaha))))
    # hodnoty v intervalu prumer plus/minus smerodatna odchylka
IQR(vaha) # Interquartile Range, mezikvartalové rozpětí (šířka krabice v boxplotu) - od dolního kvartilu k hornímu kvartilu
MAD(vaha) # Median Absolute Deviation, absolutní ochylky od mediánu
  # Robustni charakteristiky variability mene citlive na odlehla pozorovani
  # Mezikvartilove rozpeti a medianova absolutni odchylka okolo medianu
  # Jake maji jednotky, jak je interpretovat?
CoefVar(vaha)
  # Variacni koeficient (koeficient variace) - pan docent ho ale prý nemá moc rád
  # Jake ma jednotky a jak ho interpretovat?
  # počítá se jako cv(x) = sd(x) / x s čárkou nahoře (aritmetický průměr)
  # udává se v procentech

## Porovnejte variabilitu pulsu a diastolickeho tlaku
# - puls má větší variabilitu
puls <- Policie$pulse
tlak <- Policie$diast

sd(puls); sd(tlak) 
IQR(puls); IQR(tlak)
CoefVar(puls); CoefVar(tlak)

##########################
## Popisne statistiky tvaru rozdeleni (https://www.datova-akademie.cz/popisna-statistika-miry-tvaru/)
# Šikmost - funkce Skew
# - symetrická (šikmost=0) 
# - kladná (šikmost>0) - pravostranné zešikmení
# - záporná (šikmost<0) - levostranné zešikmení
# Špičatost - funkce Kurt
# - špičatost=0
# - špičatost>0
# - špičatost<0

# stale pro promennou vaha
# charakteristiky tvaru rozdeleni se pocitaji z standardizovanych velicin
z.vaha<-scale(vaha)
  # z-skory
  # Jak jsou velke? Co popisuji? K cemu se pouzivaji?
  mean(z.vaha);sd(z.vaha) # 0,0000000000000005278 (5.278e-16)
  
# Standardizace - vezmu původně naměřené hodnoty, odečtu od nich průměr a vydělím je směrodatnou odchylkou
# - výsledkem jsou standardizované veličiny (též nazývané z score)
# - některé výsledky budou záporný, některý kladný
# - průměr z score ale bude vycházet vždy 0
# - směrodatná odchylka z score bude vycházet 1
# - tedy standardizujeme veličiny tak, aby to tak vycházelo

# Charakteristiky tvaru rozdeleni (příkazy Skew a Kurt to již standardizují)
Skew(vaha) # šikmost (pro symetrické rozdělení by byla nulová, pro pravostranné by byla kladná a pro levostranné by byla záporná)
  # sikmost - prumer ze tretich mocnin z-skoru
Kurt(vaha) # špičatost (od hodnoty -0.5 nebo 0.5 už jde špičatost celkem vidět)
  # spicatost - prumer ze ctvrtych mocnin z-skoru minus 3
  # Kolik vysly a co rikaji o tvaru rozdeleni?
  # Porovnat s histogramem?

## Spoctete charakteristiky tvaru rozdeleni promenne react (reakcni doba).)

Skew(Policie$react) # pravostranné zašikmení (protože vyšla kladná)
Kurt(Policie$react) # špičatá
hist(Policie$react, main="Histogram reakcni doby policistu", xlab="Reakcni doba v ms", ylab="Pocty",col="palegreen", border="darkgreen")
# jdu nejdřív rychle nahoru, a pak klesám

#   Co byste rekli o jejim tvaru rozdeleni (histogramu)?
## Nakreslete histogram promenne fat. Odhadnete z nej popisne statistiky. 

hist(Policie$fat, main="Histogram mnozstvi tuku policistu", xlab="Tuk v %", ylab="Pocty",col="palegreen", border="darkgreen")
# a bude mírné pravostranné zašikmení
# řekl bych, že výjde vysoká špičatost
Skew(Policie$fat)
Kurt(Policie$fat)
# nakonec špičatost nebyla tak vysoká, jak jsem předpokládal

## Spoctete vsechny popisne statistiky vysky policistu a komentujte je
#   Co z nich plyne pro grafy?

vyska <- Policie$height
summary(vyska) # polohy
sd(vyska) # variability - směrodatná odchylka
IQR(vyska) # variability
Skew(vyska) # tvaru rozdělení
Kurt(vyska) # tvaru rozdělení

boxplot(vyska)

# mírně asymetrický
# celkem odpovídá gausově rozdělení
# velice mírné zašikmení pravostranné
# úplně malinkatý sloupeček na pravo jsou odlehlé hodnoty
# 175-180 nejvyšší sloupec
hist(vyska)

##########################
## Jak popisne statistiky polohy, variability a tvaru rozdeleni reaguji 
#   na posunuti a zmenu meritka?
vaha.p<-vaha+10
vaha.m<-vaha*10
  # nove promenne
vyst<-matrix(NA,3,4)
vyst[1,1]<-mean(vaha);vyst[1,2]<-sd(vaha);vyst[1,3]<-Skew(vaha);vyst[1,4]<-Kurt(vaha)
vyst[2,1]<-mean(vaha.p);vyst[2,2]<-sd(vaha.p);vyst[2,3]<-Skew(vaha.p);vyst[2,4]<-Kurt(vaha.p)
vyst[3,1]<-mean(vaha.m);vyst[3,2]<-sd(vaha.m);vyst[3,3]<-Skew(vaha.m);vyst[3,4]<-Kurt(vaha.m)
rownames(vyst)<-c("vaha","vaha+10","vaha*10")
colnames(vyst)<-c("Prumer","Sm.odchylka","Sikmost","Spicatost")
vyst

oldpar <- par(mfrow = c(1,3))
hist(vaha,col="lightgreen")
hist(vaha.p,col="lightgreen")
hist(vaha.m,col="lightgreen")
par(oldpar)
  # tri histogramy
  
#######################
## Vypocet modusu pro ciselna data
# Nejprve mmusime urcit, kolik vrcholu (modu) promenna ma - z histogramu

# Vyšetřování modality - hledání počtu vrcholů a kde leží
# modus - nejpočetnější kategorie
# pokud máme ale číselnou proměnnou, tak je to složitější (jak u diskrétních, tak u spojitých)

# lokální (může jich být víc) a absolutní (je pouze jeden)

# Zkuste pro vysku policistu
# Výška je spojitá proměnná (i když je měřena diskrétně)
vyska <- Policie$height
hist(vyska,col="skyblue",border="darkblue",main="Histogram",
     xlab="Vyska policistu",ylab="Absolutni cetnosti")
  # Promenna ma jeden vrchol (modus) a lezi mezi hodnotami 60 a 70

# Pro promennou ciselnou spojitou se modus hleda z jadroveho odhadu hustoty
jadro <- density(vyska)
  # vytvoreni jadroveho odhadu
# zakreslenido grafu
hist(vyska,col="skyblue",border="darkblue",main="Histogram",
     xlab="Vyska policistu",ylab="Absolutni cetnosti",freq=F) # freq=F nechceme v četnostích, ale v hustotě
  # nakresleni histogramu s "hustotou" y-ove ose
lines(jadro)
jadro # charakteristika jádrového odhadu (bandwidth)
  # prikresleni jadroveho odhadu do grafu
# kde ma jadrovy odhad vrchol?
jadro$x[which.max(jadro$y)] # pro max pro y souřadnici chci vědět x
  # hledam takovou souradnici na x-ove ose, aby na te y-ove bylo maximum
  # kdyby jich bylo vice, tak musím hledat lokálně (tedy říct od této hodnoty do této hodnoty)

## Najdete modus(y) pro reakcni dobu
## Najdete modus(y) pro vahu
  # pres zmenu parametru bandwith (bw) muzete menit miru vyhlazeni hustoty
react_jadro <- density(Policie$react)
hist(Policie$react, freq=F)
lines(react_jadro)
react_jadro$x[which.max(react_jadro$y)]

# Máme málo měření, takže pomocí breaks (zmenší počet sloupců, ale ne nutně na 5)
# Tím zjistíme, že se jedná o jednovrcholové rozdělení (jádrový odhad navíc kreslí jen jeden vrchol, ne více)
# Pokud bychom to chtěli vnímat tak, že jsou tam 4 vrcholy, tak snížit bw
# Ale u váhy dává smysl jen jeden vrchol
vaha_jadro <- density(Policie$weight)
hist(Policie$weight, freq=F, breaks = 5)
lines(vaha_jadro)
vaha_jadro$x[which.max(vaha_jadro$y)]


## Pro ciselnou diskretni se modus hleda z nejvyssiho sloupce
# Vypocet pro puls
  # podle vzorce Modus = A + h * d0/(d0+d1)
puls <- Policie$pulse
hist(puls,col="skyblue",border="darkblue",main="Histogram",
     xlab="Puls policistu",ylab="Absolutni cetnosti")
# Modus je v intervalu 60-70, tedy
A <- 60
h <- 10
hist(puls,plot=F)
cetnosti<-hist(puls,plot=F)$counts
d0<-cetnosti[3]-cetnosti[2]
d1<-cetnosti[3]-cetnosti[4]
(modus <- A + h*d0/(d0+d1))

# Vypoctete modus pro diastolicky tlak

###########################
## Odlehla pozorovani
# Jak je to s odlehlym pozorovanim u procenta tuku?
tuk <- Policie$fat
boxplot(tuk,col="yellow",border="orange3",main="Krabicovy graf",
        ylab="Procento tuku policistu")
  # Krabicovy graf znazornil jedno odlehle pozorovani.
  # Je to ale skutecne odlehle pozorovani?
  # klasicka definice odlehleho pozorovani funguje jen pro symetricka data
Skew(tuk)
hist(tuk,col="skyblue",border="darkblue",main="Histogram",
     xlab="Procento tuku policistu",ylab="Absolutni cetnosti")
  # sesikmeni je zrejme, ale neni kriticke
  # pozorovani muzeme, nebo nemusime povazovat za odlehle
# Zvysime-li hranici pro odlehle pozorovani na 3 IQR
boxplot(tuk,col="yellow",border="orange3",main="Krabicovy graf",
        ylab="Procento tuku policistu",range=3)
  # uz se jako odlehle nezobrazi

# Jak je to s odlehlym pozorovanim u diastolickeho tlaku?
#   kde jsou hranice odlehlosti?
