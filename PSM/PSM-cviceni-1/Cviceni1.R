# Otevrete datovy soubor Kojeni.RData
#   data pouzita k vypracovani diplomove prace na PRF UK v roce 2000

library(DescTools)
library(TeachingDemos)

load("Kojeni.RData")

#################################
## Co je to p-hodnota
# ukazka na jednovyberovem t-testu

# Rozhodnete, zda stredni hodnota vysky matek muze byt mensi nez 168 cm?
# Testovane hypotezy:
#   H0: stredni hodnota vysky matek je rovna 168 cm
#   H1: stredni hodnota vysky matek je mensi nez 168 cm
# vyska lidi daneho veku ma normalni rozdeleni
#   pouzijeme jednovyberovy t-test
vyska <- Kojeni$vyskaM
t.test(vyska, mu=168, alternative = "less")
  # p-hodnota < 0.05 => zamitame H0, plati H1
  # t = -1.6777 (testová statistika)
  # df = 98 (degrees of freedom)
  # na hladine vyznamnosti 5% jsme prokazali, ze stredni hodnota vysky matek je mensi nez 168 cm.

## Vykresleni p-hodnoty
# t-test pracuje s testovou statistikou T: T = sqrt(n)*(mean(X) - mu)/sd(X)
#	pro tuto statistiku je pak definovana p-hodnota

# p-hodnota je pravdepodobnost, ze za platnosti nulove hypotezy
# 	nastane vysledek, ktery nastal,
# 	nebo jakykoliv jiny, ktery jeste vic vyhovuje alternative

# graf - definice p-hodnoty
# 1. pravdepodobnost, ze za platnosti nulove hypotezy ...
#   H0 rika, ze testova statistika a ma t-rozdeleni s n-1 stupni volnosti
plot(x <- seq(-4,4,by=0.1), y=dt(x,length(vyska)-1), type="l",
     col="blue", main="Hustota t-rozdeleni za H0")
  # hustota t-rozdeleni
  # t-rozdělení podobné normálnímu rozdělení ()
  # https://portal.matematickabiologie.cz/index.php?pg=aplikovana-analyza-klinickych-a-biologickych-dat--analyza-a-management-dat-pro-zdravotnicke-obory--resene-priklady--priklad-1-jednovyberovy-t-test
  # https://cs.wikipedia.org/wiki/T-test

# 2. nastane vysledek, ktery nastal ...
(T <- sqrt(length(vyska))*(mean(vyska) - 168)/sd(vyska))
  # testova statistika 
lines(c(T,T), c(0,dt(T,length(vyska)-1)), col="red", lwd=2)
  # zakreslim do grafu

# 3. nebo jakakoliv jina hodnota, ktera jeste vic odpovida alternative
#   alternativa je mensi nez
xx <- c(seq(-4, T, by=0.1), T, T, -4)
yy <- c(dt(c(seq(-4, T, by=0.1), T), length(vyska) - 1), 0, 0)
polygon(xx, yy, density=40,col="red")

# rucni vypocet p-hodnoty
# pravdepodobnost hodnot mensich nez testova statistika T
pt(T, length(vyska) - 1)
  # p-hodnota je distribucni funkce v hodnote testove statistiky

# v pripade oboustranne alternativy pridam jeste druhou skupinu hodnot 
#   - symetricky podle testove statistiky T
#	U otazky typu: Muze byt populacni prumer vysky matek 168 cm?
#   H0: vyska matek = 168 cm vs. H1: vyska matek != 168 cm
xx2 <- c(-T, -T, seq(-T, 4, by=0.1), 4, -T)
yy2 <- c(0, dt(c(-T, seq(-T, 4, by=0.1)), length(vyska) - 1), 0, 0)
polygon(xx2, yy2, density=40, col="green")

# rucni vypocet p-hodnoty
pt(T, length(vyska) - 1) + 1 - pt(-T, length(vyska) - 1)
  2*pt(T, length(vyska) - 1)
# pst je symetricka kolem nuly
t.test(vyska, mu = 168)
  # kontrolni test
  # p-hodnota 0.09659 > alfa 0.05 -> nezamitame H0
  #   neprokazalo se, ze by vyska matek nemohla byt rovna 168 cm
  #   muze byt rovna 168 cm, nebo je priblizne rovna 168 cm.


