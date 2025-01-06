library(DescTools)
library(ggplot2)

load("Math.RData")
View(Math)

# Úlohy pro popisnou a infereční statistiky

# Otázka č. 1 
velikosti_trid <- na.omit(Math$Size)
interval_spolehlivosti <- MeanCI(class_sizes, conf.level = 0.95)
print(interval_spolehlivosti)

# Otázka č. 2
# Přeskočena

# Otázka č. 3
boxplot(Math$GPAadj,
        main = 'Krabicový graf proměnné GPAadj',
        xlab = 'Hodnoty GPA', 
        ylab = 'Dosažené GPA',
        col = 'lightgreen',
        border = 'black')

odlehla_pozorovani <- Outlier(Math$GPAadj, method = "boxplot", na.rm = TRUE)
print(odlehla_pozorovani)

# Úlohy na pravdepodobnostěpodobnost rozdělení

# Otázka č. 1
n <- 7       # Počet dnů (pokusů)
p <- 5/8     # pravdepodobnostěpodobnost úspěchu (žlutý hrníček)

# Pravděpodobnost alespoň 5 úspěchů
pravdepodobnost <- 1 - pbinom(4, size = n, prob = p)
cat("Pravděpodobnost, že budu pít ze žlutého hrníčku alespoň 5krát za týden, je:", pravdepodobnost, "\n")

# Otázka č. 2
stredni_hodnota <- 100    # Střední hodnota IQ
smerodatna_odchylka <- 15 # Směrodatná odchylka IQ (odmocnina z uvedeného rozptylu 225)

# (a) Pravděpodobnost, že IQ bude nižší než 85
iq_pod_85 <- pnorm(85, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude nižší než 85, je:", iq_pod_85, "\n")

# (b) Pravděpodobnost, že IQ bude alespoň 130 (vstup do Mensy)
iq_nad_130 <- 1 - pnorm(130, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude alespoň 130, je:", iq_nad_130, "\n")

# (c) Pravděpodobnost, že IQ bude v rozsahu 110–125
iq_110_125 <- pnorm(125, mean = stredni_hodnota, sd = smerodatna_odchylka) - 
  pnorm(110, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude mezi 110 a 125, je:", iq_110_125, "\n")

# (d) Pravděpodobnost, že dvě osoby budou mít obě IQ menší než 100
iq_pod_100 <- pnorm(100, mean = stredni_hodnota, sd = smerodatna_odchylka)
dve_osoby_pod_100 <- iq_pod_100 * iq_pod_100
cat("Pravděpodobnost, že dvě náhodné osoby budou mít obě IQ menší než 100, je:", dve_osoby_pod_100, "\n")