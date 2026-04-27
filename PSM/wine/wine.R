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

X_scaled <- scale(X)
fa <- factanal(X_scaled, factors = 3, rotation = "varimax", scores = "Bartlett")
print(fa$loadings, cutoff = 0.4)

# ===================== FAKTOROVÁ ANALÝZA =====================

# ---------------------------------------------------------------------------
# FAKTOR 1 – „Fenolické látky (chuť, struktura, kvalita)“
#
# Proměnná                         Váha     Význam
# ---------------------------------------------------------------------------
# Flavanoids                       0.928    hlavní fenoly (chuť, hořkost)
# OD280/OD315                      0.864    kvalita a koncentrace fenolů
# Total.phenols                    0.824    celkové množství fenolů
# Hue                              0.654    odstín barvy (souvisí s fenoly)
# Proanthocyanin                   0.622    třísloviny (svíravost)
# Nonflavanoid.phenols            -0.533    jiný typ fenolů (opačný efekt)
#
# Laická interpretace:
# -> Tento faktor říká, jak moc je víno „chemicky bohaté“ na látky,
#    které ovlivňují chuť, hořkost a kvalitu.
# -> Vysoká hodnota = plnější chuť, více tříslovin, „kvalitnější struktura“
# ---------------------------------------------------------------------------


# ---------------------------------------------------------------------------
# FAKTOR 2 – „Síla a tělnatost vína“
#
# Proměnná                         Váha     Význam
# ---------------------------------------------------------------------------
# Alcohol                          0.779    obsah alkoholu
# Color.intensity                  0.748    intenzita barvy
# Proline                          0.688    koncentrace látek (zrání, kvalita)
#
# Laická interpretace:
# -> Tento faktor říká, jak „silné“ a „hutné“ víno je.
# -> Vysoká hodnota = více alkoholu, tmavší barva, více extraktu
# -> typicky „těžší“ víno (plnější tělo)
# ---------------------------------------------------------------------------


# ---------------------------------------------------------------------------
# FAKTOR 3 – „Minerální složení“
#
# Proměnná                         Váha     Význam
# ---------------------------------------------------------------------------
# Alcalinity.of.ash                0.856    zásaditost (chemická rovnováha)
# Ash                              0.629    obsah minerálů
#
# Laická interpretace:
# -> Tento faktor popisuje „minerální charakter“ vína.
# -> Vysoká hodnota = více minerálů, jiná chemická stabilita
# -> souvisí s půdou a chemickým složením
# ---------------------------------------------------------------------------


# ===================== VYSVĚTLENÁ VARIABILITA =====================
# Faktor 1: 30.8 %
# Faktor 2: 17.5 %
# Faktor 3: 10.0 %
# CELKEM:   58.4 %
#
# -> Faktory dohromady vystihují cca 58 % variability.
# =================================================================


# 3. Je možné na základě chemické analýzy vzorku vína poznat, ke které odrůdě víno patří? Určete vhodnou funkci / funkce, které Vám neznámý vzorek pomohou přiřadit ke správné skupině. Jak je taková rozhodovací funkce dobrá? A kolik takovýchto funkcí potřebujete?

library(MASS)

set.seed(456)

X <- setdiff(colnames(wine), "Cultivar")
Y <- wine$Cultivar

row_count <- nrow(wine)

train_indices <- sample(1:row_count, 0.8 * row_count)
train_data <- wine[train_indices, ]

test_indices <- setdiff(1:row_count, train_indices)
test_data <- wine[test_indices, ]

# Zvolil jsem tzv. uniformní apriorní pravděpodobnosti, protože chci aby:
# - všechny odrůdy měli na startu stejnou šanci, resp. nechci modelu napovídat, která odruda je reálně častější
# - říkám, že všechny odrudy jsou v datech zastoupeny rovnoměrně
# - z dat nevíme, jaká je reálná distribuce vín na trhu, tedy chceme distribuční funkci, která bude nestranná
# Dělám to zkrátka proto, abych zajistil, že výsledná klasifikace bude založena čistě na chemických rozdílech mezi víny.
# Tím zabráním tomu, aby model 'nadržoval' některé odrůdě jen proto, že je v tréninkových datech náhodou zastoupena vícekrát.
prior_probability <- c(1/3, 1/3, 1/3)
lda_model <- lda(formula = Cultivar ~ ., data = train_data, prior = c(1/3, 1/3, 1/3))

