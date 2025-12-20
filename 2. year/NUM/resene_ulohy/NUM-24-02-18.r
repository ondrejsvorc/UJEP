# https://physics.ujep.cz/~jskvor/NME/NUM-24-02-18.pdf

# 1.

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

bisection <- function(f, a, b, eps) {
  fa <- f(a)
  fb <- f(b)
  if (fa * fb >= 0) {
    stop("Function does not change sign on the interval")
  }
  while (abs(b - a) > eps) {
    c  <- (a + b) / 2
    fc <- f(c)
    if (fa * fc < 0) {
      b  <- c
      fb <- fc
    } else {
      a  <- c
      fa <- fc
    }
  }
  return((a + b) / 2)
}

inner_integral <- function(alpha) {
  f <- function(x) { exp(-alpha * x) * sin(x) }
  trapezoid(f, 0, 2*pi, n = 500)
}

outer_integral <- function(p) {
  g <- function(alpha) inner_integral(alpha)
  trapezoid(g, 0, p, n = 200)
}

F <- function(p) {
  outer_integral(p) - 1.31848
}

p <- bisection(F, a = 0, b = 20, eps = 1e-6)
print(p) # 10.1513









# 2.

# i = řádek matice
# j = sloupec matice
# y je v tomto kontextu jakoby 'b'
#  - zadání matice je většinou Ax = b (kde A je matice a b vektor pravých stran)
#  - zde je to zadáno jako Ax = y, tak to budeme respektovat

# 1. dílčí úloha

gaussPivot <- function(A,b) {
  Ab <- cbind(A, b)
  n <- length(b)
  for(k in 1:(n-1)) {
    pivot <- which.max(abs(Ab[k:n,k])) + k - 1
    if(pivot != k){
      j <- k:(n+1)
      pom <- Ab[k,j]
      Ab[k,j] <- Ab[pivot,j]
      Ab[pivot,j] <- pom
    }
    for (i in (k+1):n) {
      j <- (k+1):(n+1)
      nasobek <- Ab[i,k] / Ab[k,k]
      Ab[i,j] <- Ab[i,j] - nasobek*Ab[k,j]
    }
  }
  x <- b
  x[n] <- Ab[n,n+1] / Ab[n,n]
  for(i in (n-1):1){
    j <- (i+1):n
    x[i] <- (Ab[i,n+1]-sum(Ab[i,j]*x[j]))/Ab[i,i]
  }
  return(x)
}

trapezoidal_rule <- function(f,a,b,n)
{
  h<-(b-a)/n #sirka intervalu
  x<- a+(b-a)*(0:(n))/n # n+1 bodu
  
  suma<-(f(x[1])+f(x[n+1]))/2
  
  if(n>1){
    suma<-suma+sum(f(x[2:n])) 
    return(suma*h)
  }
  return(sum(f(x))*h)
}

n <- 10
A <- matrix(0, n, n)

for (i in 1:n) {
  for (j in 1:n) {
    A[i, j] <- cos((i - 1) * j) - j
  }
}

y <- numeric(n)
for (i in 1:n) {
  y[i] <- sin(i)
}

x <- gaussPivot(A, y)
print(x)

# 2. dílčí úloha

#Lagrangeova interpolace
Lagrange<-function(t, x, y){ #t je naše konkrétní x, které budeme dosazovat, x je vektor x1, x2, ..., xn
  n<-length(x)
  soucet<-0
  for(i in 1:n){
    soucin<-1
    for(j in 1:n){
      if(j!=i) {
        soucin<-soucin*(t-x[j])/(x[i]-x[j])
      }
    }
    soucet<-soucet + y[i]*soucin
  }
  return(soucet)
}


# 2.

# i = řádek matice
# j = sloupec matice
# y je v tomto kontextu jakoby 'b'
#  - zadání matice je většinou Ax = b (kde A je matice a b vektor pravých stran)
#  - zde je to zadáno jako Ax = y, tak to budeme respektovat

# 1. dílčí úloha

gaussPivot <- function(A,b) {
  Ab <- cbind(A, b)
  n <- length(b)
  for(k in 1:(n-1)) {
    pivot <- which.max(abs(Ab[k:n,k])) + k - 1
    if(pivot != k){
      j <- k:(n+1)
      pom <- Ab[k,j]
      Ab[k,j] <- Ab[pivot,j]
      Ab[pivot,j] <- pom
    }
    for (i in (k+1):n) {
      j <- (k+1):(n+1)
      nasobek <- Ab[i,k] / Ab[k,k]
      Ab[i,j] <- Ab[i,j] - nasobek*Ab[k,j]
    }
  }
  x <- b
  x[n] <- Ab[n,n+1] / Ab[n,n]
  for(i in (n-1):1){
    j <- (i+1):n
    x[i] <- (Ab[i,n+1]-sum(Ab[i,j]*x[j]))/Ab[i,i]
  }
  return(x)
}

trapezoidal_rule <- function(f,a,b,n)
{
  h<-(b-a)/n #sirka intervalu
  x<- a+(b-a)*(0:(n))/n # n+1 bodu
  
  suma<-(f(x[1])+f(x[n+1]))/2
  
  if(n>1){
    suma<-suma+sum(f(x[2:n])) 
    return(suma*h)
  }
  return(sum(f(x))*h)
}

n <- 10
A <- matrix(0, n, n)

for (i in 1:n) {
  for (j in 1:n) {
    A[i, j] <- cos((i - 1) * j) - j
  }
}

y <- numeric(n)
for (i in 1:n) {
  y[i] <- sin(i)
}

x <- gaussPivot(A, y)
print(x)

# 2. dílčí úloha

Lagrange <- function(t, x, y){ #t je naše konkrétní x, které budeme dosazovat, x je vektor x1, x2, ..., xn
  n<-length(x)
  soucet<-0
  for(i in 1:n){
    soucin<-1
    for(j in 1:n){
      if(j!=i) {
        soucin<-soucin*(t-x[j])/(x[i]-x[j])
      }
    }
    soucet<-soucet + y[i]*soucin
  }
  return(soucet)
}

x_min <- min(x)
x_max <- max(x)

x_plot <- seq(x_min, x_max, length.out = 500)
p_values <- sapply(x_plot, Lagrange, x = x, y = y)

plot(x, y, pch = 21, col = "red", bg = NA, xlab = "x", ylab = "p(x)")
lines(x_plot, p_values, col = "blue", lwd = 2)
abline(h = 0, lty = 2)

bisection <- function(f, a, b, eps) {
  fa <- f(a)
  fb <- f(b)
  if (fa * fb >= 0) {
    stop("Function does not change sign on the interval")
  }
  while (abs(b - a) > eps) {
    c  <- (a + b) / 2
    fc <- f(c)
    if (fa * fc < 0) {
      b  <- c
      fb <- fc
    } else {
      a  <- c
      fa <- fc
    }
  }
  return((a + b) / 2)
}

sign_changes <- which(diff(sign(p_values)) != 0)

p_fun <- function(t) {
  Lagrange(t, x, y)
}

i <- sign_changes[1]
x_zero <- bisection(p_fun, x_plot[i], x_plot[i+1], 1e-6)
x_zero

integral <- trapezoidal_rule(p_fun, x_min, x_max, n = 500)
integral