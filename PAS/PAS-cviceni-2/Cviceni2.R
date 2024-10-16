# Popisná statistika
# - absolutní/relativní četnost
# - frekvenční rozdělení
# - polohy/variability
# ...
# Nainstalovat knihovnu DescTools

# Zobecnění na populaci
# Kategorická proměnná nominální/ordinální

# v zápočtu může být výstup z R a interpretujte graf
# - z intervalů od kvartilů k mediánu lze poznat zašikmení
# - lze to také vyčíst z rozdílu mezi mediánem a průměrem

# platy v tisících lidí: 27, 41, 25, 38, 320
# průměr = 90,2
# medián = 38
# průměr > medián : odlehlé vyšší hodnoty vpravo
# průměr < medián : odlehlé nižší hodnoty vlevo

rm(list=ls())
# vycisti pracovni prostor

# Nacteni databaze Cars93
library(MASS)
data(Cars93)
?Cars93
  # databaze 93 vozu prodavanych v USA v roce 1993, ktera se nachazi v knihovne MASS
  # popis promennych najdete v popisu databaze

##########################
### Opakovani z minula

## popisne statistiky pro nominalni (kategorickou neusporadanou) promennou
# jake typy/ tridy vozu byly v nabidce?
typ <- Cars93$Type
unique(typ) # jedna se o promennou ordinalni nebo nominalni? NEUSPOŘÁDANÁ (NOMINÁLNÍ)
ac<-table(typ)
ac # absolutní četnosti
rc<-prop.table(table(typ))
rc # relativní četnosti

# Tabulka - má výhodu, že může zobrazit jak absolutní, tak relativní četnosti
data.frame(cbind("Absolutni"=ac,"Procenta"=round(rc*100,2)))
  # tabulka cetnosti - co z ni vidite?
  # nejvíce a nejméně nabízených typů aut (nejvíce Midzise, nejméně Van)

# Sloupcový graf (měl by mít nadpis, musí mít popsané osy, popsané kategorie, zde je rozumější zobrazovat absolutní četnosti)
barplot(ac,col=2:7,main="Cetnosti trid automobilu",ylab="Absolutni cetnosti",ylim=c(0,max(ac)+2))
x <- barplot(ac,plot=F)[,1]
text(x,ac,labels=ac,pos=3)
popis<-paste(sort(unique(typ)),"(",round(rc*100,2),"%)")

# Koláčový graf (zde je rozumější zobrazovat procenta - tedy relativní četnosti)
pie(rc,lab=popis,col=2:7,main="Relativni cetnosti studijnich oboru")
  # A co je videt z grafu?

## popisne statistiky pro ordinalni promennou
# - můžeme přidat komulativní četnosti (cumsum)
# popiste, jake mely vozy Airbagy
ab <- Cars93$AirBags
unique(ab) # ordinální, uspořádané, protože 3 kategorie (bez airbagu, jen u řidiče, u řidiče i u spolujezdce)
(ac <- table(ab))
(kac<-cumsum(ac))
(rc<-round(prop.table(table(ab)),2))
(krc<-cumsum(rc))
data.frame(cbind("n(i)"=ac,"N(i)"=kac,"f(i)"=rc,"F(i)"=krc))
  # frekvencni rozdeleni - co z nej vidite?

# Jaká část má alespoň 1. airbag

# celkem 93 aut
# celkem 59 aut, které Driver only nebo Driver & Passenger

# n.i. - běžné absolutní četnosti
# N. i. - komulativní absolutní četnosti = v posledním řádku musí vyjít suma
# f. i. - běžné relativní četnosti
# F. i. - relativní absolutní četnosti = v posledním řádku musí vyjít 1.00 neboli 100%

barplot(ac,col=2:4,main="Airbagy v prodavanych vozech",ylab="Absolutni cetnosti",ylim=c(0,max(ac)+3))
x <- barplot(ac,plot=F)[,1]
text(x,ac,labels=ac,pos=3)
popis<-paste(sort(unique(ab)),"(",round(rc*100,2),"%)")
pie(rc,lab=popis,col=2:4,main="Airbagy v prodavanych vozech")
  # A co je videt z grafu?

## popisne statistiky pro ciselnou diskretni promennou
# popiste, kolik mely vozy valcu (Cylinders)
valce <- Cars93$Cylinders
(ac <- table(valce))
  valce2 <- droplevels(valce[valce != "rotary"])
    # zajimaji me jen pocty valcu, ne kategorie "rotary"
unique(valce2)
(ac<-table(valce2))
(kac<-cumsum(ac))
(rc<-round(prop.table(table(valce2)),2))
(krc<-cumsum(rc))
data.frame(cbind("n(i)"=ac,"N(i)"=kac,"f(i)"=rc,"F(i)"=krc))
# Pro číselné hodnoty se jmenuje tato tabulka frekvenční rozdělení
# nejvíc aut mělo 4 válce
# nejméně aut mělo 5 válců
# kolik aut mělo maximálně 5 válců = 0.58 (58%)

