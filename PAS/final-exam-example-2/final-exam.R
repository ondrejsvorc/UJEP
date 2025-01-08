library(DescTools)
library(ggplot2)

data <- read.csv("prij.csv", sep = ";", header = TRUE, stringsAsFactors = FALSE, fileEncoding = "UTF-8", dec = ",")

# 1) Úlohy na popisnou a inferenční statistiku

# Otázka č. 1

# Histogram
# Ukazuje symetrické rozdělení s pravostranným zašikmením
odhadnute_bw <- density(data$ss3, bw = "nrd0")$bw
hist(data$ss3,
     breaks = 10,
     col = "white",
     xlab = "Prumerna znamka ze 3.rocniku SS",
     ylab = "Absolutni cetnost",
     main = "Histogram pro promennou ss3")
lines(density(data$ss3, bw = odhadnute_bw), col = "purple", lwd = 2)

# Šikmost je kladná, což je typické pro pravostranné rozdělení
Skew(data$ss3) 

# Rozdělení je lehká špičatější než normální rozdělení (mesokurtické), které má špičatost rovnou 0
Kurt(data$ss3) 

# Q-Q graf
# Tři případy:
# 1. Pokud jsou body blízko přímky → Data jsou pravděpodobně normálně rozdělená.
# 2. Pokud body výrazně odchylují od přímky na začátku nebo na konci, znamená to problém s normalitou (např. špičatost nebo plochost rozdělení).
# 3. Pokud je patrný jasný vzor (např. křivka místo přímky), data nejsou normálně rozdělená.
# Zde nastává 2. případ.
qqnorm(data$ss3)
qqline(data$ss3, col = "purple")

# Shapiro-Wilk test
# Statistický test, který ověřuje, zda data pocházejí z normálního rozdělení
# H0: Data pocházejí z normálního rozdělení.
# H1: Data nepocházejí z normálního rozdělení.
# p-hodnota > 0.05: Nemáme dostatek důkazů pro zamítnutí nulové hypotézy → Data jsou v souladu s normálním rozdělením.
# p-hodnota ≤ 0.05: Zamítáme nulovou hypotézu → Data nejsou normálně rozdělená.
# p-value = 0.01336
# p-hodnota je menší než 0.05, což znamená, že zamítáme nulovou hypotézu.
# Data v proměnné ss3 nejsou normálně rozdělená.
shapiro.test(data$ss3)

# Otázka č. 2

# S 95% jistotou je skutečný průměrný počet bodů uchazečů o studium mezi 135,03 a 146,35.
MeanCI(data$celprij, conf.level = 0.95)

# Otázka č. 3

# Boxplot s rozdělením dle pohlaví
boxplot(celprij ~ Pohlavi, data = data,
        main = "Celkový počet bodů dle pohlaví",
        xlab = "Pohlaví", 
        ylab = "Celkový počet bodů",
        col = "lightgray")
# Přidání průměru do boxplotu
means <- tapply(data$celprij, data$Pohlavi, mean, na.rm = TRUE) # Výpočet průměrů
points(1:length(means), means, col = "purple", pch = 19, cex = 1.5) # Přidání bodů pro průměry
legend("topright", legend = "Průměr", col = "purple", pch = 19, bty = "n") # Legenda

# Muži (m):
# Medián a průměr jsou velmi blízko sebe, což naznačuje relativně symetrické rozdělení.
# Hodnoty jsou soustředěny kolem mediánu (~140–150 bodů).
# Dolní a horní kvartily jsou rozloženy symetricky.
# Mezikvartilové rozpětí (IQR) je širší než u žen, což naznačuje větší variabilitu výsledků u mužů.

# Ženy (z):
# Medián a průměr jsou téměř totožné, což také naznačuje symetričtější rozložení.
# Rozptyl hodnot je o něco širší než u mužů, ale medián je mírně nižší.
# Mezikvartilové rozpětí je užší, což znamená menší variabilitu.

# Výpočet průměrů pro každé pohlaví
means <- tapply(data$celprij, data$Pohlavi, mean, na.rm = TRUE)
print(means)

# Výpočet mediánů pro každé pohlaví
medians <- tapply(data$celprij, data$Pohlavi, median, na.rm = TRUE)
print(medians)

# Zobrazení výsledků vedle sebe
comparison <- data.frame(
  Pohlavi = names(means),
  Prumer = means,
  Median = medians
)
print(comparison)
# Medián < Průměr (rozdělení je pravostranně zašikmené)
# Medián > Průměr (rozdělení je levostranně zašikmené)
# Medián ≈ Průměr (rozdělení je přibližně symetrické)

# T-test pro porovnání celkového počtu bodů dle pohlaví
t_test <- t.test(celprij ~ Pohlavi, data = data, var.equal = FALSE)
print(t_test)
# p-value = 0.5171
# p-hodnota > 0.05: Rozdíl mezi skupinami není statisticky významný.
# p-hodnota ≤ 0.05: Rozdíl mezi skupinami je statisticky významný.

