dataset <- datasets::mtcars
str(dataset)
head(dataset)

colnames(dataset) <- c(
  "spotreba",
  "pocet_valcu_motoru",
  "objem_motoru",
  "vykon",
  "staly_prevod_zadni_napravy",
  "hmotnost_vozu",
  "zrychleni",
  "tvar_motoru",
  "typ_prevodovky",
  "pocet_rychlostnich_stupnu",
  "pocet_karburatoru"
)
str(dataset)
head(dataset)

# Odstraneny nominalni (kategoricke) promenne
X <- dataset[, c("spotreba", "objem_motoru", "vykon", "staly_prevod_zadni_napravy", "hmotnost_vozu", "zrychleni")]
cor(X)

pca <- prcomp(X, scale. = TRUE)
summary(pca)
pca$rotation

plot(pca, type = "l") # Scree plot
abline(h = 1, col = "red", lty = 2) # Kaiserovo kritérium (vlastní číslo > 1)

# biplot(pca, cex = 0.8)



# 1. Spočítáme vzdálenosti mezi auty (použijeme výsledky z PCA)
vzdalenosti <- dist(pca$x[, 1:2]) # Bereme jen první 2 komponenty

# 2. Shlukování Wardovou metodou (minimalizuje vnitroshlukový rozptyl)
shluky_h <- hclust(vzdalenosti, method = "ward.D2")

plot(shluky_h, main = "Dendrogram aut (na bázi PCA)", sub = "", xlab = "")
rect.hclust(shluky_h, k = 3, border = "red") # Naznačíme 3 skupiny

dataset$shluk <- cutree(shluky_h, k = 3)
aggregate(. ~ shluk, data = dataset[, c("spotreba", "vykon", "hmotnost_vozu", "shluk")], mean)










# 1. Nastavení náhodného semínka (DŮLEŽITÉ!)
# K-means začíná náhodným rozhozením středů, tak aby ti u zkoušky 
# nevyšlo pokaždé něco jiného, musíš tam dát toto číslo:
set.seed(123)

# 2. Vlastní K-means shlukování
# centers = 3 říkáme algoritmu: "Chci přesně 3 skupiny"
km <- kmeans(pca$x[, 1:2], centers = 3)

# 3. Podíváme se na výsledky
print(km$cluster) # Vypíše, které auto patří do kterého shluku (1, 2, 3)

# 4. Profilování shluků (stejně jako u hierarchického)
# Přidáme si výsledek k-means do datasetu
dataset$shluk_kmeans <- km$cluster
aggregate(. ~ shluk_kmeans, data = dataset[, c("spotreba", "vykon", "hmotnost_vozu", "shluk_kmeans")], mean)





library(cluster)

# 1. Vykreslení shluků v prostoru prvních dvou hlavních komponent
# color=TRUE přidá barvy, shade=TRUE přidá elipsy rozptylu
clusplot(pca$x[, 1:2], km$cluster, 
         color=TRUE, shade=TRUE, 
         labels=2, lines=0, 
         main="Vizualizace K-means shluků (k=3) na PCA",
         xlab = "PC1 (Velikost a výkon)", 
         ylab = "PC2 (Zrychlení)")

# 2. Alternativa: Pokud chceš jen jednoduchý scatter plot s barvami
plot(pca$x[, 1:2], col = km$cluster, pch = 16, main = "Body rozdělené do 3 shluků")
text(pca$x[, 1:2], labels = rownames(dataset), pos = 3, cex = 0.7)






# factors = 2 říkáme, kolik skrytých faktorů hledáme
# rotation = "varimax" je klíčové slovo - otočí faktory tak, aby byly lépe čitelné
fa <- factanal(X, factors = 2, rotation = "varimax")
print(fa, cutoff = 0.3) # cutoff skryje malé váhy pro přehlednost







library(MASS)
# typ_prevodovky ~ . znamená: vysvětli typ převodovky pomocí všech ostatních sloupců
model_lda <- lda(typ_prevodovky ~ spotreba + vykon + hmotnost_vozu, data = dataset)
plot(model_lda)
