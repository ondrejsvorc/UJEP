# Okruh 1

## Číselná proměnná
```r
data(mtcars)
selected_var <- mtcars$mpg

summary(selected_var)
sd(selected_var)
var(selected_var)

hist(selected_var, 
     main = "Histogram proměnné mpg", 
     xlab = "mpg", 
     col = "skyblue", 
     border = "black")

boxplot(selected_var, 
        main = "Boxplot proměnné mpg", 
        ylab = "mpg", 
        col = "lightgreen")
```

## Kategorická proměnná
```r
data(mtcars)
selected_var <- as.factor(mtcars$gear)

data.frame(cbind(
  "Absolutni" = table(selected_var),
  "Relativni" = prop.table(table(selected_var)),
  "Kumulativni" = cumsum(table(selected_var)),
  "KumulativniRelativni" = cumsum(prop.table(table(selected_var)))
))

barplot(abs_freq, 
        main = "Sloupcový graf proměnné gear", 
        xlab = "Počet rychlostních stupňů", 
        ylab = "Počet vozidel", 
        col = "orange")

colors <- rainbow(length(abs_freq))
pie(abs_freq, 
    main = "Koláčový graf proměnné gear", 
    col = colors)
legend("topright", 
       legend = paste(names(abs_freq), "- stupňů"), 
       fill = colors, 
       title = "Počet rychlostí")
```

# Okruh 2

## Odhady střední hodnoty
- oba způsoby níže mají za cíl odhadnout z výběrového souboru průměr základního souboru
- čím více máme měření ve výběrovém souboru, tím blíže jsem průměru základního souboru
- základní soubor = populace
- výběrový soubor = vzorek

### Bodový odhad střední hodnoty
- Jediná hodnota sloužící jako odhad skutečné střední hodnoty populace.  
- Nejčastěji se používá **aritmetický průměr** ze vzorku.  
- Každý vzorek z populace může mít jiný průměr kvůli náhodné variabilitě.
- Náhoda může způsobit, že vzorek obsahuje více extrémních hodnot, což ovlivní průměr.  
- **Malé vzorky** jsou náchylnější k chybám, **větší vzorky** poskytují přesnější odhad.

### Intervalový odhad střední hodnoty
- Určuje **rozmezí hodnot**, kde se s určitou spolehlivostí nachází skutečný průměr populace.  
- Zohledňuje **variabilitu dat** a **velikost vzorku**.  
- **Interval spolehlivosti** ukazuje rozmezí, kde by mohl být skutečný průměr.  
- Pokud použijeme 95% interval spolehlivosti, znamená to, že kdybychom vzali 100 různých vzorků a pro každý spočítali interval, tak 95 z těchto intervalů by pravděpodobně obsahovalo skutečný průměr, a 5 intervalů by ho neobsahovalo.

```r
library(DescTools)

data(mtcars)
selected_var <- mtcars$mpg

# Bodový odhad střední hodnoty
mean(selected_var)

# Intervalový odhad střední hodnoty
MeanCI(selected_var, conf.level = 0.95)

# Obojí
t.test(selected_var)
```

## Odhady rozdílu středních hodnot

### Bodový odhad rozdílu středních hodnot
- prostý rozdíl dvou výběrových průměrů

### Intervalový odhad rozdílu středních hodnot
- interval, ve kterém se s určitou spolehlivostí nachází skutečný rozdíl průměrů