# Nulová hypotéza (H₀): Neexistuje statisticky významný rozdíl v průměrném počtu bodů (celprij) mezi muži a ženami.
# Alternativní hypotéza (H₁): Existuje statisticky významný rozdíl v průměrném počtu bodů (celprij) mezi muži a ženami.
# Jelikož p-hodnota (0.5171) > 0.05, nemáme dostatek důkazů k zamítnutí nulové hypotézy.
# Rozdíl mezi průměry mužů a žen není statisticky významný.
# Na základě tohoto testu nemůžeme tvrdit, že pohlaví má významný vliv na výsledek přijímacího řízení.

# Otázka č. 4

# Kontingenční tabulka mezi oborem studia a pohlavím
tabulka <- table(data$Obor, data$Pohlavi)
print(tabulka)

# Chí-kvadrát test nezávislosti
# H₀: Neexistuje vztah mezi oborem studia a pohlavím.
# H₁: Existuje vztah mezi oborem studia a pohlavím.
# p-hodnota ≤ 0.05: Existuje statisticky významný vztah mezi oborem studia a pohlavím.
# p-hodnota > 0.05: Neexistuje statisticky významný vztah.
# p-value = 0.165
# Jelikož p-hodnota (0.165) > 0.05, nemáme dostatek důkazů pro zamítnutí nulové hypotézy.
# Ano, existuje statisticky významný vztah mezi oborem studia a pohlavím.
# Můžeme identifikovat, zda určitý obor více preferují muži nebo ženy
chi_test <- chisq.test(tabulka)
print(chi_test)

# Mozaikový graf
mosaicplot(tabulka,
           main = "Vztah mezi oborem studia a pohlavím",
           xlab = "Obor studia", ylab = "Pohlaví",
           col = c("lightblue", "lightpink"),
           border = "black")
# FYZG (Fyzická geografie): Přibližně rovnoměrné rozložení mezi muži a ženami.
# KARTG (Kartografie): Více mužů než žen.
# REGG (Regionální geografie): Mírně více žen než mužů.
# SOCG (Sociální geografie): Jasná převaha žen.

# Otázka č. 5

# Korelační koeficient
# r > 0: Přímá závislost (rostoucí trend).
# r < 0: Nepřímá závislost (klesající trend).
# |r| blízké 1: Silná závislost.
# |r| blízké 0: Slabá závislost.
# -0.303 naznačuje slabou až středně silnou negativní korelaci.
# Negativní (horší známky → nižší počet bodů).
# Čím horší známky měl student ve 3. ročníku SŠ, tím nižší počet bodů obvykle získal u přijímacích zkoušek
cor_ss3_celprij <- cor(data$ss3, data$celprij, use = "complete.obs", method = "pearson")
print(paste("Korelační koeficient:", cor_ss3_celprij))

# Test významnosti korelace
# p-hodnota ≤ 0.05: Vztah je statisticky významný.
# p-hodnota > 0.05: Vztah není statisticky významný.
# Protože p-hodnota (0.032) ≤ 0.05, korelace je statisticky významná.
# Máme dostatek důkazů k zamítnutí nulové hypotézy, že mezi ss3 a celprij není žádný vztah.
cor_test <- cor.test(data$ss3, data$celprij, method = "pearson")
print(cor_test)

# Vizuální znázornění bodovým grafem
plot(data$ss3, data$celprij,
     main = "Vztah mezi ss3 a celprij",
     xlab = "Průměrná známka ze 3. ročníku SŠ (ss3)",
     ylab = "Celkový počet bodů u přijímaček (celprij)",
     pch = 19, col = "blue")
abline(lm(celprij ~ ss3, data = data), col = "purple", lwd = 2)
legend("topright", legend = "Regresní přímka", col = "purple", lwd = 2)

# Otázka č. 6

# Výpočet kvartilů pro matzem
kvartily_matzem <- quantile(data$matzem, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
print("Kvartily pro matzem:")
print(kvartily_matzem)

# Výpočet kvartilů pro geol
kvartily_geol <- quantile(data$geol, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
print("Kvartily pro geol:")
print(kvartily_geol)

# Vizualizace pomocí boxplotů
boxplot(data$matzem, data$geol,
        names = c("matzem", "geol"),
        col = c("lightblue", "lightgreen"),
        main = "Porovnání kvartilů: matzem vs geol",
        ylab = "Známky")

# Spodní kvartil (Q1):
# matzem: 1 → Spodní 25 % studentů mělo známku 1.
# geol: 2 → Spodní 25 % studentů mělo známku 2.

# Medián (Q2):
# matzem: 2 → Polovina studentů měla známku 2 nebo lepší.
# geol: 2 → Polovina studentů měla známku 2 nebo lepší.
# Rozdíl: Medián je stejný, což naznačuje podobné centrální rozložení hodnot.

# Horní kvartil (Q3):
# matzem: 2 → Horní 25 % studentů má známku maximálně 2.
# geol: 3 → Horní 25 % studentů má známku až 3.

# Nejhorší čtvrtina studentů má v matematické geografii lepší známky než ve geologii
# Medián je stejný, ale celkový kontext známek se liší
# Nejlepší čtvrtina studentů v matematické geografii má lepší známky než nejlepší čtvrtina v geologii
# Studenti dosahují výrazně lepších známek v matematické geografii než v geologii.
# V matzem většina studentů dosáhla známek 1 nebo 2, zatímco v geol je běžná známka 2 nebo 3.