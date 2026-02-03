## Pokročilé statistické metody

### Užitečné odkazy
- https://kma.ujep.cz/profil/alena-cernikova
- https://docs.google.com/document/d/1WA2M25evFDn-AV-Sfsq3P2kv\_6thJBLe5C2jRokXucc/edit?tab=t.0
- https://docs.google.com/document/d/1E-wic70lhKmbUqgHJUmuggUjI2Udx9I-L2yxrjuz0NM/edit?usp=sharing
- https://is.muni.cz/el/1431/jaro2016/Z2069/um/54271982/56272282/PCA_prez_pondelniskupiny.pdf
- https://naucse.python.cz/2021/pydata-praha-jaro/pydata/pca/
- https://www.investopedia.com/terms/v/variance-inflation-factor.asp
- https://medium.com/@arko_sengupta/stepwise-regression-a-comprehensive-guide-33d837a5e6c1
- https://www.youtube.com/watch?v=IXB_GEuQWyA

## Statistika
- jednorozměrná
- mnohorozměrná

### Jednorozměrná statistika
- pracuje právě s **jednou proměnnou** a pomocí ní porovnává skupiny mezi sebou
- např.: Liší se muži a ženy v průměrném věku dožití (věk)?
- na ni se zaměřoval minulý kurz (PAS)

### Mnohorozměrná statistika
- pracuje s **více proměnnými** a pomocí nich porovnává skupiny mezi sebou
- např.: Liší se muži a ženy celkovým zdravotním profilem (věk, výška, váha, tlak, cholesterol, …)?
- na ni se zaměřuje tento kurz (PSM)

## Metody
- metoda hlavních komponent
- faktorová analýza
- diskriminační analýza
- shluková analýza
- kanonická korelace

### Metoda hlavních komponent
- anglicky: Principal Component Analysis (PCA)
- pracuje s vektory proměnných jednotlivých pozorování a jejím cílem je nahradit původní (často korelované) proměnné menším počtem hlavních (souhrnných) komponent tak, aby se zachovalo co nejvíce variability dat a ztratilo se co nejméně informace
- pokud ve vektoru pozorování neexistují vzájemně související (korelované) proměnné, metoda nepřináší smysluplnou redukci dimenzionality, protože každá proměnná nese vlastní informaci a nelze je shrnout do menšího počtu komponent
- slouží k dekoleraci dat a ke snížení dimenze dat s co nejmenší ztrátou informace
- komponenty jsou seřazeny podle množství variability, kterou vysvětlují (PC1 nejvíce, ...)
- předpoklad: spojitá data nebo diskrétní data blížící se spojitým

```r
X <- wine[, setdiff(names(wine), "Cultivar")]
pca <- prcomp(X, scale. = TRUE)
```

### Složení hlavní komponenty
- proměnné s největší absolutní hodnotou zatížení komponentu definují a do určité míry umožňují její interpretaci

```r
pca$rotation
```

```r
interpret_pca_loadings <- function(pca, components = 3, top_n = 5) {
  loadings <- pca$rotation

  for (pc in seq_len(components)) {
    cat(sprintf("PC%d:\n", pc))

    pc_loadings <- loadings[, pc]
    pc_loadings <- pc_loadings[order(abs(pc_loadings), decreasing = TRUE)]
    pc_loadings <- pc_loadings[seq_len(top_n)]

    for (var in names(pc_loadings)) {
      cat(sprintf("  %s: %.3f\n", var, pc_loadings[var]))
    }

    cat("\n")
  }

  invisible(loadings)
}
```

Každá komponenta má vlastní váhy a ty váhy říkají, které proměnné jsou pro danou komponentu více důležité a které méně. Komponenta funguje jako funkce, která z původních vlastností vína vypočte jedno číslo – skóre – určující jeho polohu vzhledem k dané komponentě.
$$
\mathrm{PC}_k = a_1 x_1 + a_2 x_2 + \cdots + a_p x_p
$$
kde:
- $k$ označuje číslo hlavní komponenty,
- $p$ je počet původních proměnných,
- $x_1, \dots, x_p$ jsou hodnoty původních (standardizovaných) proměnných,
- $a_1, \dots, a_p$ jsou váhy (zatížení) těchto proměnných v $k$-té hlavní komponentě.

