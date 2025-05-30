##########################
#### Logisticka regrese
library(datarium)
library(car)
library(MASS)
library(foreign)
library(fmsb)
library(AER)
library(lme4)

# v knihovne datarium je vhodna databaze z Titaniku
smpl <- sample(1:2201, 150)
titanic <- titanic.raw[smpl, ]
  # vyber 150 hodnot, abychom mohli pracovat i s p-hodnotama
titanic$dependent <- (titanic$Survived == "Yes")
  # zavisle promenna

table(titanic$Survived, titanic$Class)
table(titanic$Survived, titanic$Age)
table(titanic$Survived, titanic$Sex)
  # kontrola, jaci pasazeri prezili

mod1 <- glm(dependent ~ Class + Sex + Age, family = "binomial", data = titanic)
  # model logisticke regrese
summary(mod1)
  # odhady koefificnetu a jejich vyznamnost

NagelkerkeR2(mod1)
  # neco jako koeficient determinace (pocitany z deviance)

Anova(mod1, type = "II")
  # vyznamnost promennych

# interpretace regresnich koeficientu (dulezite k ustni zkousce!!)
(b <- coef(mod1))
  # ulozeni koeficientu do promenne
1/exp(b[3])
  # kolikrat se zvysuji sance na preziti u cestujicich v prvni tride oproti cestujicim ve treti tride
1/exp(b[4])
  # kolikrat se zvysuji sance na preziti u cestujicich v prvni tride oproti posadce
exp(b[5])
  # kolikrat se zvysuji sance na preziti u zen oproti muzum
  # sance, ze zeny preziji oproti muzum je 7krat vetsi (sance neni totez co pravdepodobnost)
  # sance = pocet tech co prezili ku pocet tech co neprezili
  # v logisticke regresy se pracuje se sancemi 

# Jake sance na preziti ma dospely muz cestujici druhou tridou?
(odd <- exp(b[1] + b[2] + b[6]))
# A jakou ma pravdepodobnost, ze prezije
(prob <- odd/(1 + odd))

########################
### Samostatne
mydata <- read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")
  # GRE - Graduate Record Exam scores 
  # GPA - grade point average 
  # rank - prestiz stredni skoly, 
  # admit - byl student prijat ke studiu na VS?

# Na cem zavisi, zda byl student prijat na VS?

##################
### Poradova (ordinalni) regrese

dat <- read.dta("https://stats.idre.ucla.edu/stat/data/ologit.dta")
# nacteni dat
# data: apply - zajem studenta o studium na VS
#       pared - maji rodice vysokoskolske studium
#       public - typ stredni skoly: statni(1)  nebo soukroma (0)
#       GPA - vysledek testu na SS
ftable(xtabs(~ public + apply + pared, data = dat))
  # contingencni tabulka kategorickych promennych

# 3 kategorie, takže 2 logistické regrese
# Na cem zavisi, zda student chce nastoupit na VS?
m <- polr(apply ~ pared + public + gpa, data = dat, Hess=TRUE)
summary(m)
  # odhady regresnich koeficientu
ctable <- coef(summary(m))
pval <- pt(abs(ctable[, "t value"]), df=length(dat$apply)-1, lower.tail = FALSE) * 2
(ctable <- cbind(ctable, "p value" = pval))
  # stejna tabulka doplnena o p-hodnoty
  # typ stredni skoly nema vyznamny vliv
  # ostatni promenne vyznamny vliv maji

## pomer sanci (OR) a intervalz spolehlivsoti
(CI <- confint(m))
  # intervaly spolehlivosti pro regresni koeficienty
exp(cbind(OR = coef(m), CI))
  # interpretace regresnich koeficientu pres pomer sanci + intervaly spolehlivosti
  #   sance na vyssi ochotu studovat na VS je 2.85 krat vetsi pro studenty 
  #     s vysokoskolsky vzdelanymi rodici nez u ostatnich, pri stejnem typu SS a stejnym vysledkem GPA 
  #   kdyz vyroste hodnoceni GPA o 1, prumerna sance na vyssi ochotu studovat na VS vzroste 1.85 krat
  #     u studentu ze stejneho typu SS se stejne vzdelanymi rodici

