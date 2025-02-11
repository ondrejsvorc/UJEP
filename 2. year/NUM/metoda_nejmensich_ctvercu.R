# Least Squares Method
# - k zápočtu pochopit

# https://user.mendelu.cz/marik/prez/mnc-cz.pdf
# http://www.dusanpolansky.cz/stripky/ctverce.html

# Pro přímku:
# snažíme se stanovit koeficienty a, b tak, aby přímka y = ax + b ležela co nejblíže bodům z měření

# Funkce, kterou aproximuju má tvar a0+a1*x+a2x*x^2, proto jeho bází je 1 x x^2
# phi = fí = báze
phi <- function(x) {
  return (c(1, x, x*x))
}
coef <- function(x, y, phi) {
  M <- sapply(x, phi)
  A <- M %*% t(M) 
  b <- c(M %*% y)
  return(solve(A,b))
}

x <- seq(0, pi, 0.1)
y <- sin(x)
plot(x, y)

a <- coef(x, y, phi)

# x sampled = x vzorkovaná
xs <- seq(0, pi, 0.0001)
lines(xs, a %*% sapply(xs, phi), col = 'red')