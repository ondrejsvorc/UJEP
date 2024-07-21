library(tidyverse)
library(ggplot2)

# https://physics.ujep.cz/~jskvor/ZZD/ZZD-cv5.html
# https://physics.ujep.cz/~jskvor/ZZD/5/#7_Korelace_a_regrese
# null and alternative hypothesis statistics
# https://statsandr.com/blog/files/overview-statistical-tests-statsandr.pdf
# Chí-kvadrát test

students_performance <- read_csv("StudentsPerformance.csv")

x <- students_performance$`math score`
y <- students_performance$`reading score`

# Koeficienty
# Pearsonův korelační koeficient (porovnává závislost x a y)
# Spearmanův korelační koeficient (udělá pořadí, a až pak porovnává závislosti)
pearson <- cor(x, y)
spearman <- cor(x,y,method="spearman")

model <- lm(y ~ x)
summary(model)

plot(
  x, 
  y, 
  xlab="math score", 
  ylab="reading score",
  main=paste0("Pearson=", round(pearson, 5), "\nSpearman=", round(spearman, 5))
)
abline(model, col="blue")






x <- students_performance$`math score`
y <- students_performance$`writing score`

pearson <- cor(x, y)
spearman <- cor(x,y,method="spearman")

model <- lm(y ~ x)
summary(model)

plot(
  x, 
  y, 
  xlab="math score", 
  ylab="writing score",
  main=paste0("Pearson=", round(pearson, 5), "\nSpearman=", round(spearman, 5))
)
abline(model, col="blue")





# Ověřte následující hypotézy:

# 1. průměrné skóre studentů (avg_score z minulého cvičení) 
# nezávisí na tom, zda se studenti na test připravovali nebo ne (sloupec test.preparation.course)

students_performance <- read_csv("StudentsPerformance.csv")
students_performance["avg_score"] = (
  students_performance$`writing score` +
    students_performance$`reading score` +
    students_performance$`math score`
) / 3.0

tapply(students_performance$avg_score, students_performance$`test preparation course`, var)
students_performance %>% group_by(`test preparation course`) %>% summarize(var(avg_score))
t.test(students_performance$avg_score[students_performance$`test preparation course`=="none"], 
       students_performance$avg_score[students_performance$`test preparation course`=="completed"])


# 2. dosažená úroveň vzdělání rodičů studenta (parental level of education) nezávisí na etnické skupině (race.etnicity))
# hypotéza se zamítá (p-hodnota je menší než 0,05 = 5%)
students_performance <- read_csv("StudentsPerformance.csv")
ct <- table(students_performance$`race/ethnicity`, students_performance$`parental level of education`)
proportions(ct, 1)
chisq.test(ct)
