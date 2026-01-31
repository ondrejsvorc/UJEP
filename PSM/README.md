## Pokročilé statistické metody

### Užitečné odkazy
- https://kma.ujep.cz/profil/alena-cernikova
- https://docs.google.com/document/d/1WA2M25evFDn-AV-Sfsq3P2kv\_6thJBLe5C2jRokXucc/edit?tab=t.0
- https://docs.google.com/document/d/1E-wic70lhKmbUqgHJUmuggUjI2Udx9I-L2yxrjuz0NM/edit?usp=sharing
- https://is.muni.cz/el/1431/jaro2016/Z2069/um/54271982/56272282/PCA_prez_pondelniskupiny.pdf
- https://naucse.python.cz/2021/pydata-praha-jaro/pydata/pca/

### Statistika
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

### Metody
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

```r
X <- wine[, setdiff(names(wine), "Cultivar")]
pca <- prcomp(X, scale. = TRUE)
```

### Složení hlavní komponenty
- proměnné s největší absolutní hodnotou zatížení komponentu definují a umožňují její interpretaci

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

### Testy
- t-test
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