```r
library(DescTools)
data(mtcars)

# Výběr skupin horsepower podle počtu stupňů na převodovce
group_4_hp <- mtcars$hp[mtcars$gear == 4]
group_5_hp <- mtcars$hp[mtcars$gear == 5]

# Bodový odhad rozdílu středních hodnot
mean(group_5_hp) # 195.6
mean(group_4_hp) # 89.5
mean(group_5_hp) - mean(group_4_hp) # 106.1
mean(group_4_hp) - mean(group_4_hp) # -106.1

# Intervalový odhad rozdílu středních hodnot

# meandiff    lwr.ci    upr.ci 
# 106.10000 -20.72102 232.92102 
MeanDiffCI(group_5_hp, group_4_hp)

# meandiff     lwr.ci     upr.ci 
# -106.10000 -232.92102   20.72102 
MeanDiffCI(group_4_hp, group_5_hp)
```
Výsledky ukazují, že auta s 5 převodovými stupni mají průměrně o 106,1 hp vyšší výkon než auta se 4 stupni. Intervalový odhad rozdílu středních hodnot <–20,72; 232,92> znamená, že s 95% spolehlivostí se skutečný rozdíl výkonu může pohybovat od –20,72 hp do +232,92 hp. Protože tento interval obsahuje nulu, nelze s jistotou říct, že mezi těmito skupinami existuje statisticky významný rozdíl. Stejný výsledek s opačnými znaménky získáme při prohození skupin, což potvrzuje, že směr rozdílu je závislý na pořadí skupin. Pokud změníme pořadí skupin na group_4_hp - group_5_hp, výsledný bodový odhad je totiž –106,1 hp. To znamená, že auta se 4 převodovými stupni mají průměrně o 106,1 hp méně než auta s 5 stupni.

Interval není statisticky významný proto, že skutečný rozdíl může být kladný, záporný nebo dokonce nulový (dolní mez intervalu je záporná, interval jako takový zahrnuje nulu, a horní mez je kladná). Jinými slovy, nemůžeme s jistotou tvrdit, že mezi skupinami existuje rozdíl – je možné, že žádný rozdíl neexistuje. Statisticky významný rozdíl existuje pouze tehdy, když celý interval leží buď nad nulou (kladný rozdíl) nebo pod nulou (záporný rozdíl).

### Bodový odhad podílu
- Vyjadřuje, jaká část vzorku má určitou vlastnost.  

### Intervalový odhad podílu
- Udává rozmezí, ve kterém se s určitou spolehlivostí nachází skutečná míra výskytu dané vlastnosti v celé populaci.

### Bodový odhad rozdílu podílů
- Rozdíl podílů dvou skupin.  

### Intervalový odhad podílu
- Rozmezí, ve kterém se s určitou spolehlivostí nachází rozdíl mezi mírami výskytu dané vlastnosti ve dvou populacích.

```r
library(DescTools)

# Bodový odhad podílu aut s automatickou převodovkou (0 = automat)
# 0.59375
# 59,4 % aut v datasetu má automatickou převodovku.
sum(mtcars$am == 0) / nrow(mtcars)

# Intervalový odhad podílu (95 %)
#   est    lwr.ci    upr.ci
# 0.59375 0.4226002 0.7448037
# S 95% spolehlivostí leží skutečný podíl aut s automatem mezi 42,3 % a 74,5 %.
BinomCI(x = sum(mtcars$am == 0), n = nrow(mtcars), conf.level = 0.95)

group_4 <- mtcars[mtcars$gear == 4, ]
group_5 <- mtcars[mtcars$gear == 5, ]

# Bodový odhad rozdílu podílů
# 0.3333333
# Auta se 4 převody mají o 33,3 % vyšší podíl automatických převodovek než auta s 5 převody.
(sum(group_4$am == 0) / nrow(group_4)) - (sum(group_5$am == 0) / nrow(group_5))

# Intervalový odhad rozdílu podílů
#   est   lwr.ci    upr.ci
# 0.3333333 -0.14654 0.5751115
# S 95% jistotou lze říci, že rozdíl podílů mezi auty se 4 a 5 převody se nachází v rozmezí od –14,7 % do 57,5 %.
BinomDiffCI(x1 = sum(group_4$am == 0), n1 = nrow(group_4), x2 = sum(group_5$am == 0), n2 = nrow(group_5), conf.level = 0.95)
```