Konkrétní příklad:
$$
\begin{aligned}
\mathrm{PC}_1 =\;&
-0.144 \cdot \text{Alcohol}
+0.245 \cdot \text{Malic.acid}
+0.002 \cdot \text{Ash}
+0.239 \cdot \text{Alcalinity.of.ash} \\
&-0.142 \cdot \text{Magnesium}
-0.395 \cdot \text{Total.phenols}
-0.423 \cdot \text{Flavanoids}
+0.299 \cdot \text{Nonflavanoid.phenols} \\
&-0.313 \cdot \text{Proanthocyanin}
+0.089 \cdot \text{Color.intensity}
-0.297 \cdot \text{Hue}
-0.376 \cdot \text{OD280.OD315.of.diluted.wines} \\
&-0.287 \cdot \text{Proline}
\end{aligned}
$$


#### Výstup a interpretace
- hlavní komponenty (PC1, PC2, ...)
- vysvětlená variabilita
- výstup z PCA může mít interpretaci, ale není přirozená a zkrátka tato metoda neslibuje, že vůbec nějaká interpretace bude existovat
- interpretace hlavních komponent není jednoznačná a je subjektivní; opírá se o proměnné s největším absolutním zatížením

```r
interpret_pca <- function(pca, target_variance) {
  summary_pca <- summary(pca)
  explained <- summary_pca$importance["Proportion of Variance", ]
  cumulative <- summary_pca$importance["Cumulative Proportion", ]
  needed <- which(cumulative >= target_variance)[1]

  cat(sprintf("Požadavek: zachovat alespoň %.0f %% variability v datech.\n", target_variance * 100))
  cat(sprintf("Nejmenší počet komponent, který tento požadavek splňuje: %d.\n\n", needed))

  for (i in seq_len(needed)) {
    cat(sprintf("PC%d: %.1f %% (kumulativně %.1f %%)\n", i, explained[i] * 100, cumulative[i] * 100))
  }

  invisible(list(needed_components = needed, explained = explained, cumulative = cumulative))
}
```

### Faktorová analýza
- předpokládá, že existuje skrytý faktor, který způsobuje korelace mezi proměnnými
- př.: máme 20 otázek na spokojenost v práci. Faktorová analýza zjistí, že 10 z nich spolu souvisí kvůli faktoru „peníze“ a dalších 10 kvůli faktoru „kolektiv“.
- využití: Psychologie, marketingové průzkumy.

### Diskriminační analýza
- snaží se najít pravidlo, jak rozdělit objekty do předem známých skupin na základě jejich vlastností
- podobá se logistické regresi, ale je zaměřená na to, které proměnné nejlépe „diskriminují“ (oddělují) skupiny od sebe
- př.: máme data o lebkách (šířka, délka). Analýza určí, které rozměry nejlépe odliší, zda jde o muže nebo ženu.

### Shluková analýza
- na rozdíl od diskriminační analýzy tady skupiny předem neznáme. Algoritmus hledá v datech „shluky“ podobných objektů
- nejčastěji se používá K-means nebo hierarchické shlukování
- př.: rozdělení zákazníků e-shopu do skupin (např. „šetrní“, „lovci slev“, „vážení klienti“) podle jejich nákupního chování.

### Kanonické korelace
- hledá vztah mezi dvěma sadami proměnných (nejen dvěma čísly)
- snaží se zjistit, jak spolu souvisí jeden balík dat s druhým
- najde lineární kombinace (kanonické proměnné), které mají mezi sebou nejvyšší možnou korelaci
- př: souvisí sada proměnných o „psychickém zdraví“ (deprese, úzkost, stres) se sadou proměnných o „životním stylu“ (spánek, strava, pohyb)?

## Testy
- t-test
- dvouvýběrový t-test
- ANOVA
- Hotellingovo T²
- MANOVA

### Volba testu

| Počet proměnných   | Počet skupin | Test            |
|--------------------|--------------|-----------------|
| 1                  | 2            | t-test          |
| 1                  | >2           | ANOVA           |
| >1                 | 2            | Hotellingovo T² |
| >1                 | >2           | MANOVA          |

### t-test
### ANOVA
### Hotellingovo T²
### MANOVA

## Regrese
- jednoduchá lineární regrese
- mnohonásobná lineární regrese
- kroková regrese
- regrese s kategorickou proměnnou
- logistická regrese
- ordinální regrese
- Poissonova regrese
- polynomická regrese

