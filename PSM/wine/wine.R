wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE,
                   col.names=c('Cultivar', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash',
                               'Magnesium', 'Total.phenols','Flavanoids', 'Nonflavanoid.phenols',
                               'Proanthocyanin', 'Color.intensity', 'Hue', 'OD280.OD315.of.diluted.wines',
                               'Proline'))

# Alcohol = alkohol
# Malic.acid = kyselina jablečná
# Ash = popel
# Alcalinity.of.ash = alkalita popela
# Magnesium = hořčík
# Total.phenols = celkové fenoly
# Flavanoids = flavanoidy
# Nonflavanoid.phenols = neflavanoidní fenoly
# Proanthocyanin = proanthokyany
# Color.intensity = intenzita barvy
# Hue = odstín barvy
# OD280.OD315.of.diluted.wines = OD280/OD315 zředěných vín
# Proline = prolin

# 3 odrůdy, tedy kategorická proměnná
wine$Cultivar <- factor(wine$Cultivar)
str(wine)
summary(wine)
table(wine$Cultivar)



# 1. Je významný rozdíl mezi jednotlivými odrůdami v jejich chemickém složení? Ve které charakteristice se odrůdy nejvíce odlišují?

# Nejprve jsem oddělil chemické proměnné od informace o odrůdě.
X <- wine[, setdiff(names(wine), "Cultivar")]

# Potom jsem pomocí MANOVA ověřil, zda se odrůdy jako celek liší v chemickém složení.
# H0 (MANOVA): Chemické složení vína je u všech odrůd stejné.
# H1 (MANOVA): Chemické složení vína se mezi odrůdami liší.
# Zamítám H0, odrůdy se významně liší v chemickém složení.
manova_model <- manova(as.matrix(X) ~ Cultivar, data = wine)
summary(manova_model, test = "Wilks")

# Následně jsem pro každou chemickou vlastnost zvlášť provedl ANOVA a podle nejnižších p-hodnot určil, ve kterých vlastnostech se odrůdy liší nejvíce.
# H0 (ANOVA): Průměrná hodnota dané chemické vlastnosti je stejná pro všechny odrůdy.
# H1 (ANOVA): Průměrná hodnota dané chemické vlastnosti se mezi odrůdami liší.
# Zamítám H0 u většiny chemických vlastností, přičemž největší rozdíly mezi odrůdami vidím
# u proměnných Flavanoids, Proline a OD280/OD315.

anova_pvalues <- sapply(colnames(X), function(var) {
  fit <- aov(wine[[var]] ~ Cultivar, data = wine)
  summary(fit)[[1]]["Cultivar", "Pr(>F)"]
})
anova_pvalues <- sort(anova_pvalues)
anova_pvalues

# ODPOVĚĎ: Ano, existuje významný rozdíl mezi jednotlivými odrůdami a nejvíce odlišují v proměnných Flavanoids, Proline a OD280/OD315.



# 2. Pokuste se data zjednodušit, tj. najít několik málo nových proměnných, které když použiji namísto těch stávajících, tak ztratím co nejméně informace. Kolik takových proměnných potřebuji? A je možné je nějak interpretovat? Najděte rozumný počet nových proměnných, které nějakou interpretaci mít budou. Jejich počet se může lišit od doporučeného čísla. Kolik procent informace tyto proměnné obsahují?

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

pca <- prcomp(X, scale. = TRUE)
plot(pca, type = "l")
interpret_pca(pca, target_variance = 0.8)
interpret_pca_loadings(pca, components = 5, top_n = 5)

X_reduced <- pca$x[, 1:3]
X_reduced

# ODPOVĚDI NA OTÁZKY:

# Pokuste se data zjednodušit.
# - Data jsem zjednodušil pomocí PCA nahrazením 13 původních proměnných 3 hlavními komponentami.

# Kolik takových proměnných potřebuji?
# - Rozumný počet jsou 3 hlavní komponenty.

