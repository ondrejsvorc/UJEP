library(DescTools)
library(asbio)
library(fitdistrplus)

data(mtcars)            # Načtení dat
?mtcars                 # Nápověda k datům
head(mtcars, n=10)      # Zobrazení prvních 10 řádků dat
View(mtcars)            # Zobrazení tabulky dat
summary(mtcars)         # Shrnutí informací o datech
str(mtcars)             # Použité datové typy pro data

# Průměr
mean(mtcars$mpg)
# Medián
median(mtcars$mpg)
# Modus
Mode(mtcars$mpg)
# Směrodatná odchylka
sd(mtcars$mpg)
# Mezikvartilové rozpětí
IQR(mtcars$mpg)
# Medián absolutních odchylek
mad(mtcars$mpg)
# Kvartily
quantile(mtcars$mpg, probs=c(0.25, 0.75))

# Šikmost
Skew(mtcars$mpg)
# Špičatost
Kurt(mtcars$mpg)

# Test normality dat (Shapiro-Wilk test)
shapiro.test(mtcars$mpg)
# T-test hypotézy o průměru (jednovýběrový t-test) - Test hypotézy, že průměrná hodnota mpg je rovna 20
t.test(mtcars$mpg, mu=20)

# Absolutní četnosti, relativní četnosti
# Kumulativní absolutní četnosti, kumulativní relativní četnosti
data.frame(cbind(
  "Absolutni" = table(mtcars$cyl),
  "Relativni" = prop.table(table(mtcars$cyl)),
  "Kumulativni" = cumsum(table(mtcars$cyl)),
  "KumulativniRelativni" = cumsum(prop.table(table(mtcars$cyl)))
))

# Sloupcový graf
barplot(table(mtcars$cyl),
        col=2:5,
        main='Počet aut podle počtu válců',
        xlab='Počet válců',
        ylab='Počet aut',
        border='black')
# Koláčový graf
pie(table(mtcars$cyl),
    col=2:5,
    main='Podíl aut podle počtu válců',
    labels=paste(names(table(mtcars$cyl)), 'válců:', table(mtcars$cyl)))

# Histogram
hist(mtcars$mpg,
     main='Histogram rozdělení mpg (míle na galon)',
     xlab='Spotřeba (mpg)',
     ylab='Frekvence',
     col='lightblue',
     border='black')

# Boxplot
boxplot(mtcars$mpg,
        main='Boxplot rozdělení mpg (míle na galon)',
        xlab='Automobily',
        ylab='Spotřeba (mpg)',
        col='lightgreen',
        border='black')

# Scatter plot mpg vs hp
plot(mtcars$hp, mtcars$mpg, main='Scatter plot mpg vs hp', 
     xlab='Horsepower (hp)', ylab='Miles per gallon (mpg)', pch=20, col='blue')
# Přidání regresní přímky
abline(lm(mpg ~ hp, data=mtcars), col='red', lwd=2)
# Přidání LOESS křivky
lines(lowess(mtcars$hp, mtcars$mpg), col='green', lwd=2)
# Legenda
legend('topright', legend=c('Data', 'Lineární regrese', 'LOESS'), 
       col=c('blue', 'red', 'green'), pch=c(20, NA, NA), lty=c(NA, 1, 1), lwd=c(NA, 2, 2))

# Korelační heatmapa
heatmap(cor(mtcars),
        main = "Heatmap korelační matice",
        xlab = "Proměnné",
        ylab = "Proměnné",
        col = heat.colors(10),
        scale = "none",
        margins = c(8, 8))


# Grafické posouzení rozdělení
# Čím vyšší boot, tím přesnější výsledek
descdist(mtcars$mpg, discrete=FALSE, boot=500)
# Odhad parametrů normálního rozdělení
fit.norm <- fitdist(mtcars$mpg, "norm")
summary(fit.norm)
# Q-Q graf pro normální rozdělení
qqnorm(mtcars$mpg)
qqline(mtcars$mpg, col='red')

# Párový graf (Matice bodových grafů)
pairs(mtcars,
      main = "Párový graf proměnných",
      pch = 21,
      bg = "lightblue")

# Párový graf (Matice bodových grafů)
# Proměnná na diagonále, která je na stejném řádku jako bodový graf, který zkoumáme, je jeho y-nová osa.
# Proměnná na diagonále, která je ve stejném sloupci, jako bodový graf, který zkoumáme, je jeho x-ová osa.
# Příkladem může být 4. graf v prvním řádku.
# Osa y je rating a osa x je learning.
# Když se učí málo, tak bude mít i malý rating (ne vždy).
# Když se ale učí hodně, tak má skoro s jitotou větší rating. 
data(attitude)
pairs(attitude,
      pch = 19,
      col = "skyblue",
      main = "Matice bodových grafů (Scatterplot Matrix) - attitude dataset")

# Bootstrap interval pro průměr výkonu motoru
# Získáme interval, ve kterém leží skutečný průměr výkonu motoru s 99% spolehlivostí.
BootCI(mtcars$hp, FUN = mean, conf.level = 0.99)

# Interval spolehlivosti pro rozdíl průměrů
# Interval pro rozdíl průměrů mpg mezi 4 a 8 válci
MeanDiffCI(
  x = mtcars$mpg[mtcars$cyl == 4],
  y = mtcars$mpg[mtcars$cyl == 8],
  conf.level = 0.95
)

# Interval spolehlivosti pro binomické rozdělení
# Interval spolehlivosti pro podíl manuálních převodovek
BinomCI(sum(mtcars$am == 1), length(mtcars$am), conf.level = 0.95)