## Testování statistických hypotéz
- **H₀**: Nulová hypotéza
- **H₁**: Alternativní hypotéza (negace nulové hypotézy)
- **α**: Hladina významnosti (typicky 0.05)
- **p-hodnota**: Nejmenší hladina významnosti, při které ještě zamítneme nulovou hypotézu
- **p-hodnota ≤ α**: Zamítáme nulovou hypotézu
- **p-hodnota > α**: Nezamítáme nulovou hypotézu v prospěch alternativní hypotézy

```r
library(DescTools)
data(mtcars)

# Výběr skupin horsepower podle počtu stupňů na převodovce
group_4_hp <- mtcars$hp[mtcars$gear == 4]
group_5_hp <- mtcars$hp[mtcars$gear == 5]

# T-test
# H₀: Neexistuje rozdíl mezi průměrnými hodnotami výkon aut s 4 a 5 převodovkami.
# H₁: Existuje rozdíl mezi průměrnými hodnotami výkon aut s 4 a 5 převodovkami.
# p-hodnota > 0.05 (0.08169)
# Nezamítáme H0 (nemáme důkaz, že existuje).
t.test(group_5_hp, group_4_hp, var.equal = FALSE)
```

## Hodnocení vzájemné souvislosti dvou číselných proměnných
- Hodnotíme pomocí tří základních vlastností: tvar, směr a síla.

### Tvar souvislosti
- Lineární souvislost
- Nelineární souvislost

### Směr souvislosti
- Přímá souvislost
- Nepřímá souvislost

### Síla souvislosti
- Slabá souvislost
- Střední souvislost
- Silná souvislost

### Korelační koeficient
- **r** náleží na intervalu **<-1, 1>**
- **r > 0**: Přímá závislost.
- **r < 0**: Nepřímá závislost.
- **|r|** blízké 1: Silná závislost.
- **|r|** blízké 0: Slabá závislost.

```r
library(psych)

data(mtcars)

# Korelační diagram (bodový graf)
plot(mtcars$hp, mtcars$mpg,
     main = "Vztah mezi výkonem (hp) a spotřebou (mpg)",
     xlab = "Výkon motoru (hp)",
     ylab = "Spotřeba paliva (mpg)",
     pch = 19, col = "blue")
abline(lm(mpg ~ hp, data = mtcars), col = "purple", lwd = 2)
legend("topright", legend = "Regresní přímka", col = "purple", lwd = 2)

# Pearsonův korelační koeficient
# -0.7761684
cor(mtcars$hp, mtcars$mpg, method = "pearson")

# Korelační matice
#             hp        mpg
# hp   1.0000000 -0.7761684
# mpg -0.7761684  1.0000000
cor(mtcars[, c("hp", "mpg")])

# Matice bodových grafů
pairs(mtcars[, c("hp", "mpg")],
      main = "Matice bodových grafů",
      pch = 19,
      col = "blue",
      labels = c("Výkon (hp)", "Spotřeba (mpg)"))
```

**Tvar**: Lineární vztah potvrzený regresní přímkou.  
**Směr**: Nepřímá souvislost (když se výkon zvyšuje, spotřeba paliva klesá).  
**Síla**: Silná souvislost (hodnota je blízko -1).  

**Silná nepřímá lineární souvislost**.

## Regresní přímka (rovnice regresní přímky)
- `y = β0 + β1x`
- **y**: vysvětlovaná (závislá) proměnná
- **x**: vysvětlující (nezávislá) proměnná
- **β0**: konstantní člen (udává posunutí přímky po ose y)
- **β1**: směrnice přímky (určuje sklon přímky)
- β0 i β1 jsou neznámé konstanty, odhadnuté/vypočítané z dat
- smyslem je vlastně najít takovou přímku, která bude co nejblíže každému z bodů
- každá taková přímka prochází bodem [x_prumer, y_prumer] (tedy průsečík je průměr vysvětlující a vysvětlované proměnné)

