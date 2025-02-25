# https://cran.r-project.org/web/packages/pwr/pwr.pdf

###################
### Odhad poctu pozorovani
# install.packages("pwr")
library(pwr)
## Kolik pozorovani potrebuji k tomu, abych odhalila rozdil oproti nulove hypoteze
#   o velikosti 3, pri smerodatne odchylce 5, se silou testu 0.95, na hladine vyznamnosti 0.05.
#   Vyhodnoceni budu delat pomoci jednovyberoveho t-testu
pwr.t.test(d=3/5, sig.level=0.05, power=0.95, type="one.sample")
# Potrebuji 38 pozorovani (n)
# d = rozdíl dělený směrodatnou odchylkou

# u Wilcoxonova testu potrebuji cca o 15% navic
(n <- pwr.t.test(d=3/5, sig.level=0.05, power=0.95,type="one.sample")$n)
n*1.15
# Wilcoxonuv test by potreboval 44 pozorovani

## A kolik potrebuji pozorovani, kdyz chci odhalit rozdil ve dvou skupinach o velikosti 8,
#   pri ocekavane sdruzene smerodatne odchylce 20, se silou testu 0.95, na hladine vyznamnosti 0.05.
pwr.t.test(d=8/20, sig.level=0.05, power=0.95, type="two.sample")
# počet pozorování v každé skupině by měl být cca 163

## Chceme-li otestovat pravdepodobnostni rozdeleni kategoricke promenne se ctyrmi kategoriemi,
#   pouzijeme chi-kvadrat test dobre shody. "Effect size" je soucet (pi - p0i)^2/p0i pres vsechny 
#   kategorie a odpovida Cramerovu phi. Kolik potrebujeme pozorovani, kdyz chceme tento
#   effekt o velikosti 0.3, silu testu 0.8 a hlaadinu vyznamnosti 0.05?
pwr.chisq.test(w=0.3, df=(4-1), power=0.80, sig.level=0.05)
# pravděpodobnost, která ve skutečnosti platí, mínus nulová hypotéza = Effect size

## kolik budeme potrebovat pozorovani, kdyz budeme testovat nezavislost dvou kategorickych
#   promennych se tremi a ctyrmi kategoriemi. Zajima nas "effect size" o velikosti 0.2, 
#   sila testu 0.8 a hladina vyznamnosti 0.05.
pwr.chisq.test(w=0.2, df=(3-1)*(4-1), power=0.80, sig.level=0.05)

## Kolik potrebuji pozorovani, kdyz chci odhalit odchylku od nulove hypotezy o velikosti 1, 
#   pri smerodatne odchylce 5, se silou testu 0.90, na hladine vyznamnosti 0.05?
pwr.t.test(d=1/5, sig.level=0.05, power=0.90, type="one.sample") # Jednovýběrový t-test
# Potřebuji 264 pozorování

## Kolik potrebuji pozorovani, kdyz chci odhalit rozdil ve dvou skupinach o velikosti 5,
#   pri ocekavane sdruzene smerodatne odchylce 10, se silou testu 0.9, na hladine vyznamnosti 0.05.
pwr.t.test(d=5/10, sig.level=0.05, power=0.90, type="two.sample") # Dvouvýběrový t-test
# Potřebuji 85 pozorování v každé skupině (tedy celkem 170 pozorování)

## Kolik budeme potrebovat pozorovani, kdyz budeme testovat nezavislost dvou kategorickych
#   promennych s peti a ctyrmi kategoriemi. Zajima nas "effect size" o velikosti 0.4, 
#   sila testu 0.9 a hladina vyznamnosti 0.05.
# https://en.wikipedia.org/wiki/Chi-squared_test
pwr.chisq.test(w=0.4, df=(5-1)*(4-1), power=0.90, sig.level=0.05)
# Potřebuji 136 pozorování
# kategorická proměnná s pěti kategoriemi = kontingenční tabulka o jednom sloupci a 4 řádcích
# kategorická proměnná se čtyřmi kategoriemi = kontingenční tabulka o jednom sloupci a 5 řádcích

###################
### Nacteni dat Stulong.RData
## data z velke studie, ktera u muzu stredniho veku merila riziko srdecni choroby

load("Stulong.RData")
View(Stulong)
names(Stulong)<-c("ID", "vyska", "vaha", "syst1", "syst2", "chlst", "vino", "cukr",
                  "bmi", "vek", "KOURrisk", "Skupina", "VekK")

###################
### Vecna vyznamnost
library(effectsize)
library(DescTools)

## Je vyznamny rozdil ve vysce mezi starsimi a mladsimi muzi? (promenne vyska, VekK)
ciselna <- Stulong$vyska
kategoricka <- Stulong$VekK