# test predpokladu: "parallel lines"
#   H0: zavislost je ve vsech skupinach zavisle promenne stejna
#   H1: zavislost se v jednotlivych kategoriich lisi
poTest(m)
  # p-hodnoty u vsech koeficientu jsou vetsi nez 0.05 -> nezamitam H0
  # zavislost je ve vsech skupinach stejna

####################
## Samostatne

# Na cem zavisi, zda zena pracovala
data("Womenlf")
  # data o zamestnanosti zen v roce 1977 v Kanade
  # partic - zamestnanost zeny (3 kategorie - parttime, fulltime, not.work)
  # hincome - prijem manzela v tisicich dolarech
  # children - zda zena ma ci nema deti
  # region - Kanadska provincie

# priprava dat
women.work <- Womenlf
women.work$partic <- factor(women.work$partic, levels=c("not.work", "parttime", "fulltime"))
  # vytvoreni usporadane kategoricke promenne

m <- polr(partic ~ hincome + children + region, data = women.work, Hess=TRUE)
summary(m)
(ctable <- coef(summary(m)))
pval <- pt(abs(ctable[, "t value"]), df=length(women.work$partic)-1, lower.tail = FALSE) * 2
(ctable <- cbind(ctable, "p value" = pval))

# Value Std. Error    t value      p value
# hincome           -0.05691142 0.02017086 -2.8214672 5.146524e-03
# childrenpresent   -2.00988839 0.29430907 -6.8291758 5.937411e-11
# regionBC           0.15299289 0.56437987  0.2710814 7.865419e-01
# regionOntario      0.26866587 0.46220183  0.5812739 5.615556e-01
# regionPrairie      0.47966358 0.54127130  0.8861796 3.763334e-01
# regionQuebec      -0.07108525 0.49376999 -0.1439643 8.856393e-01
# not.work|parttime -1.74922840 0.54363177 -3.2176714 1.454976e-03
# parttime|fulltime -0.83153049 0.53245224 -1.5616997 1.195658e-01

# To, zda žena pracovala, zavisí na příjmu manžela (hincome) a přítomnosti dětí (childrenpresent)
# Na regionu to nezávisí
# Ženy s dětmi a ženy s bohatými manžely mají menší šanci pracovat. Provincie nehraje roli.
# children má extrémně silný efekt – p ~ 0.000000000059
# Koeficient pro hincome je malý, ale statisticky významný.

Anova(m)
poTest(m)

# Jaká je šance, že ženy budou pracovat, když nebudou mít děti
(b <- coef(m))
1 / exp(b[2])

# Otázka - logistická regrese - kde se dále využívá a jak (ordinální proměnné?)

########################
### Poissonova regrese - log-linear model
# zavisle promennou tvori pocty

# Na cem zavisi pocty oceneni
p <- read.csv("https://stats.idre.ucla.edu/stat/data/poisson_sim.csv")
p <- within(p, {
  prog <- factor(prog, levels=1:3, labels=c("General", "Academic", 
                                            "Vocational"))
  id <- factor(id)
})
  # pocty oceneni ziskane studenty v ruznych studijnich programech
  #   pridana je zavislost na vysledcich testu z matematiky
(tab <- table(p$prog, p$num_awards))
barplot(tab, beside = T, col = 2:4,
        main = "Numbers of awards for different study programs", legend = T)
  # graficke znazorneni

# Poissonova regrese (zobecněná lineární regrese)
(mod.p1 <- glm(num_awards ~ prog + math, family = "poisson", data = p))
summary(mod.p1)
Anova(mod.p1)
  # obe nezavisle promenne maji vyznamny vliv
  #   "General" a "Vocational" program se od sebe vyznamne nelisi

