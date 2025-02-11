# aktivace knihovny s popisnymi statistikami
library(DescTools)

# Nacteni vestavene databaze Boston
library(MASS)
data(Boston)
  # faktory ovlivnujici cenu nemovitosti na predmesti Bostonu
?Boston
  # co popisuji jednotlive promenne

# kategoricke promenne databaze Boston
tax.k <- Boston$tax %/% 100
land.z <- Boston$zn %/% 10
Boston.kat <- data.frame(cbind("chas"=Boston$chas, "rad" = Boston$rad, tax.k, land.z))
  # databaze kategorickych promennych

##########################
### robustni popisne statistiky ciselne promenne

# pracujte s promennou dis (vzdalenost k pracovnim centrum)
dis <- Boston$dis
hist(dis,col="skyblue",border="darkblue",freq=F,main="Histogram",xlab="Vzdalenost v km",ylab="Hustota")
  # nesymetricke rozdeleni s kandidaty na odlehle hodnoty

# Jak toto ovlivni charakteristiky polohy
mean(dis)
median(dis)
mean(dis,trim=0.1)
  # useknuty prumer, z kazde strany usekne 10% hodnot
library(asbio)
huber.mu(dis)
  # Huberuv M-estimator (maximalne verohodny odhad stredni hodnoty)

# Variabilita
sd(dis)
IQR(dis)
MAD(dis)

# kvartilovy koeficient sikmosti (Bowley)
Q1<-quantile(dis,0.25)
Q3<-quantile(dis,0.75)
(Q3+Q1-2*median(dis))/(Q3-Q1)
# porovnejte s klasickou sikmosti
Skew(dis)

# oktilovy koeficient spicatosti (Moorse)
Q18<-quantile(dis,1/8)
Q28<-quantile(dis,2/8)
Q38<-quantile(dis,3/8)
Q48<-quantile(dis,4/8)
Q58<-quantile(dis,5/8)
Q68<-quantile(dis,6/8)
Q78<-quantile(dis,7/8)
((Q78-Q58)+(Q38-Q18))/(Q68-Q28)
# porovnejte s klasickou spicatosti
Kurt(dis)

# Vyzkousejte pro promennou rm a nox
# - klasické a robustní charakteristiky polohy a variability

# Symetrické rozdělení
# Jednovrcholové (Unimodální)
# Špičatější než normální rozdělení (a proto bychom čekali odlehlé hodnoty na obou stranách)
# Čekali bychom nějaký větší rozdíl mezi průměrem a mediánem? Ne, je to symetrické
# Má smysl uvažovat useknutý průměr? Ano, vyplatí se, protože tam jsou oddlehlé hodnoty
# - menší než 4 a větší než 8.5
# - podívat se kolik je hodnot: sum(rm<4) / length(rm) a sum(rm>8.5) / length(rm)
# Krabicový graf určuje odlehlé hodnoty na základě normálního rozdělení
# - jsou tam tzv. těžší chvosty
# - Mezikvartalové rozpětí je zde vhodný ukazatel charakteristiky variability (směrodatná odchylka je zde ovlivněna odlehlými hodnotami)
rm <- Boston$rm
hist(rm, main="Histogram", xlab="Pocet mistnosti", col="lightblue")
boxplot(rm, main="Krabicovy graf", col="lightgreen")
boxplot(rm, main="Krabicovy graf", col="lightgreen", range=3)
mean(rm)
median(rm)
mean(rm, trim=0.05)
mean(rm, trim=0.1)
mean(rm, trim=0.15)
HuberM(rm)
sd(rm)
IQR(rm)
MAD(rm)
sum(rm<4) / length(rm) # necelé 4 promile (0.0039) jsou menší než 4
sum(rm>8.5) / length(rm) # necelých 6 promile (0.0059) jsou větší než 8.5

