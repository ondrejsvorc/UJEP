### PCA ###




# 0. Data
data(mtcars)

# Vybereme jen numerické proměnné vhodné pro PCA
X <- mtcars[, c("mpg", "disp", "hp", "drat", "wt", "qsec", "gear", "carb")]

# 1. PCA (standardizace je nutná kvůli různým měřítkům)
pca <- prcomp(X, scale. = TRUE)

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

interpret_pca(pca, 0.8)
interpret_pca_loadings(pca)


# 2. Kolik komponent zachovat
# Scree plot + Kaiserovo kritérium
plot(pca, type = "l", main = "Scree plot – mtcars")
abline(h = 1, col = "red", lty = 2)

# Výpis vysvětlené variability
summary(pca)

# 3. Zatížení (váhy proměnných)
pca$rotation

# 4. Skóre – nové proměnné (souřadnice aut v prostoru komponent)
scores <- pca$x[, 1:2]
head(scores)

# 5. Biplot (pozorování + proměnné)
biplot(pca, scale = 0)






### Jednoduchá lineární regrese ###

# Ukázková data
# Vynaložené peníze na reklamu (Kč)
# Počet prodaných alb při vynaložených penězích na reklamu
set.seed(1)

reklama <- c(1000, 2000, 3000, 4000, 5000)
alba <- c(130, 150, 170, 210, 240)
data <- data.frame(reklama, alba)

# Lineární regrese
model <- lm(alba ~ reklama, data = data)

# Shrnutí modelu

# y = 96 + 0.028*reklama
# kde 96 je odhad prodeje alb při nulové reklamě (Intercept)
# a 0.028 říká, že když reklama = 1, tak prodej alb se v průměru zvýší o 0.028 kusu
# prakticky: vynaložení 1000 Kč na reklamu (0.028*1000) bude znamenat nárust prodeje o 28 alb
# tedy 96 alb by se prodalo bez reklamy a 96+28=124 alb by se prodalo s reklamou za 1000 Kč.

# p-hodnoty (Pr(>|t|))
# H0: Reklama nemá vliv na prodej alb.
# H1: Reklama má vliv na prodej alb.
# p-hodnota < 0.05 -> zamítáme H0
# Reklama má statisticky významný vliv na prodej.

# Multiple R-squared: 0.98
# = koeficient determinace
# Model vysvětluje 98 % variability prodeje alb (vysvětlované proměnné).

# Residual standard error: 7.303 on 3 degrees of freedom
# typická chyba predikce ≈ 7 alb
# říká, jak moc se body odchylují od přímky
# degrees of freedom = stupně volnosti --> počet pozorování mínus počet odhadovaných parametrů
# takže když máme 5 pozorování (n=5) a 2 parametry, tak je to n-2=3

# F-statistic: 147, p-value = 0.001208
# H0: Model jako celek nemá vysvětlující schopnost.
# H1: Model jako celek má vysvětlující schopnost.
# p-hodnota < 0.05 -> zamítáme H0
# Model jako celek má vysvětlující schopnost.

summary(model) # celé shrnutí modelu
coef(model) # koeficienty modelu (hodí se pro matematický zápis)

# Vykreslení dat
plot(
  data$reklama,
  data$alba,
  pch = 19,
  xlab = "Rozpočet na reklamu",
  ylab = "Počet prodaných alb",
  main = "Lineární regrese: reklama vs. prodej"
)
# Přidání regresní přímky
abline(model, col = "red", lwd = 2)

# Predikce
predict(model, newdata = data.frame(reklama = 6000))











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













sezona <- factor(c("Jaro", "Jaro", "Leto", "Leto", "Podzim", "Podzim", "Zima", "Zima"))
prodeje <- c(100, 110, 150, 140, 120, 130, 80, 90)
data <- data.frame(prodeje, sezona)

model <- lm(prodeje ~ sezona, data = data)
summary(model)

model.matrix(model)








# Data: hodiny učení a výsledek (1 = udělal, 0 = neudělal)
hodiny <- c(2, 5, 8, 10, 15, 20, 25, 30)
uspech <- c(0, 0, 0, 1, 0, 1, 1, 1)
data_skola <- data.frame(hodiny, uspech)

# Vytvoření logistického modelu (používáme glm a family = binomial)
model_log <- glm(uspech ~ hodiny, data = data_skola, family = binomial)

# Předpověď pro někoho, kdo se učil 12 hodin
predict(model_log, newdata = data.frame(hodiny = 12), type = "response")








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