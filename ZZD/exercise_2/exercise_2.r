# https://physics.ujep.cz/~jskvor/ZZD/2/#/title-slide

# Vektor
# Matice
# Data frame = v jednotlivých sloupcích různé datové typy (připomíná tabulku)
# List (Seznam)

jmeno <- c("Petr", "Jan", "Andrea")
vek <- c(70, 8, 21)
studuje <- c(FALSE, FALSE, TRUE)
df <- data.frame(jmeno, vek, studuje)
View(df)

# základní definice seznamu
seznam <- list(1, "a", c(2, 3))
seznam

rm(list=ls())

fibonacci <- function (n) {
  if (n == 1) {
    return(0)
  }
  
  if (n == 2) {
    return(c(0, 1))
  }
  
  result <- numeric(n)
  result[1:2] <- c(0, 1)
  
  for (i in 3:n) {
    result[i] <- result[i - 1] + result[i - 2]
  }
  
  return(result)
}

a <- fibonacci(10)
a

# Definujte funkci pro řešení kořenů kvadratické rovnice
# ax2+bx+c=0.
solve_quadratic_equation <- function(a, b, c) {
  discriminant <- b**2 - 4 * a * c
  if (discriminant < 0) {
    discriminant <- as.complex(d)
  }

  x1 <- (-b + sqrt(discriminant)) / 2 * a
  x2 <- (-b - sqrt(discriminant)) / 2 * a

  return(c(x1, x2))
}

result <- solve_quadratic_equation(1, -5, -26)
print(result)

table(iris$Species)