confint(mod.p1)
  # intervaly spolehlivosti pro regresni koeficienty
NagelkerkeR2(mod.p1)
  # neco jako koeficient determinace

# Graficky vystup
# I když jsou křivky překřížené, nejedná se o interakci
pred <- predict(mod.p1, type = "response")
vyst <- data.frame(p$math, p$prog, pred)
vyst <- vyst[order(vyst[,1]),]
plot(num_awards ~ math, col = prog, pch = 19, data = p,
     main = "Zavislost poctu oceneni na testu z matematiky")
lines(vyst[vyst[,2] == "General", 1], vyst[vyst[,2] == "General",3], col = 1)
lines(vyst[vyst[,2] == "Academic", 1], vyst[vyst[,2] == "Academic",3], col = 2)
lines(vyst[vyst[,2] == "Vocational", 1], vyst[vyst[,2] == "Vocational",3], col = 3)
legend(35, 5.5, levels(p$prog), lty = 1, col = 1:3)

# kontrola variability
# v Poissonove regresi ocekavame, ze rozptyl zavisle promenne be mel byt stejny 
#   jako jeji stredni hodnota
mean(p$num_awards)
var(p$num_awards)
  # rozdil neni az tak velky, ale uplne stejne tyto hodnoty take nejsou

# Zkusime do modelu pridat koeficient pro upravu rozptylu
#   tzv. "dispersion parameter"
(mod.p2 <- glm(num_awards ~ prog + math, family = "quasipoisson", data = p))
summary(mod.p2)
  # v nasem pripade je dispersion parameter = 1.08
  # tedy rozptyl nasi promenne je temer shodny jako jeji stredni hodnota
  # vyuziti klasicke poissonovy regrese je v eporadku
Anova(mod.p2)
  # vysledky se prakticky nelisi

# test (z knihovny AER)
#   H0: dispersion parameter = 1 vs H1: dispersion parameter > 1
dispersiontest(mod.p1)
  # p-hodnota 0.2973 > 0.05 -> nezamitame H0, predpoklad poissonovy regrese je splnen

## kontrola residui
qqnorm(residuals(mod.p1)); qqline(residuals(mod.p1), col = 2)

# V pripade, ze nejsou splneny podminky poissonovy regrese, je mozne zkusit i 
#   regresi s negativnim binomickym rozdelenim
mod.nb <- glm.nb(num_awards ~ prog + math, data=p)
summary(mod.nb)
qqnorm(residuals(mod.nb)); qqline(residuals(mod.nb), col = 2)

##################
## Samostatne
 
# Na cem zavisi pocet skvrn na hlave mladete tetrivka
data("grouseticks")
  # index - ID ptacete
  # ticks - pocet skvrn
  # brood - cislo vrhu, ze ktereho mlade pochazi
  # height - nadmorska vyska
  # year - rok
  # location - misto

## pocitejte zavislost na nadmorske vysce a roku

# kdybychom nevěděli typ rozdělení, tak cullen and frey graph
library(fitdistrplus)
descdist(grouseticks$TICKS, boot = 1000)

View(grouseticks)
(m <- glm(TICKS ~ HEIGHT + YEAR, family = "poisson", data = grouseticks))
summary(m)
Anova(m)

NagelkerkeR2(m)
dispersiontest(m)
qqnorm(residuals(m), pch=19)

# Data nesplňují předpoklady poissonova rozdělení
mean(grouseticks$TICKS) # 6.369727
var(grouseticks$TICKS) # 172.6615

(m <- glm(TICKS ~ HEIGHT + YEAR, family = "quasipoisson", data = grouseticks))
summary(m)
Anova(m)
NagelkerkeR2(m)
qqnorm(residuals(m), pch=19)

(m <- glm(TICKS ~ HEIGHT + YEAR, data = grouseticks))
summary(m)
