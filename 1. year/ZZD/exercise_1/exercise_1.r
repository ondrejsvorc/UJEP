# https://moodle.prf.ujep.cz/pluginfile.php/26361/mod_resource/content/1/cvi%C4%8Den%C3%AD1.nb.html

rm(list = ls())

# 1.
x <- 2 + 0i
print(sqrt(cos(x + 3 / 2 * pi)))

# 2.
base <- 4
to_calc <- 2 * x**2 + 10
print(log(to_calc, base))

# 3.
text <- "copak zlaTOvláska ale JMELí!"
text <- tolower(text)
# Přepisuje podřetězec na 1. znaku
substring(text, 1, 1) <- toupper(substring(text, 1, 1))
text <- gsub("zlatovláska", "Zlatovláska", text)
print(text)

# 4.
# m <- matrix(runif(9, 3, 3))
# print(m)
# print(t(m)) # transponovaná matice
# print(det(m)) # determininant
# print(diag(m)) # jednotková matice
# diag(m) <- 0 # vynulování diagonály mka

# 5.
pole1 <- c(1, 2, 3)
pole2 <- c(3, 4, 5)
print(sum(pole1 * pole2))

# 6.
pole <- pole2 - pole1
print(sqrt(sum(pole * pole)))

# 7.
a <- 0:10
print(a / 5 - 1)

# 8.
cisla <- -10:10
vyber <- cisla[cisla < 0 & cisla %% 2 != 0 | cisla >= 0 & cisla %% 2 == 0]
print(vyber)

# 9.
text <- "Well, there's egg and bacon; egg sausage and bacon; egg and spam;
egg bacon and spam; egg bacon sausage and spam; spam bacon sausage and spam;
spam egg spam spam bacon and spam;
spam sausage spam spam bacon spam tomato and spam;"

slova <- scan(text = text, what = " ")
faktor <- factor(slova)
print(summary(faktor))

# Permutace
print(sample(1:10))

# Permutace 100 náhodných čísel (s opakováním, protože replace=TRUE)
print(table(sample(1:10, 100, replace = TRUE)))