predictions <- predict(object = lda_model, newdata = test_data)

confusion_matrix <- table(Predicted = predictions$class, Actual = test_data$Cultivar)
print(confusion_matrix)

accuracy <- mean(predictions$class == test_data$Cultivar)
cat("Přesnost predikce na testovacích datech:", round(accuracy * 100, 2), "%")

# Diskriminační funkce(LD1) pokrývá téměř 74 % rozlišovací informace mezi odrůdami.
# Druhá funkce (LD2) doplňuje zbývajících 26 %.
# Dohromady tyto dvě funkce vysvětlují 100 % variability mezi skupinami, což znamená, že dvourozměrný graf LD1 vs. LD2
# je dokonalou reprezentací toho, jak se od sebe odrůdy chemicky liší, a neztrácíme tímto zobrazením žádnou informaci podstatnou pro klasifikaci.
cat("\nPodíl diskriminační informace (LD1, LD2):\n")
print(lda_model$svd^2 / sum(lda_model$svd^2))

plot(predictions$x[, 1], predictions$x[, 2], 
     col = test_data$Cultivar,
     pch = 19, 
     xlab = "LD1", ylab = "LD2", 
     main = "LDA: Klasifikace testovacích vzorků")

legend("topright",
       legend = levels(test_data$Cultivar), 
       col = 1:length(levels(test_data$Cultivar)), 
       pch = 19)

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


set.seed(123)
km_model <- kmeans(x = X_scaled, centers = 3, nstart = 25)
clusters_kmeans <- km_model$cluster

comparison_table <- table(Ward = cluster_3, Kmeans = clusters_kmeans)
print("Srovnání metod Ward a K-means:")
print(comparison_table)

cluster_profiles <- aggregate(X, by = list(Cluster_ID = clusters_kmeans), FUN = mean)
print("Průměrné hodnoty chemických vlastností v shlucích (K-means):")
print(cluster_profiles)

pca_res <- prcomp(X_scaled)
plot(pca_res$x[,1], pca_res$x[,2], col = clusters_kmeans, pch = 19,
     xlab = "PC1", ylab = "PC2", main = "Vizualizace K-means shluků")
legend("topright", legend = paste("Shluk", 1:3), col = 1:3, pch = 19)



# ODPOVĚDI NA OTÁZKY:

# Jaké metody byly vyzkoušeny?
# - Hierarchické shlukování metodou Ward s různým počtem shluků (k = 2, 3, 4).
# - Nehiearchické shlukování metodou K-means.

# Kolik skupin bylo zvoleno jako optimální?
# - 3 shluky.

# Jak lze jednotlivé skupiny charakterizovat?
# - Skupiny se liší zejména obsahem fenolů (Total.phenols), alkoholu (Alcohol),
# intenzitou barvy (Color.intensity) a minerálním složením vína (Ash, Alcalinity.of.ash, Magnesium).

# Shluk 1 (Těžší, kyselá vína): Nejvyšší kyselost (Malic.acid 3.31) a intenzita barvy (7.23). Nejnižší obsah flavonoidů (0.82) a nejnižší kvalita fenolů.
# Shluk 2 (Silná, prémiová vína): Nejvyšší alkohol (13.68 %), hořčík (107.97) a extrémně vysoký prolin (1100.23). Nejbohatší na antioxidanty (OD280/OD315 3.16).
# Shluk 3 (Lehká, jemná vína): Nejnižší alkohol (12.25 %) a nejnižší barva (2.97). Celkově nejnižší obsah minerálů a prolinu.