# Lagrangeův interpolační polynom
# - Hledáme polynom, který přesně prochází danými body (x, y)

# Všechny řešení vedou ke stejnému výsledku jen v jiném tvaru (řešením pomocí těchto metod
# musí být vždy stejný polynom - graficky, když ho vykreslíme, musí být vždy stejný)

# Funkce lagrange počítá hodnotu Lagrangeova polynomu v bodě t
lagrange <- function(t, x, y) {
  n <- length(x)  # Počet bodů
  suma <- 0  # Začneme s nulovou sumou, P(t) = 0
  
  # Pro každý bod i v množině [x, y] spočítáme součin L(i) a přispějeme do sumy
  for (i in 1:n) {
    nasobic <- 1  # Začínáme s L(i) = 1
    # Pro každý jiný bod než i vypočítáme násobič na základě vzdáleností
    for (j in 1:n) {
      if (j != i) {
        nasobic <- nasobic * (t - x[j]) / (x[i] - x[j])
      }
    }
    # Přidáme do sumy součin y[i] * L(i)
    suma <- suma + y[i] * nasobic
  }
  
  return(suma)  # Vracíme hodnotu polynomu P(t)
}

# Funkce vandermonde využívá Vandermondeovu matici k nalezení koeficientů interpolace
vandermonde <- function(x, y) {
  n <- length(x)  # Počet bodů
  A <- matrix(1, nrow=n, ncol=n)  # Inicializujeme matici s jedničkami v prvním sloupci
  
  # Naplníme matici mocninami x: každý další sloupec je násobek předchozího
  for (j in 2:n) {
    A[, j] <- A[, j-1] * x  # Mocniny x: druhý sloupec jsou hodnoty x, třetí x^2 atd.
  }
  
  # Řešíme soustavu rovnic A * koef = y, abychom našli koeficienty polynomu
  return(solve(A, y))  # Vracíme koeficienty výsledného polynomu
}

# Funkce horner používá Hornerovo schéma pro efektivní vyhodnocení polynomu
horner <- function(x, coef) {
  n <- length(coef)  # Počet koeficientů
  res <- coef[n]  # Začneme s posledním koeficientem (nejvyšší stupeň polynomu)
  
  # V každém kroku spočítáme polynom postupně podle Hornerova schématu
  for (i in (n-1):1) {
    res <- res * x + coef[i]  # res = res * x + další koeficient
  }
  
  return(res)  # Vracíme hodnotu polynomu
}

newtonPolCoef <- function(x, y) {
  n <- length(x)
  coef <- numeric(n)
  coef[1] <- y[1]
  if (n > 1) {
    for (i in 2:n) {
      suma <- 0
      nasobic <- 1
      for (j in 1:(i-1)) {
        suma <- suma + coef[j] * nasobic
        nasobic <- nasobic*(x[i]-x[j])
      }
      coef[i] <- (y[i] - suma) / nasobic
    }
  }
  return(coef)
}
newtonPolValue <- function(t, coef, x) {
  n <- length(coef)
  res <- coef[n]
  for (i in (n-1):1) {
    res <- res * (t-x[i])+coef[i]
  }
  return(res)
}

# Generování množiny bodů [x, y]
n <- 10  # Počet bodů
a <- 0  # Dolní mez intervalu
b <- 2*pi  # Horní mez intervalu
x <- seq(a, b, length.out=n)  # Rovnoměrně rozmístěné body x
y <- sin(x)  # Body y jsou hodnoty sinusové funkce (mohou být libovolné)

# Zobrazíme body (x, y), které chceme proložit polynomem
plot(x, y, col='red', ylim=c(-1, 1), main="Lagrange vs Vandermonde vs Newton")  # Červené body

# Hodnoty pro vyhodnocení polynomu v intervalu [a, b]
t <- seq(a, b, by=0.01)

# Nakreslíme Lagrangeův interpolační polynom (modrá křivka)
lines(t, sapply(t, lagrange, x=x, y=y), col='blue')

# Koeficienty polynomu z Vandermondeovy matice
coefficients <- vandermonde(x, y)

# Nakreslíme polynom pomocí koeficientů z Vandermondeovy matice (zelená křivka)
lines(t, horner(t, coefficients), col='green')

# Koeficienty Newtonova interpolačního polynomu
newtonCoefficients <- newtonPolCoef(x, y)

# Nakreslíme Newtonův interpolační polynom (fialová křivka)
lines(t, sapply(t, newtonPolValue, coef=newtonCoefficients, x=x), col='purple')

# Legenda pro porovnání
legend("topright", legend=c("Lagrange", "Vandermonde", "Newton"), col=c("blue", "green", "purple"), lty=1)