# Graf: Pro zobrazování frekvenčního rozdělení používat Frekvencni polygon
# Pokud je diskrétní a má hodně hodnot, tak pomocí Histogramu
x.val<-as.numeric(as.character(names(ac)))
ac.n<-as.numeric(ac)
  # zmena typu promenne kvuli popiskum na y-ove ose v grafu
plot(x.val,ac.n,type="h",lwd=3,col="darkgreen",main="Frekvencni polygon",
     xlab="Pocet valcu",ylab="Absolutni cetnosti")
x.val2<-min(x.val):max(x.val)
ac2<-rep(0,length(x.val2))
for(i in 1:length(x.val2)){
  for(j in 1:length(x.val)){if(x.val2[i]==x.val[j]){ac2[i]<-ac[j]}}
}
lines(x.val2,ac2,col="red")
  # Co graf rika? 

# Nabyva-li ciselna diskretni promenna mnoha hodnot, je mozne ji zobrazit
#   pomoci histogramu (jinak se většinou používá pro číselné spojité)
  # napriklad velikost motoru je jiste ciselna diskretni promenna

# Rozdělení Symetrická/Asymetrická
# Mírné zašikmení - mírná asymetrie
# Pravostranné zešikmení (většina hodnot je koncentrovaná k levé části grafu)
# Nejvíce vozů je v intervalu od 2-2.5
mot <- Cars93$EngineSize
hist(mot,col="skyblue",border="darkblue",main="Histogram",
     xlab="Velikost motoru",ylab="Absolutni cetnosti")
  # Jak je mozne komentovat vznikly graf? Co vime o tvaru jeho rozdeleni?

## Frekvencni rozdeleni pro ciselne promenne
# - spoctete frekvencni rozdeleni pro silu vozu (Horse power) - budeme ji vnímat jako spojitou
# - 1. Nakreslit histogram pomocí hist, aby si to Rko navolilo samo - dostanu 5 intervalů (rozdělí to po 50)
# - 2. Parametr breaks=10 - dělící body (ale ne nutně 10) - zde není potřeba
hp <- Cars93$Horsepower
hist(hp,col="skyblue",border="darkblue",main="Histogram",
     xlab="Sila vozu",ylab="Absolutni cetnosti")
  hist(hp,col="skyblue",border="darkblue",main="Histogram",
     xlab="Sila vozu",ylab="Absolutni cetnosti",breaks=10)
    # pomoci parametru "breaks" je mozne nastavit i jemnejsi deleni, 
    #   ale pro tabulku frekvencniho rozdeleni asi neni treba
hist(hp,plot=F)
deleni<-hist(hp,plot=F)$breaks
popis<-as.character(deleni[-1])
for(i in 1:length(popis)){
  popis[i]<-paste("(",deleni[i],",",deleni[i+1],"]")
}
ac<-hist(hp,plot=F)$counts
kac<-cumsum(ac)
rc<-round(ac/sum(ac),3)
krc<-cumsum(rc)
names(ac) <- popis
data.frame("n(i)"=ac,"N(i)"=kac,"f(i)"=rc,"F(i)"=krc)
  # Co z tabulky vsechno vyctu?

############################
# Krabicovy graf (boxplot)
# - vezmeme všechny horsepower, seřadím je od nejmenší po největší
# - v krabici medián (u lichého počtu je prostřední hodnota, u sudého je to průměr dvou prostředních - tedy pro 6 hodnot by to bylo (3+4)/2)
# - hranice krabice mezikvartalové rozpětí (dolní kvartil, horní kvartil)
# - nahoře MAX
# - odlehlé hodnoty (vědět kdy a jak je určit) = to jsou ty kroužky nahoře
# - dole MIN
boxplot(hp,col="yellow",border="orange3",main="Krabicovy graf",
        ylab="Sila vozu")
  # samostatne body ukazuji odlehla pozorovani
  boxplot(hp,col="yellow",border="orange3",main="Krabicovy graf",
        ylab="Sila vozu",range = 3)
    # graf bez odlehlych pozorovani

## Popisne statistiky polohy pro ciselnou promennou
# Co je v grafu videt
min(hp)
max(hp)
  # extremy
quantile(hp,0.25)
quantile(hp,0.75)
  # kvartily
median(hp)
  # median
fivenum(hp)
  # Jak byste promennou popsali na zaklade tohoto grafu?

mean(hp)
  # prumer
summary(hp)
  # zakladni popisne statistiky polohy
  # Jak lze komentovat tyto popisne statistiky?

## Spoctete frekvencni rozdeleni a nakreslete frekvencni polygon pro 
#   pocet spolucestujicich (promenna Passengers)
passengers <- Cars93$Passengers
ac <- table(passengers)
ac
unique(passengers)
ac<-table(passengers)
kac<-cumsum(ac)
rc<-round(prop.table(table(passengers)),2)
krc<-cumsum(rc)
data.frame(cbind("n(i)"=ac,"N(i)"=kac,"f(i)"=rc,"F(i)"=krc))