# Test normality pro kazdou skupinu zvlast
par(mfrow = c(1,2))
tapply(ciselna, kategoricka, PlotQQ)
par(mfrow = c(1,1))

tapply(ciselna, kategoricka, shapiro.test)
  # jsou odchylky od normality skutecne vyznamne?
  # pri velkem poctu pozorovani se divame jen na grafy
  # číselný test normality jako Shapirův test zde nemá smysl (QQPlot nebo Histogram je lepší)
  # Shapiro test by zamítl H0 (tedy by tvrdil, že data nejsou normálně rozdělena) - ale přibližně jsou

# Test shody rozptylu
var.test(ciselna ~ kategoricka)

# pouzijeme dvouvyberovy t-test
# H0: střední hodnoty jsou stejné
# H1: střední hodnoty se liší
t.test(ciselna ~ kategoricka, var.eq = T)
t.test(ciselna ~ kategoricka)
  # Je rozdil ve vyskach skutecne vyznamny?
  # Zamítáme H0, platí alternativa - takže rozdíly středních hodnot se liší
  # O jak moc se liší? Ve výsledku jsou průměry 176.4812 a 175.1894 a ty odečteme, takže 1,3 cm rozdíl
  # V testu vyšlo, že rozdíl 1,3 cm je statisticky významný - ale opravdu?
  # Ne vše, co výjde jako statisticky významný nemusí být věcně významné - zde 1 cm rozdíl není věcně významný

### Statistiky vecne vyznamnosti
cohens_d(ciselna ~ kategoricka) # Velikost efektu 0.21 a 95% CI je interval spolehlivosti
  # Cohenovo d (interpretace: malý efekt - small)
  interpret_cohens_d(cohens_d(ciselna ~ kategoricka))

hedges_g(ciselna ~ kategoricka)
  # Hedgesovo g
  interpret_hedges_g(hedges_g(ciselna ~ kategoricka))

glass_delta(ciselna ~ kategoricka)
  # Glassovo delta
  interpret_glass_delta(glass_delta(ciselna ~ kategoricka))

eta_squared(aov(ciselna ~ kategoricka))
  # Fisherovo eta
  # anova vypočítá tabulku analýzy rozptylu
  (A <- anova(aov(ciselna ~ kategoricka)))
    A[,2]
    A[1,2]/(sum(A[,2]))
  interpret_eta_squared(0.01, rules = "cohen1992")

omega_squared(aov(ciselna ~ kategoricka))
  # Haysova omega
  (A[1,2] - A[2,3])/(sum(A[,2]) + A[2,3])

epsilon_squared(aov(ciselna ~ kategoricka))
  # dalsi charakteristika

###################
### Analyza rozptylu
# testujeme rozdíly mezi více skupinami
# předpoklady: 
#   1. normalita
#      - klasická ANOVA - normální, shodné rozptyly
#      - Welchova ANOVA - normální, různé rozptyly
#      - Kruskal-Wallis - není normální
#   2. shoda rozptylů
# H0: střední hodnoty jsou stejné
# H1: střední hodnoty se liší
# jednostranná alternativa zde ani nejde použít
ciselna <- Stulong$vaha
kategoricka <- Stulong$Skupina

# Mediány jsou víceméně stejné
# Zásadní rozdíl zde nejde vidět
# Máme odlehlé hodnoty
# NS&NSS - má odlehlou hodnotu u 100 kg, ale zároveň to není nějaká extrémní hodnota, která by nebyla běžná
plot(ciselna ~ kategoricka)

# Test normality pro residua modelu
res <- residuals(lm(ciselna ~ kategoricka))
PlotQQ(res, pch = 19)
  # jsou videt odchylky od normality
  # takže nemáme normální rozdělení
  # Tím pádem použijeme Kruskal-Wallisův test

# Test shody rozptylu (Bartlettův test)
bartlett.test(ciselna ~ kategoricka)

### Testy analyzy rozptylu

# klasicka ANOVA pro normalne rozdelena data se shodnymi rozptyly ve skupinach
anova(aov(ciselna ~ kategoricka))
  # tabulka analyzy rozptylu

# Welchova ANOVA pro normalne rozdelena data s ruznymi rozptyly ve skupinach
oneway.test(ciselna ~ kategoricka, var.eq = FALSE)

# Kruskal-Wallisova ANOVA pro nenormalne rozdelena data
kruskal.test(ciselna ~ kategoricka)

# vsechny testy ukazuji vyznamne rozdily (ale ne konkrétně jaké dvojice skupin - analýza rozptylu jen řekne, že se nějaké liší)
# zde se nehodí dvouvýběrový test (resp. je to špatný postup), ale párové srovnání
# ktere konkretni dvojice skupin se od sebe vyznamne lisi
# parove srovnani pro normalne rozdelena data!
# spočítá interval spolehlivosti a p-hodnotu
TukeyHSD(aov(ciselna ~ kategoricka))
  plot(TukeyHSD(aov(ciselna ~ kategoricka)))
  # nekdy se deli podle shody rozptylu
  # interval spolehlivosti pro rozdíl průměrů
  # pokud obsahuje nulu, tak je to statisticky významné??
  