# Je možné je nějak interpretovat?
# - Ano, komponenty jsou interpretovatelné jako souhrnné chemické profily vína.

# Najděte rozumný počet nových proměnných.
# - Zvolil jsem 3 komponenty na základě scree plotu a interpretovatelnosti.

# Kolik procent informace tyto proměnné obsahují?
# - První tři komponenty vysvětlují přibližně 66 % variability dat.



# 3. Je možné na základě chemické analýzy vzorku vína poznat, ke které odrůdě víno patří? Určete vhodnou funkci / funkce, které Vám neznámý vzorek pomohou přiřadit ke správné skupině. Jak je taková rozhodovací funkce dobrá? A kolik takovýchto funkcí potřebujete?

library(MASS)

lda_model <- lda(wine$Cultivar ~ ., data = as.data.frame(X_reduced))
lda_pred <- predict(lda_model)

cat("Matice záměn:\n")
print(table(Predicted = lda_pred$class, True = wine$Cultivar))

cat("\nÚspěšnost klasifikace:\n")
cat(sprintf("%.2f %%\n", 100 * mean(lda_pred$class == wine$Cultivar)))

cat("\nPodíl diskriminační informace (LD1, LD2):\n")
print(lda_model$svd^2 / sum(lda_model$svd^2))

plot(lda_pred$x[, 1], lda_pred$x[, 2], col = wine$Cultivar, pch = 19, xlab = "LD1", ylab = "LD2")
legend("topright", legend = levels(wine$Cultivar), col = 1:length(levels(wine$Cultivar)), pch = 19)

# ODPOVĚDI NA OTÁZKY:

# Je možné na základě chemické analýzy určit, ke které odrůdě víno patří?
# - Ano, pomocí lineární diskriminační analýzy (LDA).

# Jaké rozhodovací funkce byly použity?
# - Dvě lineární diskriminační funkce (LD1 a LD2).

# Kolik takových funkcí je potřeba?
# - Pro 3 odrůdy jsou potřeba 2 diskriminační funkce.

# Jak dobrá je tato rozhodovací funkce?
# - Úspěšnost klasifikace je přibližně 97 %, což ukazuje velmi dobré rozlišení odrůd.

# Jaký je význam jednotlivých funkcí?
# - První diskriminační funkce (LD1) nese většinu rozlišovací informace, druhá funkce (LD2) slouží k jemnému doladění rozlišení mezi odrůdami.



# 4. V tomto případě pracujte bez znalosti odrůdy a jen na základě číselných proměnných rozdělte data do skupin. Porovnejte více variant dělení do skupin (různé metody, různé počty skupin, ...) a jedno dělení vyberte jako optimální. Kolik skupin máte? A jak byste tyto skupiny charakterizovali?

X <- wine[, setdiff(names(wine), "Cultivar")]
X_scaled <- scale(X)

dist_mat <- dist(X_scaled)
hc_ward <- hclust(dist_mat, method = "ward.D2")
plot(hc_ward, labels = FALSE, main = "Hierarchické shlukování – Ward")

cluster_2 <- cutree(hc_ward, k = 2)
cluster_3 <- cutree(hc_ward, k = 3)
cluster_4 <- cutree(hc_ward, k = 4)

table(cluster_3, wine$Cultivar)

clusters <- cutree(hc_ward, k = 3)
aggregate(X, by = list(Cluster = clusters), mean)

# ODPOVĚDI NA OTÁZKY:

# Jaké metody byly vyzkoušeny?
# - Hierarchické shlukování metodou Ward s různým počtem shluků (k = 2, 3, 4).

# Kolik skupin bylo zvoleno jako optimální?
# - 3 shluky.

# Jak lze jednotlivé skupiny charakterizovat?
# - Skupiny se liší zejména obsahem fenolů (Total.phenols), alkoholu (Alcohol),
# intenzitou barvy (Color.intensity) a minerálním složením vína (Ash, Alcalinity.of.ash, Magnesium).