# U zápočtu se bude ptát na to, jak to funguje.
# https://physics.ujep.cz/~jskvor/NME/

# Gaussova eliminace
# Gaussova eliminace s pivotováním
# LU dekompozice

Gauss <- function(A, b)
{
  # Rozměry matice
  n <- length(b)
  
  # Rozšířená matice
  Ab <- cbind(A, b)
  
  # Přímý chod (procházíme všechny sloupce matice A kromě posledního)
  for (k in 1:(n - 1))
  {
    # Provádí operace na řádcích pod hlavní diagonálou
    for (i in (k + 1):n)
    {
      c <- -Ab[i, k] / Ab[k, k]
      j <- (k + 1):(n + 1)
      Ab[i, j] <- Ab[i, j] + c * Ab[k, j]
    }
  }
  
  # Zpětný chod
  x <- b
  x[n] <- Ab[n, n + 1] / Ab[n, n]
  for (i in (n - 1):1) 
  {
    j <- (i + 1):n
    x[i] <- (Ab[i, n + 1] - sum(Ab[i, j] * x[j])) / Ab[i, i]
  }
  
  return(x)
}

GaussPivot <- function(A, b)
{
  # Rozměry matice
  n <- length(b)
  
  # Rozšířená matice
  Ab <- cbind(A, b)
  
  # Přímý chod (procházíme všechny sloupce matice A kromě posledního)
  for (k in 1:(n - 1))
  {
    pivot <- which.max(abs(Ab[(k:n), k])) + (k - 1)
    if (pivot != k) {
      j <- k:(n + 1)
      row <- Ab[k, j]
      Ab[k, j] <- Ab[pivot, j]
      Ab[pivot, j] <- row
    }
    
    # Provádí operace na řádcích pod hlavní diagonálou
    for (i in (k + 1):n)
    {
      c <- -Ab[i, k] / Ab[k, k]
      j <- (k + 1):(n + 1)
      Ab[i, j] <- Ab[i, j] + c * Ab[k, j]
    }
  }
  
  # Zpětný chod
  x <- b
  x[n] <- Ab[n, n + 1] / Ab[n, n]
  for (i in (n - 1):1) 
  {
    j <- (i + 1):n
    x[i] <- (Ab[i, n + 1] - sum(Ab[i, j] * x[j])) / Ab[i, i]
  }
  
  return(x)
}

# LU Dekompozice
GaussLU <- function(A)
{
  n <- nrow(A)
  for (k in 1:(n - 1))
  {
    # Provádí operace na řádcích pod hlavní diagonálou
    for (i in (k + 1):n)
    {
      c <- -Ab[i, k] / A[k, k]
      j <- (k + 1):(n)
      A[i, k] <- c
      A[i, j] <- A[i, j] + c * A[k, j]
    }
  }
  
  return(A)
}

# Matice
A <- matrix(runif(n*n), n, n)

# Vektor pravých stran
b <- runif(n)

print(Gauss(A, b))
print(GaussPivot(A, b))

LU <- GaussLU(A)
L <- LU
U <- LU
L[upper.tri(LU)] <- 0
diag(U) <-  1
L[lower.tri(LU)] <- 0
# ?lower.tri

# Pro kontrolu
#print(solve(A, b))