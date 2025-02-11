######################
## Interval spolehlivosti

library(DescTools)
load("Kojeni.RData")
# aktivace knihovny

# Nactete data Kojeni.RData
## Spoctete 95% interval spolehlivosti pro prumer vysky muzu (otcu) kdyz vite, 
#  ze rozptyl vysky dospelych muzu je 49.
vyska <- Kojeni$vyskaO

# vypocet pomoci funkce v knihovne DescTools
MeanCI(vyska, sd = sqrt(49))
  # se spolehlivosti 95% skutecna stredni hodnota vysky otcu lezi v intervalu od 177.9 do 180.6 cm

## A jaky je 99% interval spolehlivosti pro vysku matky? 
vyska <- Kojeni$vyskaM
MeanCI(vyska, conf.level = 0.99)
  # Na hladine vyznamnosti 1 % rozhodnete, zda muze byt stredni hodnota vysky matek 165 cm?
  # Plati toto rozhodnuti i na hladine vyznamnosti 5 %?
  MeanCI(vyska, conf.level = 0.99, method ="boot")
    # muzete pouzit i bootstrapovy interval spolehlivosti

## Na 5% hladine vyznamnosti rozhodnete, zda stredni hodnota porodni hmotnosti deti muze byt 3.5kg.
## V jakem rozmezi by se s 90% spolehlivosti mela nachazet stredni hodnota porodni delky deti?
porHmotnost <- Kojeni$porHmotnost
porDelka <- Kojeni$porDelka
MeanCI(porHmotnost, conf.level = 0.95) # 3381.572 až 3557.579 gramů - může být, protože horní hranice je větší nebo rovna 3.5kg
t.test(porHmotnost, mu = 3500) # jednovýběrový T test (3500 = 3.5 kg)
MeanCI(porDelka, conf.level = 0.90) # 50.33706 až 50.85486 cm

# Testovaná hypotéza
# H0: střední hodntota porodní hmotnosti = 3.5 kg
# H1: střední hodnota porodní hmotnosti != 3.5 kg

## Je 95%-ni interval spolehlivosti pro porodni hmotnost stejny u divek a u hochu?
pohlavi <- Kojeni$Hoch
porHmot <- Kojeni$porHmotnost
tapply(porHmot, pohlavi, MeanCI) # interval spolehlivosti zvlášť pro kluky a zvlášť pro holky

## A je mezi divkami a hochy vyznamny rozdil (na petiprocentni hladine vyznamnosti)?
MeanDiffCI(porHmot ~ pohlavi)
  # pokud interval neobsahuje nulu, je vyznamny rozdil ve strednich hodnotach

# pokud by nebyl významný rozdíl, tak by byl blízko k nule (resp. interval musí obsahovat nulu)
# neobsahuje, takže můžu tvrdit, že rozdíl je významný

# A co rozdil na jednoprocentni hladine vyznamnosti?
MeanDiffCI(porHmot ~ pohlavi, conf.level=0.99)

# významnost = 1 - spolehlivost
# např. spolehlivost = 0.95 (95 %), tak pak významnost = 1 - 0.95 = 0.05 = 5 %

##  Lisi se prumerna hmotnost pulrocnich deti, ktere byly jeste
#  jeste v pul roce kojeny a tech, co uz kojeny nebyly (promenna Koj24)?
hmotnost <- Kojeni$hmotnost
kojeni <- Kojeni$Koj24
MeanDiffCI(hmotnost ~ kojeni) # zde je důležité pořadí, nutné dát první číselnou proměnnou
# -601.3975 - 237.2395 (interval obsahuje nulu)
# => takže můžeme tvrdit, že se významně neliší
# může totiž nastat, že rozdíly mezi průměrnými hmotnostmi budou nula

###################################
### Interval spolehlivosti pro pravdepodobnost (podil)

## Spoctete a interpretujte 95% interval spolehlivosti pro 
#  podil otcu pritomnych u porodu

otec <- Kojeni$Otec
table(otec)
  # u porodu bylo pritomno 36 otcu
