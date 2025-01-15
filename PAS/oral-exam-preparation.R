# Okruh 1

# Číselná proměnná
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

# Kategorická proměnná
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

# Okruh 2
library(DescTools)

data(mtcars)
selected_var <- mtcars$mpg

mean(selected_var)
MeanCI(selected_var, conf.level = 0.95)

t.test(selected_var)

mean_value <- mean(selected_var)    # Mean (x̄)
std_dev <- sd(selected_var)         # Standard deviation (s)
n <- length(selected_var)           # Sample size (n)

# Confidence level and corresponding z-value
conf_level <- 0.95                  # 95% confidence level
alpha <- 1 - conf_level             # Significance level
z_value <- qnorm(1 - alpha / 2)     # z-value for two-tailed test

# Standard error (SE)
se <- std_dev / sqrt(n)

# Lower and upper limits of the confidence interval
lower_limit <- mean_value - z_value * se
upper_limit <- mean_value + z_value * se

# Display results
cat("Mean:", mean_value, "\n")
cat("Standard Error:", se, "\n")
cat("Z-value:", z_value, "\n")
cat("95% Confidence Interval: [", lower_limit, ",", upper_limit, "]\n")

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

t.test(group_5_hp, group_4_hp, var.equal = FALSE)

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
# S 95% spolehlivostí se skutečný rozdíl pohybuje mezi –14,7 % a 57,5 %.
BinomDiffCI(x1 = sum(group_4$am == 0), n1 = nrow(group_4), x2 = sum(group_5$am == 0), n2 = nrow(group_5), conf.level = 0.95)

## Testování hypotéz
## Ještě se tomu pověnovat

# Hodnocení vzájemné souvislosti
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

# Identifikace vhodného podkladového rozdělení dat
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

# Lineární regrese (rovnice regresní přímky)
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

# Identifikace odlehlých hodnot
data(mtcars)
hp_data <- mtcars$hp

boxplot(hp_data,
        main = "Boxplot pro proměnnou hp (výkon motoru)",
        ylab = "Výkon (hp)",
        col = "lightblue")

Q1 <- quantile(hp_data, 0.25)
Q3 <- quantile(hp_data, 0.75)
IQR_value <- IQR(hp_data)

lower_bound <- Q1 - 1.5 * IQR_value
upper_bound <- Q3 + 1.5 * IQR_value

outliers <- hp_data[hp_data < lower_bound | hp_data > upper_bound]
print(outliers) # 335

odlehla_pozorovani <- Outlier(hp_data, method = "boxplot", na.rm = TRUE)
print(odlehla_pozorovani) # 335