x.val<-as.numeric(as.character(names(ac)))
ac.n<-as.numeric(ac)
# zmena typu promenne kvuli popiskum na y-ove ose v grafu
plot(x.val,ac.n,type="h",lwd=3,col="darkgreen",main="Frekvencni polygon",
     xlab="Pocet spolucestujicich",ylab="Absolutni cetnosti")
x.val2<-min(x.val):max(x.val)
ac2<-rep(0,length(x.val2))
for(i in 1:length(x.val2)){
  for(j in 1:length(x.val)){if(x.val2[i]==x.val[j]){ac2[i]<-ac[j]}}
}
lines(x.val2,ac2,col="red")

## Spoctete popisne statistiky polohy pro delku vozu (promenna Length).
#   Co byste o teto promenne rekli na zaklade histogramu?
#   Porovnejte delku vozu pro americke a neamericke vozy.
delky <- Cars93$Length
summary(delky)
# Min - nejkratší auto
# Max - nejdelší auto
# Průměrná délka auta = 183.2
# Mezi 1. a 3. kvartilem se nachází 50% dat/hodnot
# hodně symetrické (hodně blízká nule)
# lehce levostranně sešikmenný, jednovrcholové rozdělení, pravděpodobně bez odlehlých hodnot
# průměr = medián -> napovídá tomu, že rozdělení bude spíše symetrické
hist(delky,col="skyblue",border="darkblue",main="Histogram",
     xlab="Délky vozů",ylab="Absolutni cetnosti")

# Vozy vyrobené v Americe jsou zpravidla delší, v průměru o cca 10 cm (rozdíl průměrů USA a Mean non-USA)
# I přesto ale nejmenší vozidlo, které se prodávalo bylo Americké
# USA - Symetričnost lze vyčíst z pozice mediánu v krabice (je rozdělena přesně v půlce), z pozice chvostů - jsou od MIN/MAX vzdálené celkem podobně
# non-USA - levostranné zašikmení
tapply(Cars93$Length, Cars93$Origin, summary)
boxplot(Cars93$Length ~ Cars93$Origin)

## Porovnejte cenu vozu podle poctu Airbagu.
# S počtem airbagů cena roste
# Všechny grafy by měly mít nadpis
tapply(Cars93$Price, Cars93$AirBags, summary)
boxplot(Cars93$Price ~ Cars93$AirBags)

# Pravostranné zešikmení
cena <- Cars93$Price
hist(cena,col="skyblue",border="darkblue",main="Histogram",
     xlab="Cena vozu",ylab="Absolutni cetnosti")
summary(cena) # spočítá popisné statistiky

#############################
## Popisne statistiky variability
# - čím širší krabice boxplotu, tím větší variabilita
install.packages("DescTools")
library(DescTools)
  # knihovna s uzitecnymi prikazy na popisne statistiky

# Jaka je variabilita delky vozu
delka <- Cars93$Length
var(delka)
sd(delka)
  # Zakladni charakteristiky variability odvozene od prumeru 
  # Vyberovy rozptyl a smerodatna odchylka
  # Jake maji jednotky, jak je interpretovat?
IQR(delka)
MAD(delka)
  # Robustni charakteristiky variability mene citlive na odlehla pozorovani
  # Mezikvartilove rozpeti a medianova absolutni odchylka okolo medianu
  # Jake maji jednotky, jak je interpretovat?
CoefVar(delka)
  # Variacni koeficient
  # Jake ma jednotky a jak ho interpretovat?

# Standardizovane veliciny - z.skory
z.val<-scale(delka)
  # Jak jsou velke? Co popisuji? K cemu se pouzivaji?

# Caharakteristiky tvaru rozdeleni
Skew(delka)
Kurt(delka)
  # Kolik vysly a co rikaji o tvaru rozdeleni?
  # Porovnat s histogramem?

# Popiste cenu vozu (promenna Price)
# Nakreslete grafy, vypoctete popisne statistiky polohy, variability 
#   a tvaru rozdeleni. Co Vam o datech rikaji?

# Jak popisne statistiky polohy, variability a tvaru rozdeleni reaguji 
#   na posunuti a zmenu meritka?
delka.p<-delka+10
delka.m<-delka*10
  # nove promenne
vyst<-matrix(NA,3,4)
vyst[1,1]<-mean(delka);vyst[1,2]<-sd(delka);vyst[1,3]<-Skew(delka);vyst[1,4]<-Kurt(delka)
vyst[2,1]<-mean(delka.p);vyst[2,2]<-sd(delka.p);vyst[2,3]<-Skew(delka.p);vyst[2,4]<-Kurt(delka.p)
vyst[3,1]<-mean(delka.m);vyst[3,2]<-sd(delka.m);vyst[3,3]<-Skew(delka.m);vyst[3,4]<-Kurt(delka.m)
rownames(vyst)<-c("delka","delka+10","delka*10")
colnames(vyst)<-c("Prumer","Sm.odchylka","Sikmost","Spicatost")
vyst

oldpar <- par(mfrow = c(1,3))
hist(delka,col="lightgreen")
hist(delka.p,col="lightgreen")
hist(delka.m,col="lightgreen")
par <- oldpar
  # tri histogramy