round(prop.table(table(otec)), 4) * 100
  # coz je 36.36%

# rucni vypocet
p <- prop.table(table(otec))[2]
n <- length(otec)
alpha <- 0.05
q.n <- qnorm(1-alpha/2)

# dolni mez
p - q.n*sqrt(p*(1-p)/n)
# horni mez
p + q.n*sqrt(p*(1-p)/n)
  # se spolehlivosti 95% skutecny podil otcu pritomnych u porodu se nachazi mezi 26.9% a 45.8%

BinomCI(table(otec)[2], sum(table(otec)), method = "wald")
  # 95%-ni interval spolehlivosti pro podil/pravdepodobnost

## Spoctete 90%-ni interval spolehlivosti pro podil deti, 
#  ktere byly jeste v pul roce kojeny (promenna Koj24)
kojeni <- Kojeni$Koj24
table(kojeni)
BinomCI(table(kojeni)[1], sum(table(kojeni)), method = "wald", conf.level = 0.90)
# se spolehlivosti 90 % skutecny podil deti, ktere byly jeste v pul roce kojeny, se nachazi mezi 64,3 % a 79.2 %

#################################
### Interval spolehlivosti pro rozdil podilu

## A je rozdil v podilu otcu pritomnych u porodu mezi Prahou a Kladnem?
mesto <- Kojeni$Porodnice
(tab <- table(otec, mesto))

tatinci_praha <- tab[2,1]
deti_praha <- tab[1,1] + tab[2,1]
tatinci_kladno <- tab[2,2]
deti_kladno <- tab[1,2] + tab[2,2]

# vypocet 
BinomDiffCI(x1 = tatinci_praha, n1 = deti_praha, x2 = tatinci_kladno, n2 = deti_kladno, method ="wald")
# Interval nulu neobsahuje

## Spoctete 99% interval spolehlivosti pro rozdil podilu v pul roce kojenych deti v Praze a v Kladne.
kojeni <- Kojeni$Koj24
mesto <- Kojeni$Porodnice
(tab <- table(kojeni, mesto))

kojeni_praha <- tab[1, 1]
deti_praha <- tab[1, 1] + tab[2, 1]
kojeni_kladno <- tab[1, 2]
deti_kladno <- tab[1, 2] + tab[2, 2]

BinomDiffCI(x1 = kojeni_praha, n1 = deti_praha, x2 = kojeni_kladno, n2 = deti_kladno, method ="wald", conf.level = 0.99)
# -0.3072159 až 0.1899745 = interval obsahuje nulu, tudíž rozdíl není významný

# procento v praze mínus procento v kladně

# H0: Rozdíl = 0 / Výběry jsou stejné
# H1: Rozdíl != 0 / Výběry se liší
prop.test(x = tab[1,], n = colSums(tab), conf.level = 0.99)
# p-value je větší než 5 %


################################
### Linearni regrese

## Zavisi porodni hmotnost na porodni delce deti?
zavisla <- Kojeni$porHmotnost
nezavisla <- Kojeni$porDelka

# nejprve graf
plot(zavisla ~ nezavisla, pch=19,main="Graf zavislosti dvou ciselnych promennych",
     xlab="Porodni delka",ylab="Porodni hmotnost")
# zavislost je zrejma

# korelacni koeficient
cor(zavisla, nezavisla)
  # silna kladna/rostouci/prima zavislost
  # umět určit směr a sílu

# Je tato zavislost statisticky vyznamna?
#   H0: promenne spolu nesouvisi vs. H1: promenne spolu souvisi
cor.test(zavisla, nezavisla)
  # p-hodnota < 2.2e-16 < alfa 0.05 => zamitam H0
  #   Zavislost mezi porodni hmotnosti a delkou je statisticky vyznamna.

# linearni regrese
abline(lm(zavisla ~ nezavisla),col=2,lwd=2)
  # grafem prolozim primku
