GaussSeidelSVektorizaci <- function(A, b) {
  n <- length(b)
  x <- numeric(n)
  repeat {
    for (i in 1:n) {
      x[i] <- (b[i] - sum(A[i,]*x) + A[i, i] * x[i]) / A[i, i]
    }
    if (sum(abs(A%*%x - b)) < 0.00000000001) {
      return(x)
    }
  }
}

n <- 200
A <- matrix(runif(n*n, -1, 1), nrow = n)
# diag(A) <- diag(A) * 10*n
b <- runif(n, -1, 1)

x <- GaussSeidelSVektorizaci(A, b)
xsolve <- solve(A, b)
print(x - xsolve)




# Gauss-Seidel bez vektorizace
tb <- Sys.time()
x <- numeric(n)
for (k in 1:10) { # 10 iterací
  for (i in 1:n) { # suma i=1 do n
    soucet <- 0 # suma je nejdřív rovna 0
    for (j in 1:n) {
      if (j != i) {
        soucet <- soucet + A[i, j] * x[j] # zde se provádí suma od i=1 do n
      }
    }
    x[i] <- (b[i] - soucet) / A[i, i] # xk = (bk - suma od i=1 do n) / akk
  }
}
te <- Sys.time()
print(te-tb)
print(x)
# V tomhle kódu pravděpodobně:
# i je k ze vzorce
# j je i ze vzorce
solve(A, b)




# Gauss-Seidel s vektorizací
tb <- Sys.time()
x <- numeric(n)
for (k in 1:20) { # 20 iterací
  for (i in 1:n) { # suma i=1 do n
    x[i] <- (b[i] - sum(A[i,]*x) + A[i, i] * x[i]) / A[i, i]
  }
}
te <- Sys.time()
print(te-tb)
print(x)




# Jacobiho metoda s vektorizací
tb <- Sys.time()
x0 <- numeric(n)
for (k in 1:20) { # 20 iterací (čím více iterací, tím přesnější výsledek)
  for (i in 1:n) { # suma i=1 do n
    x[i] <- (b[i] - sum(A[i,]*x0) + A[i, i] * x0[i]) / A[i, i]
  }
  x0 <- x
}
te <- Sys.time()
print(te-tb)
print(x)





# LU dekompozice
n <- 10
a <- runif(n)
b <- runif(n-1)
c <- runif(n-1)
d <- runif(n)

# Přímý chod
u <- a
y <- d
for (i in 2:n) {
  koeficient <- -b[i-1]/u[i-1]
  u[i] <- a[i]+koeficient*c[i-1]
  y[i] <- d[i]+koeficient*y[i-1]
}
x <- y
x[n] <- y[n]/y[n]
for (i in (n-1):1) {
  x[i] <- (y[i] - c[i] * x[i+1] / u[i])
}
print(x)



































































