# Asymetrické
# Šikmost bude kladná
# Pravostranné zešikmení
# Vícevrcholové rozdělení
# Špičatost - předpokládáme, že máme více vrcholů, takže o špičatosti nemůžeme hovořit
# Průměr bude ovlivněn pravým chvostem
# Průměr je o něco vyšší než medián
# Ideální by byl useknutý průměr (5 %)
# IQR nebo MAD (tedy robustní charakteristika) bude vhodnější než směrodatná odchylka
# Robustní = vhodné, kdy existují kandidáti na odlehlé hodnoty (nebo že je hodně hodnot na jednu stranu) - např. i když je krabicový graf daleko od MAX nebo MIN
nox <- Boston$nox
hist(nox, main="Histogram", xlab="Oxidy dusiku", col="lightblue")
boxplot(nox, main="Krabicovy graf", col="lightgreen")
mean(nox)
median(nox)
mean(nox, trim=0.05)
HuberM(nox)
sd(nox)
IQR(nox)
MAD(nox)
sum(nox>=0.75) / length(nox) # cca 0.05 (5 %) - tedy cca 5% useknutý průměr

##########################
### Vztah dvou promennych
# - dvou kategorických
# - dvou číselných

## Pro popsani vztahu dvou kategorickych promennych se pouziva kontingencni tabulka
# Souvisi spolu dane a pristupnost k dalnicim? (promenne tax.k a rad)

# Číselnou proměnnou charakterizovat pro všechny katagorie

# Když jsem v dálničním indexu 24, automaticky vím, že patřím do 6. daňové kategorie
dalnicni_index<-Boston.kat$rad # index, jestli máme dobrý přístup na dálnice
danova_kategorie<-Boston.kat$tax.k # do jaké patříme daňové kategorie
(tab<-table(dalnicni_index,danova_kategorie)) # kontingenční tabulka (počty v různých kombinacích)

# Kontingenční tabulka s relativními četnostmi
round(addmargins(prop.table(tab)), 3) # tabulková procenta (všechny hodnoty vydělím celým počtem pozorováním)
round(addmargins(prop.table(tab,1)), 3) # řádková procenta (vezmu každý index přístupu k dálnici, tak se podívám, kolik tam je procent daňových kategorií - resp. jaká daňová kategorie je pro daný index nejzastoupenější)
round(addmargins(prop.table(tab,2)), 3) # sloupcová procenta (každá daňová kategorie zvlášť a u té se koukám na dálniční indexy)
  # ktery typ relativnich cetnosti se pro popis zavislosti hodi nejvic?
  # Jak byste vztah popsali?

# Souvisi spolu dane a pozice u reky? (tax.k, chas) # daně a blízkost k řece (0 bez přístupu k řece, 1 s přístupem k řece)
# Řádková procenta jsou zde nejlepším ukazatelem 
danova_kategorie<-Boston.kat$tax.k
blizkost_k_rece<-Boston.kat$chas
(tab<-table(blizkost_k_rece, danova_kategorie))
round(addmargins(prop.table(tab)), 3)
round(addmargins(prop.table(tab,1)), 3)
round(addmargins(prop.table(tab,2)), 3)
plot(as.factor(danova_kategorie) ~ as.factor(blizkost_k_rece), col=2:7) # sloupcový
plot(as.factor(blizkost_k_rece) ~ as.factor(danova_kategorie)) # řádkový 

# Závisí výskyt bakterie na používaném léku? (mám méně bakterie u lečených/nelečených?)
data("bacteria")
bac <- bacteria$y
trt <- bacteria$trt
plot(bac ~ trt, col=2:3) # sloupcový (procento těch, kterých bakterii je nejmenší je u placebo - n)
tab <- table(bac, trt)
addmargins(prop.table(tab, 1))

#############################
## Vztah dvou ciselnych promennych popisujeme pomoci
#   bodoveho (rozptyloveho) grafu, korelacniho koeficientu, korelacni tabulky

# Jaky je vztah mezi promennymi rm a age?
prom1 <- Boston$age # jak dlouho bydlejí v nemovitosti
prom2 <- Boston$rm # počet místností
plot(prom1 ~ prom2,pch=19,main="Rozptylovy graf",xlab="Rm",ylab="Age")
  # Co z grafu vidite?
  # - nevidíme žádný trend, žádný tvar

