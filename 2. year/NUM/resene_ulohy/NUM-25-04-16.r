# https://physics.ujep.cz/~jskvor/NME/NUM-25-04-16.html

f <- function(x) { 1 / x }
IA <- log(2)

trapezoid <- function(f, a, b, n) {
  h <- (b - a) / n
  integral <- 0
  
  for (i in 0:(n - 1)) {
    x_left  <- a + i * h
    x_right <- a + (i + 1) * h
    integral <- integral + (h / 2) * (f(x_left) + f(x_right))
  }
  
  return(integral)
}

i_vals <- 0:20
n_vals <- 2^i_vals

IN_vals <- numeric(length(n_vals))
error_vals <- numeric(length(n_vals))

for (k in seq_along(n_vals)) {
  n <- n_vals[k]
  IN <- trapezoid(f, a = 1, b = 2, n = n)
  IN_vals[k] <- IN
  error_vals[k] <- IN - IA
}

abs_error <- abs(error_vals)
i_min <- i_vals[which.min(abs_error)]

plot(
  i_vals,
  error_vals,
  type = "b",
  pch  = 19,
  xlab = "i",
  ylab = "IN(i) - IA",
  main = "Chyba numerické integrace (lichoběžníkové pravidlo)"
)
abline(h = 0, lty = 2)

cat("Nejmenší absolutní chyba nastává pro i =", i_min, "\n")
cat("Chyba při tom i je", error_vals[i_min + 1], "\n")