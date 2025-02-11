### Cviceni k Pravdepodobnost a Statistika
## cvicici: Alena Cernikova, e-mail: alena.cernikova@ujep.cz

### Populace, reprezentativni vyber
# Vzhledem k jake populaci byste mohli tvorit reprezentativni vyber?
# Proc jste/ nejste reprezentativni vyber vzhledem ke vsem studentum VS v CR? 
#   Ke studentum UJEP? Ke studentum informatiky UJEP? Ke studentum tretiho rocniku UJEP?

# Nactete si datovy soubor Kojeni.RData
#   Data pouzita na zpracovani DP na PrF UK nekdy v roce 2001.
#   Data byla sbirana na jedne Prazske a jedne Kladenske porodnici
#   (v promenne Porodnice znaceno jako "Praha", "okresni")

# Pro jakou populaci by byl tento vyber reprezentativni?
#   Muze/nemuze byt reprezentativni ke vsem novorozencum v CR?
#     Ke vsem novorozencum v CR v roce 2001? Ke vsem stredoceskym novorozencum
#     v roce 2001? Je mozne zobecnit vysledek porovnani Prazske vs. okresni porodnice v roce 2001?
#     A co Praha vs. Kladno v roce 2001?

# Nactete si datovy soubor Okresy03.RData
#   jedna se o udaje o vsech okesech v CR v roce 2003
#   Pro jakou populaci je reprezentativni tento datovy soubor?

# datovy soubor airquality
data("airquality")
#   denni data hodnotici kvalitu ovzdusi v New Yorku v roce 1973.
#   Jak mohu zobecnit vysledky ziskane na techto datech? -Můžeme zobecnit vztah mezi Ozonen a teplotou.
#   Muzu delat zavery o koncentraci ozonu v letnich mesicich v USA?
#   Muzu zobecnovat vysledky o zavislosti koncentrace ozonu na povetrnostnich podminkach?

# datovy soubor esoph
data("esoph")
#   data z pripadove studie rakoviny jicnu z roku 1980 z Francie
# agegp - age group (věková skupina)
# alcgp - kolik vypije alkoholu za den
# tobgp - kolik vykouří za den
# ncases - počet pacientů, kteří měli rakovinu jícnu
# ncontrols - počet pacientů, kteří neměli rakovinu jícnu
#   pocty lidi s rakovinou jicnu pri ruznych kombinacich veku, konzumace alkoholu a koureni
#   jake zavery mohu zobecnit? Jak zarucit, abych mohla zobecnit? -Tím, že ověříme i další státy, např. USA, 2 státy z Afriky, ... mohou používat jiný tabák apod.

# datovy soubor ChickWeight
data("ChickWeight")

#   vaha kurat spolu s jejich vekem a stravou, kterou dostavala
#   promenne: weight - vaha, time - vek kurete ve dnech, chick - identifikator kurete, diet - oznaceni vyzivy
#   co mohu z takovychto dat zjistit? 
# -Jak moc kuřata rostou s výživou, zobecnit by měla jít na všechny státy, např. drůbežárna v Německu, tak to bude platit i v USA (za stejných podmínek), ve stejný rok, ale ne třeba za 20 let, protože může dojít ke genetické změně

# Jak bych mela udelat vyber, kdyby me zajimal prumerny prijem obyvatel CR?
# -co nejvíce náhodně (kraj, město/vesnice, pestrost zaměstnání, věk, pohlaví)

# Jak bych mela udelat vyber, kdyby me zajimalo porovnani nazoru studentu PrF UJEP a FSE UJEP.
# - katedry, pohlaví, ročník, prezenční/kombinované studium, bydliště studenta

# Jakym zpusobem bych mohla porovnavat chut dvou jogurtu? Ktery lidem chutna vic.
# - člověk musí ochutnat oba, vesnice/město, věk, pohlaví, 

#################################
### Typy promennych
# Jakeho typu jsou promenne v databazi ChickWeight? 
#   Mate na vyber> ciselne spojite (váha, výška, teplota), ciselne diskretni (počet), nominalni (malý počet kategorií, kategorie jsou neuspořádané, barva, těžký/lehký), ordinalni (kategorie jsou uspořádané, známka z předmětu, lehký/středně těžký/těžký).
#   Ze kterych promennych mohu pocitat prumer?

# z číselných má smysl počítat třeba průměr, z kategoriálních ne

# weight - číselná spojitá
# time - číselná diskrétní (měřilo se v konkrétních hodnotách, nebyla připouštěna třeba hodnota 5)
# chick - kategorická (je to kategorická proměnná, je to toto kuře nebo toto kuře, čísla mohla být rozdána kuřatům jinak)
# diet - kategorická nominální (ale pokud je nějaká charakteristika výživ, že 1 znamená že dostali víc jídla, 2 že míň, tak by to byla ordinální - ale tuhle informaci nemáme)

# Vratme se k databazi Kojeni
# Jakeho typu jsou promenne v teto databazi? 
#   Zajimavost: jak je mozne zapsat promennou pohlavi

# trvani - doba kojení v týdnech - číselná
# pocetDeti - číselná diskrétní
# vzdelani - kategoriální ordinální
# porHmotnost - číselná spojitá
# vyskaM - číselná spojitá
# Otec - kategorická nominální (dichotomická - má jen 2 možnosti)
# Koj24 - kategorická nominální (dichotomická - má jen 2 možnosti)
# pohlaví lze kódovat jako 0 a 1, TRUE/FALSE nebo prostě chlapec/dívka (NEPOČÍTAT PRŮMĚR)