(Model1 <- lm(zavisla ~ nezavisla))
  # odhad regresnich koeficientu - popis primky
  # porodni hmotnost = -7905.8 + 224.8*porodni delka
  #   je dulezite, ktera promenna je na x-ove a ktera na y-ove ose
  # s narustem porodni delky o 1cm naroste porodni hmotnost v promeru o 224.8 g
summary(Model1)
  # souhrn vystupu
  # v casti Coefficients najdeme odhady regresnich koeficientu (Estimate)
  #   a dale test o jejich nulovosti (kdyz je posledni hodnota v radku
  #   Pr(>|t|) mensi nez 0.05, pak se koeficient vyznamne lisi od nuly,
  #   a za posledni hodnotou se objevi alespon jedna hvezdicka)
  # v souhrnu Multiple R-squared je procento variability zavisle promenne 
  #   vysvetlene modelem: z variability porodni hmotnosti se vysvetlilo 62.5%
confint(Model1)
  # 95% intervaly spolehlivosti pro regresni koeficienty
  # ani jeden z nich neobsahuje nulu

## Jak zavisi hmotnost v pul roce na porodni hmotnosti?
zavisla <- Kojeni$hmotnost
nezavisla <- Kojeni$porHmotnost

(Model2 <- lm(zavisla ~ nezavisla))
# hmotnost = 4839.3 + 0.8215*porodni hmotnost
#   na jeden gram porodni hmotnosti pripada v prumeru 0.8215 gramu hmotnosti v pul roce
summary(Model2)
# modelem se vysvetlilo 18.4% variability hmotnosti v pul roce
confint(Model2)
# linerarni koeficient se vyznamne lisi od nuly

plot(zavisla ~ nezavisla, pch=19,main="Graf zavislosti dvou ciselnych promennych",
     xlab="Hmotnost",ylab="Porodni hmotnost")
abline(lm(zavisla ~ nezavisla),col=2,lwd=2)
# roustoucí slabší závislost
# z 18 % závisí hmotnost na porodní hmotnosti 



## A co kdyz do modelu pridame jeste delku?
#  Zavisi hmotnost deti v pul roce na jejich delce a na porodni hmotnosti?
nezavisla2 <- Kojeni$delka

(Model3 <- lm(zavisla ~ nezavisla + nezavisla2))
  # hmotnost = -413 + 0.5837*porodni hmotnost + 88.66*delka
  #   na jeden gram porodni hmotnosti pripada v prumeru 0.5837 gramu hmotnosti v pul roce
  #      pri stejne delce v pul roce
  #   na jeden centimetr delky v pul roce pripada v prumeru 88.66 gramu hmotnosti
  #      pri stejne porodni hmotnosti
summary(Model3)
  # modelem se vysvetlilo 28.7% variability hmotnosti v pul roce
  # pridani dalsi promenne vyrazne pomohlo
confint(Model3)
  # zadny z intervalu spolehlivosti pro linearni cleny neobsahuje nulu
  #   obe promenne jsou v modelu vyznamne

## A kdyz pridame do modelu jeste porodni delku?
nezavisla3 <- Kojeni$porDelka

(Model4 <- lm(zavisla ~ nezavisla + nezavisla2 + nezavisla3))
summary(Model4)
confint(Model4)
  # koeficienty se po pridani kazde dalsi promenne meni
  # pridanim porodni delky do modelu jsme si uskodili
  #  a vysvetlili jsme jen 29.3% variability hmotnosti

## Zavisi BMI pulrocnich deti na jejich porodni hmotnosti, delce v pul roce a veku matky?

# Testy predpokladu
oldpar <- par(mfrow = c(2,2))
plot(Model3) 
par(oldpar)
  # testuje se 
  # linearni vztah: na prvnim grafu nema byt videt trend 
  # normalita residui: na druhem grafu maji body lezet na primce 
  # stabilita rozptylu: krivka na tretim grafu nema mit trend
  # vlivna pozorovani: na ctvrtem grafu nemaji body lezet vne mezi 

library(car)
vif(Model3) 
  # testuje se multikolinearita - nemelo by byt vetsi nez 5 
avPlots(Model3) 
  # testuje se efekt pridani dalsi promenne