# Za předpokladu, že H0 je pravdivá, bychom tak nízkou výšku matek naměřili pouze ve 4.8 % případů.
# Protože je to méně než 5 %, říkáme, že to není náhoda a zamítáme H0.


# Jake rozdeleni ma p-hodnota za platnosti nulove hypotezy? 
#	Jaka je pst, ze Vam vyjde p < 0.05? A jaka je pst, ze Vam vyjde p < 0.5?
# Vyzkousime empiricky
#	Predpokladejme, ze IQ ma normalni rozdeleni se stredni hodnotou 100 a rozptylem 225
#   provedeme nahodny vyber z tohoto rozdeleni o rozsahu 200
#	  a otestujeme nulovou hypotezu, ze stredni hodnota = 100
#   ziskanou p-hodnotu zakreslim do grafu a cely postup opakuji 1000 krat
#	vysledkem bude graf rozdeleni p-hodnot

N <- 1000			# pocet vyberu
n <- 200			# pocet pozorovani v jednom vyberu
p.hodnoty <- rep(0,N)	# prazdny vektor pro prumery
for (i in 1:N){
  vyber<-round(rnorm(n,100,sqrt(225)),0)
  p.hodnoty[i] <- t.test(vyber,mu=100)$p.value
}
hist(p.hodnoty)
  # v idealnim pripade by vysly vsechny sloupce stejne vysoke
(Y <- sum(p.hodnoty <= 0.05)/N)
  # v kolika procentech pripadu vysla p-hodnota < 0.05
(Y <- sum(p.hodnoty <= 0.5)/N)
  # v kolika procentech pripadu vysla p-hodnota < 0.5

# => p-hodnota ma rovnomerne rozdeleni na intervalu [0,1]

# https://cs.wikipedia.org/wiki/Chyby_typu_I_a_II
# https://slideplayer.cz/slide/2336628/

## Co je sila testu
# Pravdepodobnost, ze zamitnu nulovou hypotezu, kdyz plati vybrana alternativa
# je to chyba druhého druhu
power.examp()
power.examp(diff = 3)
power.examp(n = 25)
power.examp(alpha = 0.1)

###################################

## Zjistete, zda stredni hodnota porodni hmotnosti deti muze byt 3.5 kg.
#   POZOR: porodni hmotnost se meri v gramech!
hmot <- Kojeni$por.hmotnost

# predpokladem jednovyberoveho t-testu je normalita dat
# Nejprve otestujeme normalitu
#   H0: data maji normalni rozdeleni vs. H1: data nemaji normalni rozdeleni
PlotQQ(hmot)
  # body lezi priblizne na primce
shapiro.test(hmot)
  # p-hodnota 0.1623 > alfa => nezamitam H0
  # i Q-Q plot, i test normality ukazuji, ze promenna ma priblizne normalni rozdeleni

# pouzijeme jednovyberovy t-test
# Testovane hypotezy: H0: porodni hmotnost = 3500 g  vs. H1: porodni hmotnost <> 3500 g
t.test(hmot, mu = 3500)
  # p-hodnota = 0.4943 > alfa => nezamitam H0
  # stredni porodni hmotnost deti muze byt 3.5 kg.

# Muze byt stredni hodnota vysky otcu vetsi nez 177 cm? (promenna vyskaO)
# Muze byt hmotnost pulrocni deti v prumeru 7.5 kg? (promenna hmotnost)

##################
## Jednovyberovy Wilcoxonuv test

# Jsou matky v prumeru starsi nez 23 let?
vek <- Kojeni2$vekM

# Nejprve otestujeme normalitu
#   H0: data maji normalni rozdeleni
#   H1: data nemaji normalni rozdeleni
PlotQQ(vek)
  # body lezi na oblouku - mam sesikmene rozdeleni
shapiro.test(vek)
  # p-hodnota 0.00134 < alfa => zamitam H0
  # i Q-Q plot, i test normality ukazuji, ze promenna nema normalni rozdeleni

# pouzijeme neparametricky test
# Testujeme
#   H0: median vekM = 23 vs. H1: median vekM > 23

# Wilcoxonuv test 
wilcox.test(vek, mu=23, alternative="greater")
  # p-hodnota 9.807e-09 < alfa 0.05 -> zamitam H0
  # Prokazali jsme, ze stredni hodnota veku matek je vetsi nez 23 let.

