# Pružinka
# Aproximace chování natahovací pružiny.
# V takovém případě pružina kmitá sem a tam,
# přičemž její pohyb lze popsat pomocí diferenciální rovnice, která zahrnuje výchylku 
# x a rychlost v.

# Kmitání
# https://cs.wikipedia.org/wiki/Kmit%C3%A1n%C3%AD

f <- function(t, X) {
  # X <- c(X[1], X[2]) <- c(x, v)
  return(c(X[2], -X[1]))
}
euler <- function(x, y, f, h) {
  return(y+h*f(x,y))
}

tMax <- 100
n <- 100000
h <- tMax / n
t <- seq(0, tMax, h)
n <- n + 1

# Matice, kde sloupce jsou proměnné x,v a řádky jednotlivé časy
X <- matrix(0, nrow = n, ncol = 2)
X[1, 1] <- 1 # výchylka
X[1, 2] <- 10 # rychlost
for(i in 2:n) {
  X[i,] <- euler(t, X[i-1,], f, h)
}
plot(t, X[,1], col='red', type='line')


# Tlumené kmitání
# Představa: exponenciála tlumí sinus funkci
# https://cs.wikipedia.org/wiki/Tlumen%C3%A9_kmit%C3%A1n%C3%AD

f <- function(t, X) {
  # X <- c(X[1], X[2]) <- c(x, v)
  return(c(X[2], -X[1]-0.1*X[2])) # Změna v kódu zde
}
euler <- function(x, y, f, h) {
  return(y+h*f(x,y))
}

tMax <- 100
n <- 100000
h <- tMax / n
t <- seq(0, tMax, h)
n <- n + 1

# Matice, kde sloupce jsou proměnné x,v a řádky jednotlivé časy
X <- matrix(0, nrow = n, ncol = 2)
X[1, 1] <- 1 # výchylka
X[1, 2] <- 10 # rychlost
for(i in 2:n) {
  X[i,] <- euler(t, X[i-1,], f, h)
}
plot(t, X[,1], col='red', type='line')





f <- function(t, X) {
  # X <- c(X[1], X[2]) <- c(x, v)
  return(c(X[2], -X[1]-0.1*X[2])) # Změna v kódu zde
}
euler <- function(x, y, f, h) {
  return(y+h*f(x,y))
}
RK2 <- function(x, y, f, h) { # Metoda Runge-Kutta (druhého řádu)
  hhalf <- 0.5 * h
  return(y+h*f(x,y+h*f(x+hhalf,y++hhalf*f(x,y))))
}

tMax <- 100
n <- 1000
h <- tMax / n
t <- seq(0, tMax, h)
n <- n + 1

X <- matrix(0, nrow = n, ncol = 2)
X[1, 1] <- 100 # výchylka
X[1, 2] <- 0 # rychlost
for(i in 2:n) {
  X[i,] <- euler(t, X[i-1,], f, h)
}
plot(t, X[,1], col='red', type='line')

XRK2 <- X
for(i in 2:n) {
  XRK2[i,] <- RK2(t, XRK2[i-1,], f, h)
}
lines(t, XRK2[,1], col='blue', type='line') # Modrý řešič je lepší







f <- function(t, X) {
  # X <- c(X[1], X[2]) <- c(x, v)
  return(c(X[2], -X[1]-0.1*X[2])) # Změna v kódu zde
}
euler <- function(x, y, f, h) {
  return(y+h*f(x,y))
}
RK4 <- function(x, y, f, h) { # Metoda Runge-Kutta (čtvrtého řádu)
  hhalf <- 0.5 * h
  k1 <- f(x,y)
  k2 <- f(x+hhalf, y+hhalf*k1)
  k3 <- f(x+hhalf, y+hhalf*k2)
  k4 <- f(x+h, y+h*k3)
  return(y+h*(k1+2*(k2+k3)+k4)/6)
}

tMax <- 100
n <- 1000
h <- tMax / n
t <- seq(0, tMax, h)
n <- n + 1

X <- matrix(0, nrow = n, ncol = 2)
X[1, 1] <- 100 # výchylka
X[1, 2] <- 0 # rychlost
for(i in 2:n) {
  X[i,] <- euler(t, X[i-1,], f, h)
}
plot(t, X[,1], col='red', type='line')

XRK2 <- X
for(i in 2:n) {
  XRK2[i,] <- RK2(t, XRK2[i-1,], f, h)
}
lines(t, XRK2[,1], col='blue', type='line') # Modrý řešič je lepší


XRK4 <- X
for(i in 2:n) {
  XRK4[i,] <- RK4(t, XRK4[i-1,], f, h)
}
lines(t, XRK4[,1], col='purple', type='line') # Fialový by měl být ještě lepší(?)

# Analytické řešení??????
plot(function(x) 100*exp(-0.1*x)*cos(x), X[,1], col='green', type='line', add=TRUE)