# parove srovnani pro nenormalne rozdelena data!
# pro každý rozdíl určí p-hodnotu
DunnTest(ciselna ~ kategoricka)

## a jsou zjistene rozdily i vecne vyznamne? 
# Fisherovo eta
eta_squared(aov(ciselna ~ kategoricka))
  interpret_eta_squared(0.03, rules = "cohen1992")

# Haysova omega
omega_squared(aov(ciselna ~ kategoricka))
  interpret_omega_squared(0.02, rules = "cohen1992")

epsilon_squared(aov(ciselna ~ kategoricka))
  interpret_epsilon_squared(0.02, rules = "cohen1992")

###################
## Souvisi spolu diagnosticka Skupina a vek muzu (promenne Skupina, VekK)
# 1. Zvolení proměnných
# 2. Tabulka absolutních četností
# 3. Chi kvadrát test (žádné upozornění, takže jeho předpoklady jsou splněné)
kat1 <- Stulong$Skupina
kat2 <- Stulong$VekK

(tab <- table(kat1, kat2))
plot(as.factor(kat1) ~ as.factor(kat2), col=2:5)
chisq.test(kat1, kat2)
  # je rozdil ve skupinach skutecne podstatny?

# Cramerovo V (fungují jako korelační koeficient, ale bez záporných hodnot - takže 0 a 1)
cramers_v(tab)
  sqrt(chisq.test(tab)$statistic/(sum(tab)*(ncol(tab)-1)))
cohens_w(tab)
  
## Souvisi spolu konzumace vina a vek muzu (promenne vino, VekK)
kat1 <- Stulong$vino
kat2 <- Stulong$VekK

(tab <- table(kat1,kat2))
plot(as.factor(kat1) ~ as.factor(kat2), col=2:5)
chisq.test(kat1, kat2)
  # je rozdil ve skupinach skutecne podstatny?

# Cramerovo phi
phi(tab)  
cohens_w(tab)

# Cramerovo phi
  sqrt(chisq.test(tab)$statistic/sum(tab))

###################
## Souvisi spolu vaha a hladina cholesterolu?
cislo1 <- Stulong$vaha
cislo2 <- Stulong$chlst
plot(cislo1 ~ cislo2, pch=19, main="Souvislost vahy a hladiny cholesterolu")

# Pearsonův korelační koeficient (ukazatel věcné významnosti)
cor(cislo1, cislo2)
cor.test(cislo1, cislo2)
  # Zavislost je statisticky vyznamna
  interpret_r(cor(cislo1, cislo2))

summary(lm(cislo1 ~ cislo2))$r.squared  
  # koeficient determinace
  # kolik procent variability zavisle promenne se modelem vysvetlilo (1 % - což je nic - takže věcně to nic neznamená, i když to bylo statisticky významné)
  interpret_r2(summary(lm(cislo1 ~ cislo2))$r.squared)

#######################
### Samostatne

## Zavisi bmi na koureni? Zjistete statistickou i vecnou vyznamnost.
bmi <- Stulong$bmi
koureni <- Stulong$KOURrisk
boxplot(bmi ~ koureni)
cohens_d(bmi ~ koureni)
anova(aov(bmi ~ koureni))

## Zavisi systolicky tlak na vaze?
## Je rozdil mezi skupinami v hladine cukru v krvi?
ciselna <- Stulong$cukr
kategoricka <- Stulong$VekK

## Je rozdil v systolickem tlaku u kuraku a nekuraku?
ciselna <- Stulong$syst1
kategoricka <- Stulong$KOURrisk

par(mfrow = c(1,2))
tapply(ciselna, kategoricka, PlotQQ)
par(mfrow = c(1,1))

tapply(ciselna, kategoricka, shapiro.test)
var.test(ciselna ~ kategoricka)
t.test(ciselna ~ kategoricka)

## Lisi se vyska u tech co piji a nepiji vino?
# H0: Výška se u těch, co pijí a nepijí víno neliší
# H1: Výška se u těch, co pijí a nepijí víno liší
# Věcně se neliší, ale statisticky ano (zamítáme H0, platí H1)
ciselna <- Stulong$vyska
kategoricka <- Stulong$vino # 2 skupiny (FALSE/TRUE)

par(mfrow = c(1,2))
tapply(ciselna, kategoricka, PlotQQ)
par(mfrow = c(1,1))

tapply(ciselna, kategoricka, shapiro.test)
var.test(ciselna ~ kategoricka)
t.test(ciselna ~ kategoricka)