# Muze byt stredni hodnota delky pulrocnich deti 72 cm? (promenna delka)

##############################
## Dvouvyberovy t-test

## Lisi se porodni hmotnost mezi pohlavimi (porHmnotnost, Hoch)?
cislo <- Kojeni$porHmotnost
kategorie <- Kojeni$Hoch

# Normalita se testuje pro kazdou skupinu zvlast
#   H0: data maji normalni rozdeleni vs. H1: data nemaji normalni rozdeleni
par(mfrow=c(1,2))
tapply(cislo, kategorie, PlotQQ)
par(mfrow=c(1,1))
  # body lezi v obou pripadech priblizne na primce
tapply(cislo, kategorie, shapiro.test)
  # obe p-hodnoty vetsi nez alfa -> nezamitame H0, 
  #   data maji normalni rozdeleni -> pouziji t-test

# nejprve graficke zobrazeni
boxplot(cislo ~ kategorie, main="Porodni hmotnost podle pohlavi", col=c(2,4))
  # vidime poradi kategorii, muze se hodit

# testujeme hypotezy
# H0: por.hmotnost divek - por.hmotnost hochu = 0  
# H1: por.hmotnost divek - por.hmotnost hochu != 0

# Mame na vyber dva dvouvyberove t-testy:
#   pro shodne rozptyly
#   pro ruzne rozptyly

# Jsou rozptyly shodne?
# H0: rozptyly se nelisi;
# H1: rozptyly se lisi
var.test(cislo ~ kategorie)
  # p-hodnota = 0.886 > alfa (0.05) -> nezamitame H0
  #   rozptyly jsou priblizne shodne, pouzijeme t-test pro shodne rozptyly
t.test(cislo ~ kategorie, var.eq = T)
  t.test(cislo ~ kategorie, mu=0, alternative="two.sided", var.eq = T)
  # p-hodnota = 0.005512 < alfa (0.05) -> zamitame H0, plati H1
  #   porodni hmotnost se lisi podle pohlavi
  # A kdo ji ma vyssi?

# Spojitost s intervalem spolehlivosti pro rozdil 
MeanDiffCI(cislo ~ kategorie)
  # pocita pro variantu s ruznymi rozptyly
    
###############################
## Dvouvyberovy Wilcoxonuv test

## Lisi se vek maminek v Praze a na venkove (vekM, Porodnice)?
cislo <- Kojeni$vekM
kategorie <- Kojeni$Porodnice

# Normalita se testuje pro kazdou skupinu zvlast
#   H0: data maji normalni rozdeleni
#   H1: data nemaji normalni rozdeleni
par(mfrow=c(1,2))
tapply(cislo,kategorie,PlotQQ)
par(mfrow=c(1,1))
  # body lezi na obloucich v obou pripadech
tapply(cislo, kategorie, shapiro.test)
  # obe p-hodnoty < alfa -> zamitame H0, data nemaji normalni rozdeleni
  
# Wilcoxonuv test
#   H0: matky z Prahy - matky z venkova = 0
#   H1: matky z Prahy - matky z venkova != 0
# Graficky (data jsou pravostranně zešikmena)
boxplot(cislo ~ kategorie, main="Vek matky podle mista porodu")
  # vidime poradi kategorii, muze se hodit

# I u dvouvyberoveho Wilcoxonova testu je pozadavek na shodu rozptylu
#   H0: rozptyly se nelisi
#   H1: rozptyly se lisi
var.test(cislo ~ kategorie)
  # p-hodnota = 0.6589 > alfa (0.05) -> nezamitame H0
  # predpoklad shody rozptylu je splnen
wilcox.test(cislo ~ kategorie)
  # p-hodnota = 0.09097 > alfa (0.05) -> nezamitame H0
  #   neprokazalo se, ze by se vek matek v Praze a na venkove vyznamne lisil.
  wilcox.test(cislo ~ kategorie, conf.int = T)
    # vcetne neparametrickeho intervalu spolehlivosti a bodoveho odhadu "pseudomedianu"
    
