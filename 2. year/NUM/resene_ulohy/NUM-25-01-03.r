# https://physics.ujep.cz/~jskvor/NME/NUM-25-01-03.pdf

# De facto:
# x = p
# y = a = a(p)

# Data
p <- c(0.100, 0.200, 0.280, 0.410, 0.980, 1.390, 1.930, 2.750, 3.010, 3.510)
a <- c(0.089, 0.127, 0.144, 0.163, 0.189, 0.198, 0.206, 0.208, 0.209, 0.210)

# Chceme určit, pro jaké am a pro jaké b budou výstupy funkce a(p) vycházet tak, jako je v datech.
# Resp. jaké am a b jsem musel do a(p) dosadit, aby vyšly ty data.

# Parametry určené analyticky (WolframAlpha)
am <- 11303 / 51000
b  <- 255 / 38

# a = ..., resp. a(p) = ...
amodel <- function(p, am, b) {
  am * (b * p) / (1 + b * p)
}

# hodnoty modelu v měřených bodech
a_model <- round(amodel(p, am, b), 3)

# Lagrangeova interpolace
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

p_interp <- seq(min(p), max(p), length.out = 1000)

a_lagrange <- numeric(length(p_interp ))
for (i in 1:length(p_interp)) {
  a_lagrange[i] <- Lagrange(p_interp[i], p, a)
}

plot(p, a, pch = 21, col = "red",bg  = NA, xlab = "p [MPa]", ylab = "a")
lines(p_interp, a_lagrange, col = "blue")
lines(p_interp, amodel(p_interp , am, b), col = "green")