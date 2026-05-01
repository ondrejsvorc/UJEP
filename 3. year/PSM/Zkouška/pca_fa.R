# Metoda hlavních komponent
# Faktorová analýza

library(MASS)
data(Cars93)

df <- Cars93[, c(4:8, 12:15, 17:25)]
df_clean <- na.omit(df)

pca <- prcomp(df_clean, scale. = TRUE)
summary(pca)

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

interpret_pca(pca, target_variance = 0.8)
interpret_pca_loadings(pca, components = 3, top_n = 18)

# PC1: Rozměry a robustnost (Velikost auta)
# - Dominují proměnné jako Weight (0.287), EngineSize (0.277) a Wheelbase (0.271).
# - PC1 popisuje "fyzickou hmotu" vozu. Vysoké hodnoty PC1 znamenají velká, 
#   těžká auta s velkým objemem motoru a nádrže.

# PC2: Ekonomika vs. Luxus/Otáčky (Motor a Cena)
# - Nejsilnější jsou RPM (0.407) a Price (0.366 až 0.393).
# - Záporná hodnota u Passengers (-0.298).
# - PC2 odděluje auta s vysokootáčkovými motory a vyšší cenou od levnějších 
#   rodinných vozů (které mají více míst k sezení).

# PC3: Vnitřní komfort a prostor pro posádku
# - Dominuje Rear.seat.room (0.574) a Passengers (0.390).
# - PC3 se zaměřuje na užitnou hodnotu pro cestující. Vysoké hodnoty znamenají 
#   více místa na nohy vzadu a větší kapacitu osob.

# ------------------------------------------------------------------------------
# První 3 komponenty kumulativně vysvětlují 83,3 % variability dat. 


# PC1 (Index velikosti):
# PC1 = 0.287*Weight + 0.277*EngineSize + 0.271*Wheelbase + 0.269*Length + ...

# PC2 (Index luxusu):
# PC2 = 0.407*RPM + 0.393*Max.Price + 0.366*Price - 0.298*Passengers + ...

# PC3 (Index vnitřního prostoru):
# PC3 = 0.574*Rear.seat.room + 0.390*Passengers + 0.250*Rev.per.mile + ...


# x = komponenty
# y = vlastní číslo
plot(pca, type = "l", main = "Scree Plot")
abline(h = 1, col = "red", lty = 2) # Kaiserovo pravidlo / Loket

# Standardizace (aby všechny proměnné měli zpočátku stejnou váhu)
X_scaled <- scale(df_clean)
fa <- factanal(X_scaled, factors = 3, rotation = "varimax", scores = "Bartlett")
print(fa$loadings, cutoff = 0.4)

# Data nám říkají, že auta se liší hlavně ve třech věcech: jak jsou velká, kolik stojí a kolik sežerou.
# Těmito třemi faktory vysvětlíme 78 % všeho, co o těch autech víme.

# Faktor 1: VELIKOST (Width, Length, Wheelbase)
# Faktor 2: LUXUS (Price, Horsepower)
# Faktor 3: SPOTŘEBA (MPG záporné = vysoká spotřeba)