### Jednoduchá lineární regrese
- pro zjistění, jak jedna věc ($X$) ovlivňuje druhou ($Y$) – např. vliv výšky na hmotnost
- **y**: vysvětlovaná (závislá) proměnná
- **x**: vysvětlující (nezávislá) proměnná
- **β0**: konstantní člen (udává posunutí přímky po ose y)
- **β1**: směrnice přímky (určuje sklon přímky)
- smyslem je vlastně najít takovou přímku, která bude co nejblíže každému z bodů
- každá taková přímka prochází bodem [x_prumer, y_prumer] (tedy průsečík je průměr vysvětlující a vysvětlované proměnné)

$$
y = \beta_0 + \beta_1 x + e
$$

```r
# x = Rozpočet na reklamu (Kč)
# y = Počet prodaných alb
x <- c(1000, 2000, 3000, 4000, 5000)
y <- c(130, 150, 170, 210, 240)
data <- data.frame(x, y)

model <- lm(y ~ x, data = data)
summary(model)
coef(model)

plot(
  data$x,
  data$y,
  pch = 19,
  xlab = "Rozpočet na reklamu",
  ylab = "Počet prodaných alb",
  main = "Lineární regrese: reklama vs. prodej"
)
abline(model, col = "red", lwd = 2)
```

### Mnohonásobná lineární regrese
- sleduje vliv více nezávislých proměnných ($x_1, x_2, \dots, x_p$) na jednu závislou proměnnou ($y$)
- u tohoto modelu je nutné hlídat multikolinearitu (vzájemnou závislost mezi $x_1, x_2, \dots, x_p$)

$$
y = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p + e
$$

```r
x1 <- c(1000, 2000, 3000, 4000, 5000)
x2 <- c(2, 2, 4, 5, 5)
y  <- c(130, 145, 180, 215, 235)
data <- data.frame(y, x1, x2)

model <- lm(y ~ x1 + x2, data = data)
summary(model)
coef(model)

# Test homoskedasticity
library(lmtest)
bptest(model)

# Test multikolinearity
library(car)
vif(model)

# Test normálního rozdělení reziduí
shapiro.test(residuals(model))

# Cookova vzdálenost
cooks <- cooks.distance(model)
cooks[which.max(cooks.distance(model))]
plot(cooks, type = "h", lwd = 3, col = "darkred",
     main = "Cookova vzdálenost (Vlivné body)",
     xlab = "Index pozorování (řádek v datech)",
     ylab = "Vzdálenost (D)")
n <- nrow(data)
abline(h = 4/n, col = "blue", lty = 2)
which.max(cooks)

# install.packages("scatterplot3d")
library(scatterplot3d)
s3d <- scatterplot3d(
  data$x1, data$x2, data$y,
  pch = 16,
  color = "steelblue",
  grid = TRUE,
  box = TRUE,
  angle = 55,
  main = "Regresní rovina prodeje alb",
  xlab = "Reklama (x1)",
  ylab = "Hity (x2)",
  zlab = "Alba (y)"
)
s3d$plane3d(model, col = "red", lty.box = "dashed")

predict(model, newdata = data.frame(x1 = 6000, x2 = 3))
```

### Koeficient determinace
- anglicky Coefficient of determination
- značí se $R^2$
- procento variability vysvetlené proměnné
- nabývá hodnot v intervalu $\langle 0, 1 \rangle$ (resp. 0% až 100%)ˇ
- Pokud $R^2 = 0.84$, znamená to, že model vysvětluje $84 \%$ rozptylu dat a zbylých $16 \%$ je náhoda nebo vliv proměnných, které v modelu nejsou
- v R výstupu jej lze najít jako Multiple R-squared

### Adjusted R-squared
- klasické $R^2$ má jednu špatnou vlastnost – roste pokaždé, když je do modelu přidán jakýkoliv další regresor, i kdyby to byl úplný nesmysl
- Adjusted $R^2$ penalizuje model za přidávání proměnných, které nepřinášejí skutečnou informaci
- **v mnohonásobné regresi se díváme vždy na Adjusted $R^2$**

```r
model_summary <- summary(model)
model_summary$adj.r.squared
```

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/R2values.svg/960px-R2values.svg.png" width="400" style="background-color:white;">

### Shapiro-Wilkův test
- testuje vždy tyto hypotézy:
  - $H_0$: Residua mají normální rozdělení.
  - $H_1$: Residua nemají normální rozdělení.