# Absolutní hodnota kovariance
cov(prom1,prom2,use="complete.obs")

# Korelační koeficient
cor(prom1,prom2,use="complete.obs")

# A co je korelacni tabulka?
# - něco jiného než korelační matice (to je matice korelačních koeficientů)
prom1.c <- factor(ifelse(prom1<=20, '<20', ifelse(prom1<=40, '20-40', 
                                                  ifelse(prom1<=60, '40-60', ifelse(prom1<=80, '60-80', '>80')))),
                  levels=c("<20","20-40","40-60","60-80",">80")) 
prom2.c <- factor(ifelse(prom2<=5, '<5', ifelse(prom2<=6, '5-6', 
                                                  ifelse(prom2<=7, '6-7', ifelse(prom2<=80, '7-8', '>8')))),
                  levels=c("<5","5-6","6-7","7-8",">8"))
table(prom1.c,prom2.c)

# Popiste souvislost rm a medv (bez korelacni tabulky)
# - rozptylová graf připomíná rostoucí přímku
# - roustoucí (kladná/pozitivní), přímá
# - cor - na pomezí střední a silné souvislosti
rm <- Boston$rm
medv <- Boston$medv
plot(rm ~ medv,pch=19,main="Rozptylovy graf")
cor(rm,medv,use="complete.obs")

# Najdete promenne s nejsilnejsim vztahem
# pouzijte pouze ciselne promenne a ykuste na ne pouzit prikazy pairs a cor na vsechny dohromady
# Korelační matice

ciselne <- data.frame(Boston$crim, Boston$indus, Boston$nox, Boston$rm, Boston$dis, Boston$medv)
round(cor(ciselne), 3) # korelační matice (na diagonále má jedničky, matice je symetrická)
pairs(ciselne) # udělá bodové grafy

# dis a nox (-0.769) - čím blíž jsem k zaměstnaneckým center, tím horším mám ovzduší

#############################
## Normalita dat - QQ plot

# Ohodnotte normalitu promenne rm
# vyska
rm <- Stulong$rm

# histogram - hodi se ho kreslit v "hustote"
hist(rm,col="skyblue",border="darkblue",main="Histogram",ylab="Hustota",
     xlab="rm", freq=F)
# Ma tvar Gaussovy krivky?
curve(dnorm(x,mean(rm),sd(rm)),from=min(rm),to=max(rm), add=T,col=2)
# prikresleni hustoty odpovidajiciho normalniho rozdeleni 

# Sikmost, spicatost
Skew(rm)
Kurt(rm)
# jsou nulove?

# Pravdepodobnostni graf
PlotQQ(rm,pch=19,cex=0.5)
qqnorm(rm,pch=19, cex=0.5);qqline(rm,distribution=qnorm,col=2,lwd=2)
# graf bez pouziti knihovny DescTools
# jak cist pravdepodobnostni graf
# vyska ma priblizne normalni rozdeleni

# Maji promenne nox a medv normalni rozdeleni?

################################
### Testovani hypotez
# Test normality
# napr. Shapiro-Wilkuv test

## Ma rm normalni rozdeleni?
# Testovane hypotezy
# nulova hypoteza H0: data maji normalni rozdeleni
# jen jedna moznost
# alternativni hypoteza H1: data nemaji normalni rozdeleni
# vice moznosti (vsechna ostatni rozdeleni)

# test
shapiro.test(rm)
shapiro.test(nox)
# statisticke testy obecne nefunguji pri velkem poctu pozorovani
# nejlepe funguji na vzorku cca 100 hodnot

# vyhodnoceni testu
# p-value <= alpha (= 0.05) -> zamitam H0, plati H1
# p-value > alpha (= 0.05) -> nezamitam H0 

# Interpretace testu
# kdyz nezamitam H0 -> data maji priblizne normalni rozdeleni
# kdyz zamitam H0 -> data nemaji normalni rozdeleni

## Ma normalni rozdeleni nox, medv?
## A co vyber z normalniho rozdeleni
vyb <- rnorm(200)


