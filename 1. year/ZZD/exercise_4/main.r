library(tidyverse)
library(ggplot2)

students_performance <- read_csv("StudentsPerformance.csv")

# Bodový graf.
plot(
  students_performance$`writing score`,
  students_performance$`reading score`,
  xlab = "writing score",
  ylab = "reading score",
  main = "Writing vs reading score"
)

# Bodový graf (ggplot2).
# aes() - aesthetics - nastavuje, co se má dát na osu x a osu y
# "+" znamená přidání vrstvy ke grafu
# geom_point() - vykreslí graf
# xlab přidá popisek x-ové osy, ylab přidá popisek y-onové osy
students_performance %>% 
  ggplot(aes(x=`writing score`, y=`reading score`)) +
  geom_point() + 
  xlab("writing score") + 
  ylab("reading score") +
  labs(title="Writing vs reading score")

# Vytvořte nový sloupec avg_score, 
# který bude pro každý záznam tabulky obsahovat
# průměrné skóre dané osoby ze sloupců
# math.score, reading.score a writing.score.
# Vytvořte histogram hodnot ze sloupce 
# avg_score pomocí vestavěných funkcí (base graphics).
students_performance["avg_score"] = (
  students_performance$`writing score` +
  students_performance$`reading score` +
  students_performance$`math score`
) / 3.0

# Další možné řešení:
students_performance <- students_performance %>% mutate(avg_score = (`writing score` + `reading score` + `math score`) / 3.0)

# Vytvořte histogram hodnot ze sloupce avg_score pomocí vestavěných funkcí (base graphics).
hist(students_performance$avg_score,
     main="Rozdělení počtu bodů",
     xlab="počet bodů",
     ylab="četnost",
     xlim=c(0, 100)
)

# bins = počet přihrádek
# theme_classic = skryje mřížky v pozadí
# fill = barva výplně
# color = barva obrysu
students_performance %>% 
  ggplot(aes(x=avg_score)) +
  geom_histogram(bins = 10, fill = "gray", color = "black") +
  theme_classic()