[Lineární regrese](https://ksoc.ff.cuni.cz/wp-content/uploads/sites/76/2018/09/6.-Statistika2-Line%C3%A1rn%C3%AD-regrese.pdf)

```r
x <- c(1, 2, 3, 4, 5)
y <- c(2, 4, 5, 4, 5)

x_mean <- mean(x)
y_mean <- mean(y)

beta1 <- sum((x - x_mean) * (y - y_mean)) / sum((x - x_mean)^2)
beta0 <- y_mean - beta1 * x_mean

cat("Ručně vypočítané koeficienty:\n")
cat("beta0 =", beta0, "\n")
cat("beta1 =", beta1, "\n")
cat("y=",beta0, "+",beta1,"x")

regression_model <- lm(y ~ x)
summary(regression_model)
coefficients <- coef(regression_model)
beta0_model <- coefficients[1]  # Průsečík (Intercept)
beta1_model <- coefficients[2]  # Sklon

cat("y = ", round(beta0, 2), " + ", round(beta1, 2), " * x", sep = "") # y = 2.2 + 0.6 * x
cat("y = ", round(beta0_model, 2), " + ", round(beta1_model, 2), " * x", sep = "") # y = 2.2 + 0.6 * x
```
![1_regrese](https://github.com/user-attachments/assets/803e95b6-c079-4bfa-bb7d-d349b43f2ec1)
![2_regrese](https://github.com/user-attachments/assets/65e40a37-6bfc-4bb3-992f-45931f78267b)
![3_regrese](https://github.com/user-attachments/assets/944e8918-be68-47b3-9f1a-d317e56284f5)
![4_regrese](https://github.com/user-attachments/assets/b15a4c1c-b1bb-4c64-95c9-44e3763c5b30)
![5_regrese](https://github.com/user-attachments/assets/988c08e8-2585-4f16-bcee-8d78557bcb4a)
![6_regrese](https://github.com/user-attachments/assets/7e09b135-efe5-434e-958c-be0d7680c971)

## Identifikace vhodného podkladového rozdělení dat
```r
library(fitdistrplus)

data(mtcars)
data <- mtcars$hp

distributions <- list(
  norm = fitdist(data, "norm"),
  logis = fitdist(data, "logis"),
  lnorm = fitdist(data, "lnorm"),
  exp = fitdist(data, "exp"),
  gamma = fitdist(data, "gamma"),
  weibull = fitdist(data, "weibull"),
  cauchy = fitdist(data, "cauchy")
)

distributions_comparison <- data.frame(
  Distribution = names(distributions),
  AIC = sapply(distributions, function(x) x$aic),
  BIC = sapply(distributions, function(x) x$bic)
)
distributions_comparison <- distributions_comparison[order(distributions_comparison$AIC, distributions_comparison$BIC), ]
print(distributions_comparison)

# distr      AIC      BIC
# 3 Lognorm 358.6263 361.5577
# 5   Gamma 358.8478 361.7792
# 6 Weibull 360.7755 363.7070
# 1    Norm 364.3722 367.3037
# 2   Logis 365.0600 367.9914
# 7  Cauchy 376.5285 379.4600
# 4     Exp 385.2515 386.7172

plot_qq <- function(distribution, name, data) {
  params <- distribution$estimate
  p_points <- ppoints(length(data))
  
  param1 <- params[1]  # První parametr (mean, meanlog, rate, shape, location)
  param2 <- params[2]  # Druhý parametr (sd, sdlog, rate, scale)
  
  quantiles <- switch(distribution$distname,
              norm = qnorm(p_points, param1, param2),      # mean, sd
              lnorm = qlnorm(p_points, param1, param2),    # meanlog, sdlog
              exp = qexp(p_points, param1),                # rate
              gamma = qgamma(p_points, param1, param2),    # shape, rate
              weibull = qweibull(p_points, param1, param2),# shape, scale
              logis = qlogis(p_points, param1, param2),    # location, scale
              cauchy = qcauchy(p_points, param1, param2)   # location, scale
  )
  
  qqplot(quantiles, mtcars$hp, main = paste("Q-Q Plot:", name))
  abline(0, 1, col = "red")
}

best_distribution <- distributions_comparison$Distribution[1]
plot_qq(distributions[[best_distribution]], best_distribution, data)
```

## Hodnocení normality a tvaru rozdělení
```r
# Předpoklady normálního rozdělení:
# - Histogram má zvonovitý tvar
# - Data na bodovém grafu jsou přibližně na křivce
# - Medián ≈ Průměr
# - Šikmost ≈ 0
# - Špičatost ≈ 0 (≈ 3?)

set.seed(123)
data <- rnorm(100, mean = 0, sd = 1)

# Histogram
hist(data,
     main = "Histogram s průměrem a mediánem",
     xlab = "Hodnoty",
     ylab = "Frekvence výskytu",
     col = "lightblue",
     breaks = 10,
     border = "black")
abline(v = mean(data), col = "red", lwd = 2, lty = 2)
abline(v = median(data), col = "blue", lwd = 2, lty = 2)
legend("topright",
       legend = c("Průměr", "Medián"),
       col = c("red", "blue"),
       lwd = 2,
       lty = 2,
       box.lty = 0)

# Q-Q Plot
# Tři případy:
# 1. Pokud jsou body blízko přímky → Data jsou pravděpodobně normálně rozdělená.
# 2. Pokud body výrazně odchylují od přímky na začátku nebo na konci, znamená to problém s normalitou (např. špičatost nebo plochost rozdělení).
# 3. Pokud je patrný jasný vzor (např. křivka místo přímky), data nejsou normálně rozdělená.
# Zde nastává 1. případ.
qqnorm(data)
qqline(data, col = "red")

# Shapiro-Wilk test
# Statistický test, který ověřuje, zda data pocházejí z normálního rozdělení
# H0: Data pocházejí z normálního rozdělení.
# H1: Data nepocházejí z normálního rozdělení.
# p-hodnota > 0.05: Nemáme dostatek důkazů pro zamítnutí nulové hypotézy → Data jsou v souladu s normálním rozdělením.
# p-hodnota ≤ 0.05: Zamítáme nulovou hypotézu → Data nejsou normálně rozdělená.
# p-value = 0.9349
# p-hodnota je větší než 0.05, což znamená, že nezamítáme nulovou hypotézu.
# Data jsou pravděpodobně normálně rozdělená.
shapiro.test(data)

Skew(data)  # Šikmost (0.05959426)
Kurt(data)  # Špičatost (-0.217548)
```

## Identifikace odlehlých hodnot
- boxplot (krabicový graf) - rychlá vizuální detekce odlehlých hodnot, které se zobrazí jako samostatné body mimo "fousy" grafu
- funkce Outlier() z knihovny DescTools, která numericky identifikuje odlehlé hodnoty na základě pravidla 1,5násobku IQR

```r
data(mtcars)
hp_data <- mtcars$hp

# Krabicový graf
boxplot(hp_data,
        main = "Boxplot pro proměnnou hp (výkon motoru)",
        ylab = "Výkon (hp)",
        col = "lightblue")

# Výpočet odlehlých hodnot manuálnějším způsobem
Q1 <- quantile(hp_data, 0.25)
Q3 <- quantile(hp_data, 0.75)
IQR_value <- IQR(hp_data)
lower_bound <- Q1 - 1.5 * IQR_value
upper_bound <- Q3 + 1.5 * IQR_value
outliers <- hp_data[hp_data < lower_bound | hp_data > upper_bound]
print(outliers) # 335

# Vypočet odlehlých hodnot pomocí funkce z knihovny DescTools
odlehla_pozorovani <- Outlier(hp_data, method = "boxplot", na.rm = TRUE)
print(odlehla_pozorovani) # 335
```

![image](https://github.com/user-attachments/assets/6f5e1116-04ce-4407-bf13-a3576364b5d5)

# Okruh 3

## Klasifikace proměnných a typů dat
![image](https://github.com/user-attachments/assets/eb7d2bb2-03af-414d-8a07-4ce5dd6bd4db)

## Rozdělení náhodné veličiny
Více informací [zde](https://github.com/ondrejsvorc/UJEP/blob/main/PAS/summary.md#rozd%C4%9Blen%C3%AD-pravd%C4%9Bpodobnosti).

## Spojité náhodné veličiny

## Diskrétní náhodné veličiny

## Tradiční versus robustní přístupy k odhadování
## Bodový versus intervalový odhad
## Tradiční versus bootstrapový přístup k statistické inferenci
## Zákon velkých čísel a jeho využití, centrální limitní věta a její využití
## Přístupy k testování statistických hypotéz
## Interpretační problémy a aspekty intervalového odhadu a p-hodnoty
## Kovariance a korelace
## Jádrový odhad hustoty a modus
## Populace, náhodný a nenáhodný výběr, populační a výběrové charakteristiky
## Frekvenční rozdělení a frekvenční křivka
## Histogram a jeho citlivost na volbu offsetu a šířky okna

## Vlastnosti popisných statistik, jejich reakce na posunutí a změnu měřítka
- chovají se vesměs odlišně při posunutí dat (přičtení konstanty) a při změně měřítka (vynásobení konstantou)
- průměr, medián i modus reagují stejně jak na posunutí, tak i na změnu měřítka

### Průměr/Medián/Modus a jejich reakce na posunutí
- Posunou se o stejnou konstantu.
- Přičtení 5 ke všem hodnotám zvýší průměr/medián/modus o 5.
- Pokud ale přidáme nebo změníme hodnotu, která není častá, modus se nemusí změnit vůbec.

### Průměr / Medián / Modus / Směrodatná odchylka a jejich reakce na změnu měřítka
- Násobí se stejnou konstantou.
- Násobení 2 všech hodnot zdvojnásobí průměr/medián/modus.

### Rozptyl / Směrodatná odchylka a jejich reakce na posunutí
- **nemění se**, přičtení konstanty posouvá všechna data, ale rozdíly mezi nimi zůstávají stejné

### Rozptyl a jeho reakce na změnu měřítka
- všechny hodnoty se násobí konstantou na druhou
- Např. násobení 3 → rozptyl se zvětší 9×
- Když zvětšíš všechny hodnoty 3-krát zvětšíme, vzdálenost od průměru se také zvětší 3-krát, ale rozptyl tyto rozdíly umocňuje. Proto se změna projeví kvadraticky

### Šikmost/Špičatost a jejich reakce
- nemění se v žádném případě
- tyto statistiky vyjadřují tvar rozdělení, který zůstává stejný

## Normování proměnné a význam

### Z-Score normalizace
- Převádí data tak, aby měla průměr 0 a směrodatnou odchylku 1.
- Zachovává tvar rozdělení dat, ale mění jejich měřítko.
- Používá se, když data obsahují odlehlé hodnoty.
- `z = (x - μ) / σ`
  - x: původní hodnota  
  - μ: průměr dat  
  - σ: směrodatná odchylka
 
### Z-skóre
- Udává, kolik **směrodatných odchylek** leží hodnota od **průměru**.  
- Bez Z-skóre bychom museli srovnávat hodnoty s průměrem ručně.
- Pomáhá jednoznačně identifikovat, zda je hodnota **běžná** (průměrná) nebo **výjimečná** (nadprůměrná/podprůměrná).
- **Příklad:** Z-skóre \( z = 2 \) znamená, že hodnota je **dvě směrodatné odchylky nad průměrem**.
- `z ≈ 0`: Hodnota je přibližně průměrná
- `z > 0`: Hodnota je nadprůměrná (Čím vyšší kladné Z-skóre, tím víc je hodnota nadprůměrná).
- `z < 0`: Hodnota je podprůměrná (Čím je Z-skóre více záporné, tím víc je hodnota podprůměrná).
- Čím větší absolutní hodnota Z-skóre, tím více se hodnota odchyluje od průměru.
  
```r
data(mtcars)

prumer_mpg <- mean(mtcars$mpg)
sm_odch_mpg <- sd(mtcars$mpg)

z_score_manual <- (mtcars$mpg - prumer_mpg) / sm_odch_mpg
z_score_scale <- scale(mtcars$mpg)

cat("Průměr mpg:", prumer_mpg, "\n")
cat("Směrodatná odchylka mpg:", sm_odch_mpg, "\n\n")

comparison <- data.frame(
  Original = mtcars$mpg,
  Z_Score_Manual = round(z_score_manual, 4),
  Z_Score_Scale = round(z_score_scale[,1], 4)
)

print(head(comparison, 10))

# Original Z_Score_Manual Z_Score_Scale
# 1      21.0         0.1509        0.1509
# 2      21.0         0.1509        0.1509
# 3      22.8         0.4495        0.4495
# 4      21.4         0.2173        0.2173
# 5      18.7        -0.2307       -0.2307
# 6      18.1        -0.3303       -0.3303
# 7      14.3        -0.9608       -0.9608
# 8      24.4         0.7150        0.7150
# 9      22.8         0.4495        0.4495
# 10     19.2        -0.1478       -0.1478

# Filtrování hodnot s |z-score| > 2
# (potencionální odlehlé hodnoty)
odlehle_hodnoty <- mtcars$mpg[abs(z_score_manual) > 2]
odlehle_z_score <- z_score_manual[abs(z_score_manual) > 2]

cat("Hodnoty s |Z| > 2:\n")
print(data.frame(mpg = odlehle_hodnoty, Z_Score = round(odlehle_z_score, 4)))
```

## Regresní model, jeho účel a odhad

## Předpoklady lineární regrese
- Vztah mezi závislou proměnnou a nezávislou by měl být **lineární** (tedy pak přímý/nepřímý).  
- **Rezidua** (chyby modelu) by měla mít **normální rozdělení** s průměrem 0.  
- Rozptyl reziduí by měl být **stejný** pro všechny hodnoty (tzv. **homoskedasticita**).  
- **Prediktory** (vstupy modelu) by neměly být silně **korelované** mezi sebou (**žádná multikolinearita**).  
- V datech by neměly být **odlehlé hodnoty**, které by mohly ovlivnit výsledky.  
- **Prediktory** by neměly být propojené s **rezidui** (chyby by měly být náhodné).

### Rezidua
- `Reziduum = Skutečná hodnota - Predikovaná hodnota`  
- Rozdíl mezi skutečnými a predikovanými hodnotami závislé proměnné.  
- Vyjadřují chybu modelu při odhadu.  
- Ideálně by měla mít normální rozdělení s průměrem 0.  
- Rozptyl reziduí by měl být konstantní (homoskedasticita).  

### Prediktory
- Nezávislé proměnné, které slouží k předpovědi závislé proměnné.  
- Jsou vstupy modelu, které ovlivňují výslednou predikci.  
- Neměly by být silně korelované mezi sebou (bez multikolinearity).  
- Neměly by být korelované s rezidui.  

### Příklad
Model předpovídá cenu auta na základě jeho stáří a počtu najetých kilometrů.  
- **Prediktory:** stáří auta, počet najetých kilometrů.  
- **Závislá proměnná:** cena auta.  
- **Rezidua:** rozdíly mezi skutečnou cenou auta a cenou, kterou model vypočítal.  
