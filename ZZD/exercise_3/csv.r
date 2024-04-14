library(tidyverse)
library(tidyr)

# Pomocí vhodné funkce načtěte tabulku StudentsPerformance.csv
# obsahující data ze šetření úspěšnosti studentů
# v oblasti matematiky, čtení a psaní.
students_performance <- read_csv("StudentsPerformance.csv")

# Vytvořte nový sloupec avg_score,
# který bude pro každý záznam tabulky obsahovat průměrné skóre
# dané osoby ze sloupců math.score, reading.score a writing.score
students_performance$avg_score <- rowMeans(
  students_performance[, c("math score", "reading score", "writing score")],
  na.rm = TRUE
)

# Z tabulky vyfiltrujte pouze záznamy,
# kde sloupec parental.level.of.education
# obsahuje pojem “high school” kdekoliv v textu
filtered_students_performance <- students_performance %>%
  filter(grepl("high school", `parental level of education`))

# Vypočtěte průměrnou hodnotu sloupce avg_score
# pro každou kombinaci kategorií gender a race.etnicity
avg_scores_by_gender_ethnicity <- students_performance %>%
  group_by(gender, `race/ethnicity`) %>%
  summarize(avg_score = mean(avg_score, na.rm = TRUE))

# Tabulku upravte do tzv. “širokého formátu” tak,
# aby kategorie ze sloupce gender představovaly vlastní sloupce
# a vypočtené průměrné hodnoty byly hodnotami v těchto nových sloupcích
wide_format_data <- avg_scores_by_gender_ethnicity %>%
  spread(gender, avg_score)
# nebo
wide_format_data <- avg_scores_by_gender_ethnicity %>%
  pivot_wider(names_from = gender, values_from = avg_score)

# Přidejte nový sloupce popisující procentuální rozdíl 
# mezi hodnotami v nově vzniklých sloupcích (100*(female-male)/female)
wide_format_data$percentage <- 100 * (wide_format_data$female - wide_format_data$male) / wide_format_data$female

View(wide_format_data)