## Jsou matky, ktere daly detem dudlika, v prumeru starsi nez ty, co jim ho nedaly? (promenne vekM, Dudlik)
# H0: Matky, které daly dudlík, nejsou v průměru starší než matky, které ho nedaly.
# H1: Matky, které daly dudlík, jsou v průměru starší.
vekM <- Kojeni$vekM
dudlik <- Kojeni$Dudlik
boxplot(vekM ~ dudlik, main="Věk matek podle používání dudlíku", xlab="Použití dudlíku", ylab="Věk matek", col=c("red", "blue"))
tapply(vekM, dudlik, shapiro.test)
wilcox.test(vekM ~ dudlik, alternative="less")
    
## Jsou pulrocni kluci v prumeru tezsi nez pulrocni divky? (promenne hmotnost, Hoch)
# H0: Půlroční kluci nejsou v průměru těžší než půlroční dívky
# H1: Půlroční kluci jsou v průměru těžší než půlroční dívky
hmotnost <- Kojeni$hmotnost
hoch <- Kojeni$Hoch
boxplot(hmotnost ~ hoch)
tapply(hmotnost, hoch, shapiro.test)
t.test(hmotnost ~ hoch, var.equal = FALSE, alternative = "less")
  
## Jsou matky v Praze i na venkove stejne vysoke? (promenne vyskaM, Porodnice)
## Je rozdil ve veku matek, ktere jeste v pul roce kojily a tech co nekojily? (promenne vekM, Koj24)

###############################
## Chi-kvadrat test
## Souvisi spolu vzdelani matky a pritomnost otce u porodu?
## Testuje závislost (H0: nezávislost, H1: závislost)
## Nejprve děláme tento test, a pak se teprve testují předpoklady
## Kdyby u chisq.test bylo upozornění, tak víme implicitně, že nejsou splněny předpoklady
vzdel <- Kojeni$Vzdelani
otec <- Kojeni$Otec

(tab <- table(vzdel,otec))
  prop.table(tab, 1)
  # absolutni a relativni cetnosti
plot(vzdel ~ otec, col=2:4, main = "Zavislost pritomnost otce u porodu na vzdelani matky")
  # ani tabulka, ani obrazek nenasvedcuji tomu, ze by mezi promennymi byla zavislost
  
# Testovane hypotezy 
#   H0: vzdelani matky a pritomnost otce u porodu spolu nesouvisi
#   H1: vzdelani matky a pritomnost otce u porodu spolu souvisi
chisq.test(vzdel, otec)
  # p-hodnota 0.8345 > alfa 0.05 => nezamitame H0
  # Neprokazala se souvislost mezi vzdelanim matky a pritomnosti otce u porodu.

# Test ma sve predpoklady: vsechny ocekavane cetnosti musi byt vetsi nez 5
# ex = expected
chisq.test(vzdel, otec)$ex
  # a jsou :)
  
# Kdyby nebyly, pouzili bychom Fisheruv exaktni test
fisher.test(vzdel, otec)
  # protoze predpoklady jsou splneny, p-hodnota vychazi podobne

## Souvisi spolu misto porodu a pohlavi
misto <- Kojeni$Porodnice
pohlavi <- Kojeni$Hoch

(tab <- table(misto,pohlavi))
prop.table(tab, 1)
  # Pravdepodobnost, ze se v Praze narodi holka
  tab[1,1]/tab[1,2]
    # sance, ze se v Praze narodi holka
  
chisq.test(tab)
  # p-hodnota blizka 1 > 0.05 => nezamitame H0
  # Neprokazal se rozdil mezi Prahou a okresem v pohlavi narozenych deti

fisher.test(tab)
  # na vystupu je videt pomer sanci
  # sance na to mit holku je v Praze o neco mensi nez v okrese

## Souvisi spolu vzdelani matky a to, zda bylo tehotenstvi planovane (Vzdelani, Plan)?
# H0: Nesouvisi spolu vzdělání matky a to, zda blyo těhotenství plánované
# H1: Souvisi spolu vzdělání matky a to, zda blyo těhotenství plánované
vzdelani <- Kojeni$Vzdelani
plan <- Kojeni$Plan
(tab <- table(vzdelani, plan))
chisq.test(tab) # p-value = 0.03545 < 0.05 (zamítáme H0 v prospěch H1) - souvisí
fisher.test(tab) # p-value = 0.03804 < 0.05 (zamítáme H0 v prospěch H1) - souvisí


## Souvisi pritomnost otce u porodu s mistem porodu (Otec, Porodnice)?
(tab <- table(misto, otec))
fisher.test(tab) # na okrese je šance skoro 6× větší (5.79× větší)

