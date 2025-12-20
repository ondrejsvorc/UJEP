tecna <- function(x0, fx0, derivace_fx0) {
  function(x) {
    fx0 + derivace_fx0 * (x - x0)
  }
}

koren_tecny <- function(x0, fx0, derivace_fx0) {
  x0 - fx0 / derivace_fx0
}

newton <- function(f, fd, x0, tol = 1e-8, max_iter = 100) {
  x <- x0
  
  for (i in seq_len(max_iter)) {
    fx <- f(x)
    dfx <- fd(x)
    
    if (abs(dfx) < .Machine$double.eps) {
      stop("Derivace je nulová.")
    }
    
    t <- tecna(x, fx, dfx)
    xn <- koren_tecny(x, fx, dfx)
    
    if (abs(xn - x) < tol) {
      return(xn)
    }
    
    x <- xn
  }
  
  stop("Nekonvergovalo.")
}

analyticky_sqrt2 <- function() {
  sqrt(2)
}

centralni_diference <- function(f, h = 1e-6) {
  function(x) {
    (f(x + h) - f(x - h)) / (2 * h)
  }
}

f  <- function(x) x^2 - 2
fd <- centralni_diference(f)

x_newton <- newton(f, fd, x0 = 1)
x_analyticky <- analyticky_sqrt2()

abs(x_newton - x_analyticky)




vykresli_newton <- function(f, fd, x0, kroky = 4,
                            xmin = -1, xmax = 2) {
  x_grid <- seq(xmin, xmax, length.out = 400)
  
  plot(x_grid, f(x_grid),
       type = "l", lwd = 2,
       ylab = "y", xlab = "x")
  abline(h = 0, col = "gray")
  
  x <- x0
  
  for (i in seq_len(kroky)) {
    fx  <- f(x)
    dfx <- fd(x)
    
    t <- tecna(x, fx, dfx)
    
    # tečna
    lines(x_grid, t(x_grid), lty = 2)
    
    # bod na funkci
    points(x, fx, pch = 19)
    
    # průsečík s osou x
    xn <- x - fx / dfx
    points(xn, 0, pch = 19)
    
    # svislá spojnice
    segments(xn, 0, xn, f(xn), lty = 3)
    
    x <- xn
  }
}

vykresli_newton(f, fd, x0 = 1.5, kroky = 4)




horner <- function(a, x) {
  y <- a[1]
  for (i in 2:length(a)) {
    y <- y * x + a[i]
  }
  y
}

# f(x) = x^2 − 3x + 2
a <- c(1, -3, 2)
x <- 5
horner(a, x)
5^2 - 3*5 + 2

