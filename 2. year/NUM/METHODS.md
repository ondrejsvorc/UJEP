## Numerické metody

### Řešení rovnice

#### Metoda půlení intervalů (bisekce)

```r
Bisection <- function(f, a, b, eps) {
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

  (a + b) / 2
}
```

---

### Řešení soustavy rovnic

#### Gaussova metoda

```r
Gauss <- function(A, b) {
  n <- length(b)
  A <- cbind(A, b)

  for (k in 1:(n - 1)) {
    for (i in (k + 1):n) {
      c <- -A[i, k] / A[k, k]
      for (j in (k + 1):(n + 1)) {
        A[i, j] <- A[i, j] + c * A[k, j]
      }
    }
  }

  x <- A[, n + 1]
  x[n] <- x[n] / A[n, n]

  for (i in (n - 1):1) {
    x[i] <- (x[i] - sum(A[i, (i + 1):n] * x[(i + 1):n])) / A[i, i]
  }

  x
}
```

---

#### Gaussova metoda s pivotací

```r
GaussPivot <- function(A, b) {
  Ab <- cbind(A, b)
  n <- length(b)

  for (k in 1:(n - 1)) {
    pivot <- which.max(abs(Ab[k:n, k])) + k - 1
    if (pivot != k) {
      Ab[c(k, pivot), ] <- Ab[c(pivot, k), ]
    }

    for (i in (k + 1):n) {
      m <- Ab[i, k] / Ab[k, k]
      Ab[i, (k + 1):(n + 1)] <- Ab[i, (k + 1):(n + 1)] - m * Ab[k, (k + 1):(n + 1)]
    }
  }

  x <- numeric(n)
  x[n] <- Ab[n, n + 1] / Ab[n, n]

  for (i in (n - 1):1) {
    x[i] <- (Ab[i, n + 1] - sum(Ab[i, (i + 1):n] * x[(i + 1):n])) / Ab[i, i]
  }

  x
}
```

---

### Aproximace

#### Metoda nejmenších čtverců

```r
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
```

---

### Interpolace

#### Lagrangeův interpolační polynom

```r
Lagrange <- function(t, x, y) {
  n <- length(x)
  sum <- 0

  for (i in 1:n) {
    prod <- 1
    for (j in 1:n) {
      if (j != i) {
        prod <- prod * (t - x[j]) / (x[i] - x[j])
      }
    }
    sum <- sum + y[i] * prod
  }

  sum
}
```

---

### Interpolace po částech

#### Hermitův kubický interpolační spline

```r
HS <- function(x, xi, yi, hi, di, dip, deltai) {
  t <- x - xi

  a <- yi
  b <- di
  c <- (3 * deltai - 2 * di - dip) / hi
  d <- (dip + di - 2 * deltai) / (hi * hi)

  ((d * t + c) * t + b) * t + a
}
```

---

### Určitý integrál

#### Lichoběžníkové pravidlo

```r
Trapezoid <- function(f, a, b, n) {
  h <- (b - a) / n
  integral <- 0

  for (i in 0:(n - 1)) {
    x_left  <- a + i * h
    x_right <- a + (i + 1) * h
    integral <- integral + (h / 2) * (f(x_left) + f(x_right))
  }

  integral
}
```

---

### Diferenciální rovnice

#### Eulerova metoda

```r
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
```

---

### Derivace

#### Dopředná derivace

```r
DerivativeForward <- function(x, f, h) {
  (f(x + h) - f(x)) / h
}
```

---

#### Centrální derivace

```r
DerivativeCentral <- function(x, f, h) {
  (f(x + h) - f(x - h)) / (2 * h)
}
```