# Interval spolehlivosti pro rozdíl podílů
# Interval spolehlivosti pro rozdíl podílů manuálních převodovek
BinomDiffCI(
  x1 = sum(mtcars$am[mtcars$cyl == 4] == 1),
  n1 = sum(mtcars$cyl == 4),
  x2 = sum(mtcars$am[mtcars$cyl == 8] == 1),
  n2 = sum(mtcars$cyl == 8),
  conf.level = 0.95
)

# Normální rozdělení
(fit1 <- fitdist(mtcars$hp, "norm"))
# Logistické rozdělení
(fit2 <- fitdist(mtcars$hp, "logis"))
# Lognormální rozdělení
(fit3 <- fitdist(mtcars$hp, "lnorm"))
# Exponenciální rozdělení
(fit4 <- fitdist(mtcars$hp, "exp"))
# Gamma rozdělení
(fit5 <- fitdist(mtcars$hp, "gamma"))
# Weibullovo rozdělení
(fit6 <- fitdist(mtcars$hp, "weibull"))
# Cauchyho rozdělení
(fit7 <- fitdist(mtcars$hp, "cauchy"))

# Tabulka s kritérii AIC a BIC
comparison <- data.frame(
  distr = c("Norm", "Logis", "Lognorm", "Exp", "Gamma", "Weibull", "Cauchy"),
  AIC = c(fit1$aic, fit2$aic, fit3$aic, fit4$aic, fit5$aic, fit6$aic, fit7$aic),
  BIC = c(fit1$bic, fit2$bic, fit3$bic, fit4$bic, fit5$bic, fit6$bic, fit7$bic)
)
# Seřazení podle AIC, a pak podle BIC
comparison <- comparison[order(comparison$AIC, comparison$BIC), ]
print(comparison)

# Symetrické rozdělení
set.seed(5)
x = rnorm(1000, 0, 1)
hist(x, main="Normální rozdělení: Symetrické (medián = průměr)", freq=FALSE, 
     xlab="Hodnoty", ylab="Hustota", col="lightgray", border="white")
lines(density(x), col='red', lwd=3)
abline(v = c(mean(x), median(x)), col=c("green", "blue"), lty=c(2,2), lwd=c(3, 3))
legend("topright",
       legend=c("Hustota", "Průměr", "Medián"),
       col=c("red", "green", "blue"),
       lty=c(1, 2, 2),
       lwd=c(3, 3, 3),
       bg="white",
       box.lty=1)

# Pravostranně zešikmené
set.seed(5)
x = rexp(1000, 1)
hist(x, main="Exponenciální rozdělení: Pravostranně zešikmené (medián < průměr)", freq=FALSE,
     xlab="Hodnoty", ylab="Hustota", col="lightyellow", border="white")
lines(density(x), col='red', lwd=3)
abline(v = c(mean(x), median(x)), col=c("green", "blue"), lty=c(2,2), lwd=c(3, 3))
legend("topright",
       legend=c("Hustota", "Průměr", "Medián"),
       col=c("red", "green", "blue"),
       lty=c(1, 2, 2),
       lwd=c(3, 3, 3),
       bg="white",
       box.lty=1)


# Levostranně zešikmené
set.seed(5)
x = rbeta(10000, 5, 2)
hist(x, main="Beta rozdělení: Levostranně zešikmené (medián > průměr)", freq=FALSE,
     xlab="Hodnoty", ylab="Hustota", col="lightblue", border="white")
lines(density(x), col='red', lwd=3)
abline(v = c(mean(x), median(x)), col=c("green", "blue"), lty=c(2,2), lwd=c(3, 3))
legend("topright",
       legend=c("Hustota", "Průměr", "Medián"),
       col=c("red", "green", "blue"),
       lty=c(1, 2, 2),
       lwd=c(3, 3, 3),
       bg="white",
       box.lty=1)

# Nízká špičatost
set.seed(42)
x <- runif(1000, min = -1, max = 1)
hist(x, main = "Platykurtické rozdělení (Plochý vrchol)", freq = FALSE,
     xlab = "Hodnoty", ylab = "Hustota", col = "lightcyan", border = "white")
lines(density(x), col = 'red', lwd = 3)
abline(v = c(mean(x), median(x)), col = c("green", "blue"), lty = c(2,2), lwd = c(3, 3))
legend("topright",
       legend = c("Hustota", "Průměr", "Medián"),
       col = c("red", "green", "blue"),
       lty = c(1, 2, 2),
       lwd = c(3, 3, 3),
       bg = "white",
       box.lty = 1)

# Normální špičatost
set.seed(42)
x <- rnorm(1000, mean = 0, sd = 1)
hist(x, main = "Mesokurtické rozdělení (Normální špičatost)", freq = FALSE,
     xlab = "Hodnoty", ylab = "Hustota", col = "lightgray", border = "white")
lines(density(x), col = 'red', lwd = 3)
abline(v = c(mean(x), median(x)), col = c("green", "blue"), lty = c(2,2), lwd = c(3, 3))
legend("topright",
       legend = c("Hustota", "Průměr", "Medián"),
       col = c("red", "green", "blue"),
       lty = c(1, 2, 2),
       lwd = c(3, 3, 3),
       bg = "white",
       box.lty = 1)

# Vysoká špičatost
set.seed(42)
x <- rt(1000, df = 2)
hist(x, main = "Leptokurtické rozdělení (Špičatý vrchol)", freq = FALSE,
     xlab = "Hodnoty", ylab = "Hustota", col = "lightpink", border = "white")
lines(density(x), col = 'red', lwd = 3)
abline(v = c(mean(x), median(x)), col = c("green", "blue"), lty = c(2,2), lwd = c(3, 3))
legend("topright",
       legend = c("Hustota", "Průměr", "Medián"),
       col = c("red", "green", "blue"),
       lty = c(1, 2, 2),
       lwd = c(3, 3, 3),
       bg = "white",
       box.lty = 1)