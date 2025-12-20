# https://physics.ujep.cz/~jskvor/NME/NUM-24-02-18.pdf

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