- $p > 0,05$: Nezamítáme $H_0$, residua jsou normálně rozdělena a model splňuje tento předpoklad
- reziduum je rozdíl mezi skutečnou naměřenou hodnotou ($y$) a hodnotou, kterou ti předpověděl tvůj model ($\hat{y}$
- každý bod na grafu má své vlastní reziduum
- pokud bod leží přesně na regresní přímce, jeho reziduum je 0
- pokud je bod daleko od přímky, má reziduum velké

### Breusch-Paganův test
- testuje vždy tyto hypotézy:
  - $H_0$: Rozptyl je stabilní.
  - $H_1$: Rozptyl není stabilní.
- teoreticky přesnější hypotézy:
  - $H_0$: Rozptyl je konstantní (homoskedasticita);
  - $H_1$: Rozptyl se mění (heteroskedasticita)
- zkoumá, zda je rozptyl chyb (reziduí) v celém modelu konstantně stabilní
- pokud se rozptyl mění (např. u větších hodnot $X$ dělá model větší chyby), jde o heteroskedasticitu, nikoliv o homoskedasticitu
- stabilita rozptylu je předpokladem pro metodu nejmenších čtverců, kterou regrese interně používá
- **Homoskedasticita**: rezidua jsou kolem přímky rozptýlená jako rovnoměrný „mrak“. Model měří všude stejně přesně.
- **Heteroskedasticita**: Rezidua tvoří tvar „trychtýře“ (u malých $X$ jsou u přímky, u velkých $X$ lítají všude možně).

### Cookova vzdálenost
- určuje vliv jednotlivých pozorování na odhady regresních koeficientů
- měří, jak moc by se změnily odhadované koeficienty modelu ($\beta$), kdybychom dané pozorování (jeden konkrétní bod) z dat úplně vymazali
- bod jako takový může být „odlehlý“ (outlier), ale nemusí mít nutně velký vliv na sklon přímky
- Cookova vzdálenost identifikuje body, které jsou oboje – jsou daleko od ostatních a zároveň drasticky mění výsledek regrese
- jeden jediný extrémní bod může „přitáhnout“ regresní přímku k sobě tak silně, že model pak špatně popisuje zbytek dat
- často odhalí překlep (např. místo 2 000 Kč na reklamu někdo napsal 20 000 Kč)
- interpretace:
  - $0$ až $0,5$: pozorování nemá na model zásadní vliv
  - $0,5$ až $1$: pozorování je „středně vlivné“, stojí za to se na něj podívat, ale obvykle to není katastrofa
  - nad $1$: pozorování má na model zásadní vliv a stojí za pozornost

### Multikolinearita
- VIF = Variance Inflation Factor
- metrika pro měření korelace mezi regresory
- v podstatě „detektor duplicitních regresorů v modelu
- korelační matice se pro multikolinearitu nehodí, protože ta porovnává dvojice
- jednoduše řečeno říká, jestli nějaké dva nebo více regresorů neříkájí víceméně to samé
- př. BMI není závislé pouze na 1 věci, ale na výšce a hmotnosti zároveň
- př. Regresory jsou vzdělání, praxe a věk. Chceme předpovědět plat. Problém je, že tyhle tři věci jsou spolu silně propojené. Starší lidé mají logicky většinou delší praxi. Když pak plat roste, regrese neví, jestli je to díky té praxi, nebo prostě tím, že je ten člověk starší.

$$VIF_{i} = \frac{1}{1 - R_{i}^2}$$

| Hodnota VIF   | Význam | Interpretace            |
|--------------------|--------------|-----------------|
| 1                  | Žádná korelace    | Proměnné spolu nesouvisí.          |
| (1, 5>             | Střední korelace  | Proměnné jsou trochu podobné, ale model je stále stabilní.           |
| >5                 | Vysoká korelace   | Proměnné jsou příliš podobné. Model je nespolehlivý. |


### Kroková regrese
- anglicky Stepwise regression
- cílem je najít nejjednodušší možný model, který ale stále dobře vysvětluje data
- nejčastěji se používá pro model mnohonásobné lineární regrese
- regresory jsou přidávány nebo odebírány na základě AIC a BIC
  - tj. Akaikeho informační kritérium a Bayesovské informační kritérium
  - čím menší hodnota těchto kritérií, tím lépe
- existují 3 druhy:
  - **backward**: začínáme s modelem bez regresorů a v každém kroku přidáme právě ten regresor, který nejvíce snižuje hodnotu AIC modelu, dokud další přidávání nevede k jejímu snížení
  - **forward**: začínáme s modelem se všemi regresory a v každém kroku odebíráme ten regresor, jehož odstranění nejvíce sníží AIC, dokud by další odebírání nevedlo k nárůstu AIC
  - **both sided**: kombinuje oba přístupy, kdy v každém kroku zvažuje přidání nového regresoru i odstranění stávajícího tak, aby výsledný model dosáhl nejnižší možné hodnoty AIC

```r
data(mtcars)

model_full <- lm(mpg ~ ., data = mtcars)
model_null <- lm(mpg ~ 1, data = mtcars)

step(model_null, scope = formula(model_full), direction = "forward")
step(model_full, direction = "backward")
step(model_full, direction = "both")
```

### Metoda maximální věrohodnosti
- MLE = Maximum Likelihood Estimation
- metoda pro odhad parametrů modelu (např. regresorů)
- v klasické lineární regresi dává MLE stejné výsledky jako metoda nejmenších čtverců, je zcela nezbytná u složitějších modelů, jako je logistická regrese, kde proměnné nemají normální rozdělení
- AIC je odvozena od této metody - penalizuje modely s nízkou věrohodností a vysokým počtem parametrů

### Regrese s kategorickou proměnnou
- kategorické proměnné jsou převedeny na tzv. dummy variables

```r
x <- c(1000, 2000, 3000, 4000, 5000)
y <- c(130, 150, 170, 210, 240)

# Dvě kapely jsou domácí (0), tři jsou zahraniční (1)
typ <- factor(c("domaci", "domaci", "zahranicni", "zahranicni", "zahranicni"))
data <- data.frame(x, y, typ)

# y = beta0 + beta1*x + beta2*typ
model_dummy <- lm(y ~ x + typ, data = data)
summary(model_dummy)

# Zkoumáme, jestli reklama funguje u zahraničních kapel jinak než u domácích
# y = beta0 + beta1*x + beta2*typ + beta3*(x * typ)
model_interakce <- lm(y ~ x * typ, data = data)
summary(model_interakce)

plot(
  data$x, data$y,
  pch = 19, col = as.numeric(data$typ),
  xlab = "Rozpočet na reklamu",
  ylab = "Počet prodaných alb",
  main = "Regrese s kategorickou proměnnou"
)

# Přímka pro domácí (černá)
abline(a = coef(model_interakce)[1], b = coef(model_interakce)[2], col = "black", lwd = 2)
# Přímka pro zahraniční (červená)
abline(a = coef(model_interakce)[1] + coef(model_interakce)[3], b = coef(model_interakce)[2] + coef(model_interakce)[4], col = "red", lwd = 2)

legend("topleft", legend = levels(data$typ), col = 1:2, pch = 19)
```

$$
y = \beta_0 + \beta_1 x + \beta_2 D + e
$$

#### Dummy variable
- proměnná, která nabývá pouze dvou hodnot: 0 nebo 1
- př. mějme 4 kategorické proměnné (např. jaro, léto, podzim, zima)
- hodnota 1 signalizuje přítomnost určité vlastnosti (např. "je žena", "je z Prahy"), zatímco hodnota 0 signalizuje její absenci
- jedna z proměnných je vždy zvolena jako referenční (v tomto případě Jaro, odpovídá Interceptu)
- modelu se testuje, jak se která kategorie liší od referenční

| Pořadí (Index) | (Intercept) | sezonaLeto | sezonaPodzim | sezonaZima |
| :--- | :---: | :---: | :---: | :---: |
| **1 (Jaro)** | 1 | 0 | 0 | 0 |
| **2 (Léto)** | 1 | 1 | 0 | 0 |
| **3 (Podzim)** | 1 | 0 | 1 | 0 |
| **4 (Zima)** | 1 | 0 | 0 | 1 |

```r
sezona <- factor(c("Jaro", "Jaro", "Leto", "Leto", "Podzim", "Podzim", "Zima", "Zima"))
prodeje <- c(100, 110, 150, 140, 120, 130, 80, 90)
data <- data.frame(prodeje, sezona)

model <- lm(prodeje ~ sezona, data = data)
summary(model)
model.matrix(model) # Tento příkaz vykreslí tabulku výše
```

Zápis modelu:
$$y = \beta_0 + \beta_1 D_{Leto} + \beta_2 D_{Podzim} + \beta_3 D_{Zima} + \epsilon$$

Pokud chceme spočítat třeba prodeje pro Zimu, dosadíme do rovnice takto:
$$D_{Leto} = 0$$
$$D_{Podzim} = 0$$
$$D_{Zima} = 1$$
Rovnice se ti zjednoduší na $y = \beta_0 + \beta_3$

### Logistická regrese
- např. pacient přežil/nepřežil, student udělal/neudělal zkoušku
- zatímco v lineární regresi předpovídáme číslo (např. kolik alb se prodá), v logistické regresi předpovídáme pravděpodobnost, že nastane určitý jev (např. zda student udělá zkoušku)
- místo toho, aby model hledal přímku, která prochází co nejlépe body, hledá nejlepší "dělící čáru", resp. snaží se najít bod (hranici), který nejlépe binárně odděluje skupinu
- vysvětlovaná proměnná ($y$) je binární, tedy nabývá pouze dvou hodnot: 1 (jev nastal) nebo 0 (jev nenastal)
- výsledkem modelu není přímo 0 nebo 1, ale pravděpodobnost $P$, která se pohybuje v rozmezí 0 až 1 (neboli 0 % až 100 %)
- využívá sigmoidu

```r
# Hodiny učení a výsledek (0 = neuspěl, 1 = uspěl)
data_test <- data.frame(
  hodiny = c(2, 5, 8, 10, 12, 15, 18, 20, 25, 30),
  uspech = c(0, 0, 0, 0, 1, 0, 1, 1, 1, 1)
)
model <- glm(uspech ~ hodiny, data = data_test, family = "binomial")
bod_zlomu <- -coef(model)[1] / coef(model)[2]

plot(uspech ~ hodiny, data = data_test, pch = 16, xlab = "Hodin učení", ylab = "Pravděpodobnost úspěchu", main = "Logistická regrese")
grid(col = "lightgray", lty = "dotted")
abline(h = 0.5, col = "red", lty = 2)
abline(v = bod_zlomu, col = "darkgreen", lty = 2)
# Přidání sigmoidy (S-křivky)
curve(predict(model, data.frame(hodiny = x), type = "response"), add = TRUE, col = "blue", lwd = 2)

# # Kolik % šance mám, když se učím 13 hodin?
predict(model, newdata = data.frame(hodiny = 13), type = "response")

vysledky <- function(m, d) {
  d$Sance <- round(predict(m, type = "response"), 3)
  d$Predpoved <- ifelse(d$Sance > 0.5, 1, 0)
  return(d)
}

vysledky(model, data_test)
```

#### Sigmoida
- transformuje libovolné číslo do intervalu (0, 1)
- nelinerální funkce
- sigma(z) = 1 / (1 + e^z), kde z je reálné číslo
- nabývá tedy hodnot od (0, 1)
  - limitně se přibližuje k 0, když jde do mínus nekonečna
  - limitně se přibližuje k 1, když jde do nekonečna
  - v bode 0 (z = 0) nabývá hodnoty 0.5
  - hodnota sigmoidy je interpretovatelná jako pravděpodobnost (např. 0.76 = 76 %)

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Logistic-curve.svg/1280px-Logistic-curve.svg.png" width="400" style="background-color:white;">

#### Poměr šancí
- anglicky: Odds Ratio

$$
\log\!\left(\frac{p}{1 - p}\right) = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p
$$

### Ordinální regrese
- kategorie mají jasné pořadí (např. známky ve škole 1-5 nebo spokojenost "malá-střední-velká")
- logické rozšíření logistické regrese pro situace, kdy výsledky nejsou jen „ano/ne“, ale mají více úrovní, které lze seřadit (např. spokojenost: špatná < průměrná < skvělá)
- model nevytvoří 1 sigmoidu, ale sérii rovnoběžných sigmoid

$$
\log\!\left(\frac{P(y \le k)}{P(y > k)}\right) = \theta_k - \beta_1 x_1 - \beta_2 x_2 - \cdots - \beta_p x_p
$$

```r
library(MASS)
set.seed(1)

# Počet hodin, kolik student studoval a známku, kterou dostal
# C < B < A
data_skola <- data.frame(
  hodiny = c(2, 5, 8, 10, 11, 12, 15, 18, 20, 22, 25, 30),
  znamka = factor(c("C", "C", "B", "C", "B", "B", "B", "A", "B", "A", "A", "A"), levels = c("C", "B", "A"), ordered = TRUE)
)

# Ordinální regrese
m <- polr(znamka ~ hodiny, data = data_skola, Hess = TRUE)

ctable <- coef(summary(m))
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
(ctable <- cbind(ctable, "p value" = round(p, 4)))
#             Value Std. Error  t value p value
# hodiny  0.6018547  0.2966476 2.028854  0.0425
# C|B     5.0492378  2.9428805 1.715747  0.0862
# B|A    11.3597420  5.7131212 1.988360  0.0468

# Koeficient (0.6019): Je kladný, což znamená, že s každou další hodinou učení se zvyšuje šance na lepší známku.
# P-hodnota (0.0425): Je menší než 0.05, takže vliv učení je statisticky významný.

# Tady také model říká, jak těžké je "přeskočit" z jedné kategorie do druhé:
# - Práh C|B (5.049): Bod, kde se láme šance mezi C a lepšími známkami.
# - Práh B|A (11.360): Bod, kde se láme šance na čisté A.
# Závěr je tedy takový, že rozdíl mezi těmito čísly je velký (skoro 6 bodů na logitové stupnici).
# To znamená, že dostat se z B na A vyžaduje mnohem intenzivnější studium než se jen "odlepit" od Cčka.

# 4. Predikce pro studenta, který studoval 16 hodinam
predict(m, newdata = data.frame(hodiny = 16), type = "probs")
#          C          B          A
# 0.01014641 0.83927457 0.15057902
# Šance na C: 1,0 % (skoro nemožné, aby to takhle zkazil).
# Šance na B: 83,9 % (téměř jistota, že dostane béčko).
# Šance na A: 15,1 % (existuje naděje, ale model ho vidí spíše jako typického B studenta).
```

### Poissonova regrese
- předpovídá počet výskytů určitého jevu za pevně danou jednotku (čas, plocha, objem)
- např. kolikrát za rok někdo onemocní
- vysvětlovanou proměnnou musí být celá nezáporná čísla
- předpokládem je, že průměr je roven rozptylu
- **y** je očekávaný počet výskytů (po odlogaritmování)
- využití k odpovědi na otázky typu:
  - Kolik aut projede křižovatkou za hodinu?
  - Kolik vzácných rostlin najdeme na $1\text{ m}^2$ louky?
  - Kolik stížností přijde firmě za jeden pracovní den?

$$
\log(y) = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \cdots + \beta_p x_p
$$

```r
# Počet absencí studenta podle jeho průměru známek
data_absence <- data.frame(
  absence = c(0, 1, 2, 2, 3, 5, 8, 10),
  znamka = c(1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0)
)

# Poissonova regrese
mod_pois <- glm(absence ~ znamka, data = data_absence, family = "poisson")
exp(coef(mod_pois))

plot(absence ~ znamka, data = data_absence, pch = 16, col = "darkblue", main = "Poissonova regrese: Absence vs. Známka", xlab = "Průměr známek", ylab = "Počet absencí")
# Exponenciální křivka
curve(predict(mod_pois, data.frame(znamka = x), type = "response"), add = TRUE, col = "red", lwd = 2)
```

### Polynomická regrese
- body v grafu netvoří přímku, ale třeba "údolí" nebo "kopec"
- vztah je popsaný polynomem vyššího řádu (např. kvadratická funkce)
- nejde o nový druh regrese, ale o lineární regresi, do které jsou jen přidány nové proměnné vzniklé umocněním těch původních ($x^2, x^3$ atd.).

$$
y = \beta_0 + \beta_1 x + \beta_2 x^2 + \cdots + \beta_k x^k + e
$$

```r
# Stres (0-100) a Výkon (0-100)
# Příliš málo stresu vede k nudě a nízkému výkonu, příliš mnoho stresu k vyhoření. Nejlepší výkon je někde uprostřed.
# Data tedy tvoří obrácené U (kopec).
data_vykon <- data.frame(
  stres = c(10, 20, 30, 40, 50, 60, 70, 80, 90, 100),
  vykon = c(20, 45, 65, 85, 95, 90, 75, 50, 30, 10)
)

# Polynomická regrese (2. řádu, tedy kvadratická)
mod_poly <- lm(vykon ~ poly(stres, degree = 2, raw = TRUE), data = data_vykon)

plot(vykon ~ stres, data = data_vykon, pch = 16, main = "Polynomická regrese (Kvadratická)")
curve(predict(mod_poly, data.frame(stres = x)), add = TRUE, col = "red", lwd = 2)
```