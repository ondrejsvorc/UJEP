#######################################
#### Mnohorozmerna statistika

library(DescTools)
library(MASS)
library(RcmdrMisc)
# nacteni knihoven

#######################################
### Zobecneni jednorozmernych metod

## Mnohorozmerny dvouvyberovy T-test (Hotellingovo T2)
# Porovnavame 2 vyucujici na zaklade hodnoceni jejich studentu. 
#   Je mezi vyucujicimi vyznamny rozdil?
matematici <- data.frame(ucitel = factor(rep(1:2, c(5, 7))), 
                         spokojenost = c(1, 3, 2, 4, 3, 2, 6, 4, 5, 5, 3, 4), 
                         znalost = c(4, 7, 2, 6, 3, 6, 6, 8, 7, 10, 9, 6))
  # vytvoreni dat
matematici
  # ukazka dat
tapply(matematici$spokojenost, matematici$ucitel, mean)
tapply(matematici$znalost, matematici$ucitel, mean)
  # prumerna spokojenost a znalost u jednotlivych ucitelu

# jednorozmerne porovnani
boxplot(matematici$spokojenost ~ matematici$ucitel)
boxplot(matematici$znalost ~ matematici$ucitel)
t.test(matematici$spokojenost ~ matematici$ucitel)
t.test(matematici$znalost ~ matematici$ucitel)
  # u znalosti vychazi vyznamny rozdil, u spokojenosti ne
(m1 <- HotellingsT2Test(cbind(matematici$spokojenost, matematici$znalost) ~ matematici$ucitel))
  # porovnani obou hodnoceni u ucitelu

## MANOVA - jak se vytvari plasticky film
# vytvoreni dat
trhliny <- c(6.5, 6.2, 5.8, 6.5, 6.5, 6.9, 7.2, 6.9, 6.1, 6.3, 6.7, 6.6, 7.2, 7.1, 6.8, 7.1, 7.0, 7.2, 7.5, 7.6)
lesk <- c(9.5, 9.9, 9.6, 9.6, 9.2, 9.1, 10.0, 9.9, 9.5, 9.4, 9.1, 9.3, 8.3, 8.4, 8.5, 9.2, 8.8, 9.7, 10.1, 9.2)
sytost <- c(4.4, 6.4, 3.0, 4.1, 0.8, 5.7, 2.0, 3.9, 1.9, 5.7, 2.8, 4.1, 3.8, 1.6, 3.4, 8.4, 5.2, 6.9, 2.7, 1.9)
Y <- cbind(trhliny, lesk, sytost)
  # zavisle promenna se sklada ze tri dilcich promennych
pomer <- factor(gl(2,10), labels = c("Nizky", "Vysoky"))
prisady <- factor(gl(2, 5, length = 20), labels = c("Nizky", "Vysoky"))
  # dva nezavisle faktory ... tri zavisle promenne se budou porovnavat v techto skupinach

(fit <- manova(Y ~ pomer * prisady))
  # vlastni model - na vystupu jsou soucty ctvercu pro kazdou promennou
summary.aov(fit)

  # H0: Vliv interakcí nevýznamný
  # H1: vliv interakcí významný
  # p > 0.05 = nezámítám H0

  # tabulky jednorozmernych analyz rozptylu pro kazdou promennou zvlast
  # na nezavisle promennych zavisi jen trhliny a lesk
summary(fit, test="Wilks")
  # existuje nekolik testovych statistik na nichz je zalozena mnohorozmerna analyza rozptylu
  # R-ko nabizi statistiky: "Pillai", "Wilks", "Hotelling-Lawley", "Roy"
  # Wilkovo lambda je zobecnenim klasicke F-statistiky z jednorozmerne ANOVy
summary(fit)
  summary(fit, test="Hotelling-Lawley")
  # pouziti jine testove statistiky
  # interakce nejsou vyznamne
  
(fit2 <- manova(Y ~ pomer + prisady))
summary(fit2)
  # mira vlivu samostatnych promennych

plotMeans(Y[, 1], pomer, prisady)
plotMeans(Y[, 2], pomer, prisady)
plotMeans(Y[, 3], pomer, prisady)
  # grafy prumeru pro jednotlive faktory
  # na zavislosti mezi faktory a zavislymi promennymi

#################################
### Samostatne
data(mtcars)

## Lisi se ciselne charakteristiky podle poctu valcu?
Y <- mtcars[, c("mpg", "disp", "hp", "drat", "wt", "qsec", "gear", "carb")]
fit <- manova(as.matrix(Y) ~ mtcars$cyl)
summary(fit, test="Wilks")
summary.aov(fit)
    # Všechny proměnné (mpg, disp, hp, drat, wt, qsec, gear, carb) jsou významně odlišné podle počtu válců (všechny p < 0.005).

## Lisi se ciselne charakteristiky podle typu motoru?
Y <- mtcars[, c("mpg", "disp", "hp", "drat", "wt", "qsec", "gear", "carb")]
fit <- manova(as.matrix(Y) ~ mtcars$vs)
summary(fit, test="Wilks")
summary.aov(fit)
    # Významně se liší: mpg, disp, hp, drat, wt, qsec, carb (p < 0.05).
    # Nevýznamný rozdíl: gear (p = 0.2579).