#################################
### Popis kategoricke promenne
# absolutni (počty) a relativni cetnosti (procenta), kumulativni absolutni a relativni cetnosti

# počet - kolik máme chlapců a dívek (případně procentuální zastoupení)


## nominalni promenna
# vypoctete absolutni a relativni cetnosti promenne Hoch
load("Kojeni.RData") 
View(Kojeni)

load("Okresy03.RData")
View(Okresy)

Hoch <- Kojeni$Hoch


# absolutni cetnosti
table(Hoch)

# relativní četnosti v procentech
prop.table(table(Hoch))*100

# relativni cetnosti v procentech zaokrouhlené na 2 desetinná místa
round(prop.table(table(Hoch))*100,2)

cbind("absolutni"=table(Hoch),"relativni"=round(prop.table(table(Hoch))*100,2))


  # v jedne tabulce
  # ma smysl resit kumulativni cetnosti?

# vypoctete absolutni a relativni cetnosti pro misto porodu   
# vytvorte kombinovanou promennou pro pohlavi a misto porodu a 
#   vypoctete pro ni absolutni a relativni cetnosti. 
#   A co by mi zde rekly kumulativni cetnosti?


hoch <- Kojeni$hoch
Porodnice <- Kojeni$Porodnice

Por.poh<-ifelse(hoch == 1 & Porodnice == "Praha", "Hoch z Prahy", "Hoch z venkova")
Por.poh<-ifelse(hoch == 0 & Porodnice == "Praha", "Divka z Prahy", Por.poh)
Por.poh<-ifelse(hoch == 0 & Porodnice == "okresní", "Divka z venkova", Por.poh)

# Absolutní četnosti
table(Por.poh)

# Relativní četnosti v procentech
prop.table(table(Por.poh)) * 100

# Relativní četnosti v procentech zaokrouhlené na 2 desetinná místa
round(prop.table(table(Por.poh)) * 100, 2)

# Koláčový graf je vhodný pro zobrazování relativní četnosti kategorické proměnné
# (100 % rozdělí na výseče)
# Dále je vhodný sloupcový graf
# Pro grafy by šel také ggplot

# Kumulativní absolutní/relativní četnosti
# - https://cs.wikipedia.org/wiki/Kumulativn%C3%AD_%C4%8Detnost¨
# - cumsum
# kolik studentů dostalo jedničku
# kolik studentů dostalo lepší známku než tři
# kolik studentů prošlo u zkoušky
# kolik studentů šlo celkem ke zkoušce
# př. kolik jsme měli maminek, kteří měli max. maturitu?

cumsum()

# Jaky graf byste pouzili pro nominalni promennou?
## POZOR: Kazdy graf musi mit nazev a oznaceni os, jinak se krati body!!!
barplot(table(Por.poh),col=2:5,main="Sloupcovy graf")
  # sloupcovy graf
pie(table(Por.poh),col=2:5,main="Kolacovy graf")
  # kolacovy graf
# popisky jednotlivych bodu
leg<-sort(unique(Por.poh))
rc<-round(prop.table(table(Por.poh))*100,2)
for(i in 1:length(leg)){
  leg[i]<-paste(leg[i],"(",rc[i],"%)")
}
pie(table(Por.poh),col=2:5,main="Kolacovy graf",labels=leg)

## ordinalni promenna
# vypoctete absolutni a relativni cetnosti pro promennou Vzdelani
Vzdel <- Kojeni$Vzdelani
table(Vzdel)
(ac<-table(Vzdel))
  # absolutni cetnosti
(rc<-round(prop.table(table(Vzdel)),2))
  # relativni cetnosti
cbind("absolutni"=ac,"relativni"=rc)
  # a jak je to zde s kumulativnimi cetnostmi?

(kac<-cumsum(ac))
  #  kumulativni absolutni cetnosti
(krc<-cumsum(rc))
  # kumulativni relativni cetnosti
cbind("n(i)"=ac,"N(i)"=kac,"p(i)"=rc,"P(i)"=krc)
  # vsechny cetnosti v jedne tabulce

# Jake grafy byste pouzili pro ordinalni promennou?

# Pouzijte data mtcars
data("mtcars")
#   data o autech z roku 1974
#   promenne: mpg - ujete mile na galon benzinu, cyl - pocet valcu,
#             disp - objem, hp - sila vozu, drat - pomer zadni osy,
#             wt - vaha, qsec - za jak dlouho ujedou 1/4 mile,
#             vs - typ motoru: 0 - ve tvaru V, 1 - primy,
#             am - prevodovka: 0 - automaticka, 1 - manualni
#             gear - pocet rychlosti, carb - pocet karburatoru 
# urcete v nich typy promennych a pro ty kategoricke (nominalni i ordinalni)
#   spocitejte popisne statistiky


plot(mtcars$hp, mtcars$mpg,
     main = "Vztah mezi výkonem motoru a spotřebou paliva",
     xlab = "Výkon motoru (hp)",
     ylab = "Spotřeba paliva (mpg)",
     pch = 20, col = "blue")

# Přidání lineární regrese
abline(lm(mpg ~ hp, data = mtcars), col = "red", lwd = 2)

# Přidání LOESS křivky pro nelineární trend
lines(lowess(mtcars$hp, mtcars$mpg), col = "green", lwd = 2)

# Přidání legendy
legend("topright", 
       legend = c("Data", "Lineární regrese", "LOESS křivka"),
       col = c("blue", "red", "green"),
       pch = c(20, NA, NA),
       lty = c(NA, 1, 1),
       lwd = c(NA, 2, 2))

# Přidání mřížky
grid()

