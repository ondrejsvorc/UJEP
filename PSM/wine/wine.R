wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE,
                   col.names=c('Cultivar', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash',
                               'Magnesium', 'Total.phenols','Flavanoids', 'Nonflavanoid.phenols',
                               'Proanthocyanin', 'Color.intensity', 'Hue', 'OD280.OD315.of.diluted.wines',
                               'Proline'))

# 3 odrudy, tedy kategorická proměnná
wine$Cultivar <- factor(wine$Cultivar)
str(wine)
summary(wine)
table(wine$Cultivar)

# 1. Je významný rozdíl mezi jednotlivými odrůdami v jejich chemickém složení? Ve které charakteristice se odrůdy nejvíce odlišují?

X <- wine[, setdiff(names(wine), "Cultivar")]
manova_model <- manova(as.matrix(X) ~ Cultivar, data = wine)
summary(manova_model, test = "Wilks")

anova_pvalues <- sapply(colnames(X), function(var) {
  fit <- aov(wine[[var]] ~ Cultivar, data = wine)
  summary(fit)[[1]]["Cultivar", "Pr(>F)"]
})
anova_pvalues <- sort(anova_pvalues)
anova_pvalues

# 2. Pokuste se data zjednodušit, tj. najít několik málo nových proměnných, které když použiji namísto těch stávajících, tak ztratím co nejméně informace. Kolik takových proměnných potřebuji? A je možné je nějak interpretovat? Najděte rozumný počet nových proměnných, které nějakou interpretaci mít budou. Jejich počet se může lišit od doporučeného čísla. Kolik procent informace tyto proměnné obsahují?

pca <- prcomp(X, scale. = TRUE)
summary(pca)
plot(pca, type = "l")

# 3. Je možné na základě chemické analýzy vzorku vína poznat, ke které odrůdě víno patří? Určete vhodnou funkci / funkce, které Vám neznámý vzorek pomohou přiřadit ke správné skupině. Jak je taková rozhodovací funkce dobrá? A kolik takovýchto funkcí potřebujete?

library(MASS)

X <- wine[, setdiff(names(wine), "Cultivar")]

lda_model <- lda(Cultivar ~ ., data = wine)
lda_pred <- predict(lda_model)

predicted_class <- lda_pred$class
table(predicted_class, wine$Cultivar)
mean(predicted_class == wine$Cultivar)

lda_model$svd^2 / sum(lda_model$svd^2)
plot(lda_pred$x[,1], lda_pred$x[,2], col = wine$Cultivar, pch = 19, xlab = "LD1", ylab = "LD2")
legend("topright", legend = levels(wine$Cultivar), col = 1:length(levels(wine$Cultivar)), pch = 19)

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