## „Liší se číselné charakteristiky“ znamená, že auta s různým počtem válců nebo typem motoru mají v průměru jiné hodnoty (spotřeby, výkonu, váhy, atd.) — a tento rozdíl není náhodný, ale statisticky významný.

#################################
# Metoda hlavnich komponent

# Vytváří nové, nezávislé proměnné (hlavní komponenty), které zachycují co nejvíc původní variability dat
# v co nejmenším počtu dimenzí.

v1 <- c(1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,4,5,6)
v2 <- c(1,2,1,1,1,1,2,1,2,1,3,4,3,3,3,4,6,5)
v3 <- c(3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,5,4,6)
v4 <- c(3,3,4,3,3,1,1,2,1,1,1,1,2,1,1,5,6,4)
v5 <- c(1,1,1,1,1,3,3,3,3,3,1,1,1,1,1,6,4,5)
v6 <- c(1,1,1,2,1,3,3,3,4,3,1,1,1,2,1,6,5,4)
vmat <- data.frame(v1,v2,v3,v4,v5,v6)
m1 <- cbind(v1,v2,v3,v4,v5,v6)
  # vytvoreni dat

# Zakladem analyzy hlavnich komponent je korelacni matice
cor(m1)
  # korelacni matice
eigen(cor(m1))
  # vlastni cisla a vlastni vektory korelacni matice

# Pocet potrebnych hlavnich komponent ma byt pocet vlastnich cisel vetsich nez 1
screeplot(princomp(m1, cor = T), type="l")
abline(h=1, col="green")
  # dostatecne velke procento vyuzite variability (80%)
  cumsum(eigen(cor(m1))$values / sum(eigen(cor(m1))$values))
    # prvni 3 komponenty vysvetli pres 90% variability

# Vytvoreni hlavnich komponent  
prcomp(m1)
(PC <- prcomp(vmat, scale = T))
  # hlavni komponenty
  # vrati variabilitu hlavnich komponent spolu s koeficienty jednotlivych komponent
plot(PC$x[,1], PC$x[,2], pch = 19, main = "Prvni 2 hlavni komponenty")
  # vykresleni prvnich dvou hlavnich komponent, ukazuji v datech skupiny
# maji hlavni komponenty prirozenou interpretaci?
#   mnohdy ne, pak je potreba pouzit faktorovou analyzu

## Faktorova analyza
factanal(m1, factors = 3)
  # faktorova analyza jen prerotuje hlavni komponenty
  #	metoda rotace 'varimax' je brana jako zakladni (defaultni) 
  # vypis loadingu a procent vysvetlene variability
(sc <- factanal(~v1+v2+v3+v4+v5+v6, factors = 3, scores = "Bartlett")$scores)
  # faktorove skory pro jednotliva pozorovani
plot(sc[,1], sc[,2], pch = 19, main = "Prvni 2 faktory")
  # vykresleni prvnich dvou faktoru

################################
### Samostatne

## Kolik hlavnich komponent/ faktoru je potreba pro reprezentaci ciselnych promennych?
#   Jak byste pojmenovali faktory? Nakreslete vhodny graf/ grafy.
data("mtcars")
m1 <- as.matrix(mtcars[, c("mpg", "disp", "hp", "drat", "wt", "qsec", "gear", "carb")])
cor(m1)
eigen(cor(m1))
screeplot(princomp(m1, cor = TRUE), type = "lines", main = "Screeplot - mtcars")
abline(h = 1, col = "green")
cumsum(eigen(cor(m1))$values / sum(eigen(cor(m1))$values))
pc <- prcomp(m1, scale = TRUE)
summary(pc)
print(pc)
(sc <- factanal(m1, factors = 3, scores = "Bartlett")$scores)
plot(sc[,1], sc[,2], pch = 19, main = "První 2 faktory - mtcars", xlab = "Faktor 1", ylab = "Faktor 2")
plot(sc[,1], sc[,2], pch = 19, col = "blue", xlab = "Faktor 1 (Velikost)", ylab = "Faktor 2 (Výkon)", main = "Faktorová analýza - mtcars")
text(sc[,1], sc[,2], labels = rownames(sc), pos = 4, cex = 0.7)

## Hledejte hlavni komponenty / faktory pro soubor UScrime.
## (prý ale vyšlo 5 faktorů, ne 2)
data("UScrime")
m1 <- as.matrix(UScrime[, c("M", "Ed", "Po1", "LF", "Pop", "GDP", "Ineq")])
cor(m1)
eigen(cor(m1))
screeplot(princomp(m1, cor = TRUE), type = "lines", main = "Screeplot - mtcars")
abline(h = 1, col = "green")
cumsum(eigen(cor(m1))$values / sum(eigen(cor(m1))$values))
pc <- prcomp(m1, scale = TRUE)
summary(pc)
print(pc)
(sc <- factanal(m1, factors = 2, scores = "Bartlett")$scores)
plot(sc[,1], sc[,2], pch = 19, main = "První 2 faktory - UScrime", xlab = "Faktor 1", ylab = "Faktor 2")