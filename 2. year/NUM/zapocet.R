# 1. Řešení diferenciální rovnice

PopulationModel <- function(N, r, A, K) {
  -r * N * (1 - N / A) * (1 - N / K)
}

# x0, y0 počáteční podmínky
EulerMethod <- function(f, x0, y0, h, n) {
  x <- numeric(n + 1)
  y <- numeric(n + 1)
  
  x[1] <- x0
  y[1] <- y0
  
  for (i in 1:n) {
    y[i + 1] <- y[i] + h * f(x[i], y[i])
    x[i + 1] <- x[i] + h
  }
  
  list(x = x, y = y)
}

# Metoda EulerMethod očekává funkci, která bude přijímat 2 parametry
# Tedy jakoby f(x, y), tedy diferenciální funkci (proto jsem vytvořil f_wrapped)
f_wrapped <- function(t, N) PopulationModel(N, r, A, K)

A <- 20
K <- 100
N0 <- 60
r <- 0.5
h <- 0.1  # Velikost kroku
n <- 100  # Počet kroků
# Tedy interval t=0 do t=10 (100*0.1 - Eulerova metoda se posune 100krát o 0.1, což v EulerMethod je h)

result <- EulerMethod(f = f_wrapped, x0 = 0, y0 = N0, h = h, n = n)
plot(result$x, result$y, type = "l", main = "Růst populace", xlab = "Čas (t)", ylab = "Populace (N)")

# 2. Lineární interpolace

# Hledám x pro y = 80 (resp. t pro N = 80)
target_N <- 80
t_at_80 <- NA

# Hledám v datech interval (dva sousední body), kde populace překročila 80
for (i in 1:(length(result$y) - 1)) {
  if ((result$y[i] <= target_N && result$y[i+1] >= target_N) ||
      (result$y[i] >= target_N && result$y[i+1] <= target_N)) {
    
    # Zde si získám [t1, N1], [t2, N2]
    t1 <- result$x[i]
    t2 <- result$x[i+1]
    N1 <- result$y[i]
    N2 <- result$y[i+1]
    
    # Vzorec pro lineární interpolaci v intervalu <N1, N2>
    t_at_80 <- t1 + (target_N - N1) * (t2 - t1) / (N2 - N1) 
    break
  }
}

# tk = 0.7858
print(paste("Čas, ve kterém populace dosáhne N = 80, je přibližně:", round(t_at_80, 4)))

plot(result$x, result$y, type = "l", main = "Růst populace", xlab = "Čas (t)", ylab = "Populace (N)")
abline(h = target_N, col = "red", lty = 2)
abline(v = t_at_80, col = "blue", lty = 2)
points(t_at_80, target_N, col = "darkgreen", pch = 19)

plot(result$x, result$y, col = "blue", pch = 16, cex = 0.6,
     xlab = "Čas (t)", ylab = "Populace (N)", 
     main = "Lineární interpolace Eulerova řešení")
grid()


for (i in 1:(length(result$x)-1)) {
  current_x <- c(result$x[i], result$x[i+1])
  current_y <- c(result$y[i], result$y[i+1])
  lines(current_x, current_y, col = "red", lwd = 2)
}

legend("bottomright", 
       legend = c("Body (Eulerova metoda)", "Úseky (Lineární interpolace)"), 
       col = c("blue", "red"), 
       pch = c(16, NA), 
       lty = c(NA, 1),
       lwd = 2)

# 3. Aproximace funkce parabolou

# Metoda nejmenších čtverců
GetCoefMNC <- function(x, y, phi) {
  m <- length(x)
  n <- length(phi(1))
  
  A <- matrix(0, nrow = n, ncol = m)
  for (j in 1:m) {
    A[, j] <- phi(x[j])
  }
  
  b <- c(A %*% y)
  A <- A %*% t(A)
  
  solve(A, b)
}

# Bázové funkce paraboly (ta má tvar a1 + a2x + a3x^2)
phi <- function(x) {
  return(c(1, x, x^2))
}

coefs <- GetCoefMNC(result$x, result$y, phi)
parabola <- function(x) {
  coefs[1] + coefs[2]*x + coefs[3]*x^2
}

t_pred <- 4
N_pred <- parabola(t_pred)

print(paste("Koeficienty paraboly:", paste(round(coefs, 4), collapse = ", ")))
print(paste("Odhadovaná populace v čase t =", t_pred, "je:", round(N_pred, 4)))

plot(result$x, result$y, type = "p", pch = 16, col = "grey", 
     main = "Eulerova metoda s aproximací pomocí paraboly", xlab = "Čas (t)", ylab = "Populace (N)")

curve(parabola(x), add = TRUE, col = "darkorange", lwd = 2)

points(t_pred, N_pred, col = "purple", pch = 15, cex = 1.5)
legend("bottomright", legend = c("Eulerova metoda", "Parabola", "t=4"),
       col = c("grey", "darkorange", "purple"), pch = c(16, NA, 15), lty = c(NA, 1, NA))