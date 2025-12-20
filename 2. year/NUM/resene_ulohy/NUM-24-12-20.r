# 1. Klasifikace úlohy
# – lineární diferenciální rovnice prvního řádu s integrálovou podmínkou

# NUMERICKÉ ŘEŠENÍ

# y'(x) = y(x) - x
f <- function(x, y) { y - x }

eulerStep <- function(f, x, y, h) {
  return(y + h * f(x,y))
}

bisection <- function(f, a, b, eps) {
  # f   : function f(x)
  # a,b : numeric, interval endpoints
  # eps : numeric, required accuracy
  
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

integral_condition_residual <- function(y0) {
  x_start <- 0
  x_end <- 1
  n <- 500
  h <- (x_end - x_start) / n
  
  x <- x_start
  y <- y0
  
  integral <- 0
  
  for (i in 1:n) {
    y_next <- eulerStep(ode_rhs, x, y, h)
    
    integral <- integral + (y + y_next) / 2 * h
    
    y <- y_next
    x <- x + h
  }
  
  return(integral - 2)
}

y0 <- bisection(f = F, a = -5, b = 5, eps = 1e-6)

x_start <- 0
x_end   <- 1
n       <- 500
h       <- (x_end - x_start) / n

x <- numeric(n + 1)
y <- numeric(n + 1)

x[1] <- x_start
y[1] <- y0

for (i in 1:n) {
  y[i + 1] <- eulerStep(y0, x[i], y[i], h)
  x[i + 1] <- x[i] + h
}

plot(
  x, y,
  type = "l",
  lwd = 2,
  xlab = "x",
  ylab = "y(x)",
  main = "Numerické řešení ODE s integrální podmínkou"
)






# ANALYTICKÉ ŘEŠENÍ



# y′(x) − y(x) + x = 0      / +y(x) 
# y′(x) + x = y             / -x
# y′(x) = y(x) - x

# Diferenciální rovnice neurčuje funkci, ale říká, jak má růst nebo klesat.
# když y′(x) > 0 -> funkce v daném bodě roste
# když y′(x) < 0 -> funkce v daném bodě klesá
# když y′(x) = 0 -> funkce v daném bodě neroste ani neklesá
# Čím větší absolutní hodnota, tím prudší změna (buď roste nebo klesá rychleji).

# Když budeme konkrétní, tak pro diferenciální rovnici y′(x) = y(x) - x platí, že:
# když y(x) > x -> derivace výjde kladná, tedy funkce v daném bodě roste
# když y(x) < x -> derivace výjde záporná, tedy funkce v daném bodě klesá
# když y(x) = x -> derivace výjde nulová, tedy funkce v daném bodě ani neroste, ani neklesá

# 2. Vypočítám diferenciální rovnici

# 2a. Vypočítám homogenní rovnici (=pravou stranu položíme rovnou nule)

# y′(x) − y(x) = 0          / +y(x)
# y′(x) = y(x)

# Jaká funkce má tu vlastnost, že její derivace je zase ona sama (y′(x) = y(x))?
# Exponenciální funkce e^x

# y_h = C * e^x

# – lineární diferenciální rovnice prvního řádu s integrálovou podmínkou

# y′(x) − y(x) + x = 0      / +y(x) 
# y′(x) + x = y             / -x
# y′(x) = y(x) - x

# Diferenciální rovnice neurčuje funkci, ale říká, jak má růst nebo klesat.
# když y′(x) > 0 -> funkce v daném bodě roste
# když y′(x) < 0 -> funkce v daném bodě klesá
# když y′(x) = 0 -> funkce v daném bodě neroste ani neklesá
# Čím větší absolutní hodnota, tím prudší změna (buď roste nebo klesá rychleji).

# Když budeme konkrétní, tak pro diferenciální rovnici y′(x) = y(x) - x platí, že:
# když y(x) > x -> derivace výjde kladná, tedy funkce v daném bodě roste
# když y(x) < x -> derivace výjde záporná, tedy funkce v daném bodě klesá
# když y(x) = x -> derivace výjde nulová, tedy funkce v daném bodě ani neroste, ani neklesá

# 2. Vypočítám diferenciální rovnici

# 2a. Vypočítám homogenní rovnici (=pravou stranu položím rovnou nule)

# y′(x) − y(x) = 0          / +y(x)
# y′(x) = y(x)

# Jaká funkce má tu vlastnost, že její derivace je zase ona sama (y′(x) = y(x))?
# Exponenciální funkce e^x

# y_h = C * e^x

# 2b. Vypočítám parciální řešení
# =nyní hledáme jedno konkrétní řešení nehomogenní rovnice
# =partikulární řešení je jedna konkrétní funkce, která tu rovnici splňuje.

# y′(x) − y(x) + x = 0      / -x
# y′(x) − y(x)  = -x
# ...

# 3. Získám obecné řešení spojením homogenního a parciálního řešení (WolframAlpha)
# y(x) = C * e^x + x + 1

# 4. Vypočítám konstantu C dosazením obecného řešení do integrálové podmínky
# Integral od 0 do y(x)dx = 2
# Integral od 0 do (C * e^x + x + 1)dx = 2

# Rozdělím na 3 integrály
# 1. Integral od 0 do (e^x)dx = ?     --> e - 1
# 2. Integral od 0 do (x)dx = ?       --> 1 / 2
# 3. Integral od 0 do (1)dx = ?       --> 1

# Výsledky dosadíme:
# C * (e − 1) + 1 / 2​+ 1 = 2
# C * (e − 1) + 3 / 2 = 2
# C * (e - 1) = 1 / 2
# C = 1 / 2(e - 1)

# 5. Výsledná funkce
# y(x) = e^x / 2(e - 1) + x + 1


 