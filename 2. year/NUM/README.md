## Numerické metody

### Užitečné odkazy
- [StudySession - Numerical Methods Course (YouTube)](https://www.youtube.com/watch?v=IOR31yN43Kg&list=PLDea8VeK4MUTOBXLpvx_WKtVrMkojEh52)
- [marty-thane/num (GitHub)](https://github.com/marty-thane/num)
- [markuss23/ujep (GitHub)](https://github.com/markuss23/ujep/tree/main/num)
- [~jskvor/NME](https://physics.ujep.cz/~jskvor/NME/)
- [KopyTKG/KI-NUM](https://github.com/KopyTKG/KI-NUM)

### Metoda půlení intervalu
- anglicky: bisection method
- též se nazývá bisekce
- slouží k nalezení řešení rovnice f(x) = 0 na intervalu <a, b>, pokud platí, že f(a) * f(b) < 0

#### Princip
1. Zkontroluj, že f(a) * f(b) < 0
2. Spočti střed intervalu c = (a + b) / 2
3. Vypočítej f(c) -> hodnotu funkce v bodě středu intervalu
4. Urči, ve které části intervalu leží kořen:
  - Pokud f(a) * f(c) < 0, nastav b = c
  - Pokud f(a) * f(c) >= 0, nastav a = c
5. Opakuj, dokud délka intervalu (b - a) není menší než zvolená přenost ε, nebo dokud není |f(c)| < ε

#### Příklad

a = 1
b = 2
f(a) = -2
f(b) = 5

Na levém konci je funkce záporná, na pravém kladná.
Jelikož je funkce spojitá, musí někde mezi těmito body projít nulou, jinak by se nemohla plynule změnit ze záporné na kladnou.
Když vezmeme c = (1 + 2) / 2 = 1.5, a pak spočítáme f(c) = f(1,5) = 0.1, pak f(c) má stejné znaménko jako f(a), a to znamená, že kořen leží mezi c a b, protože v této části se funkce mění ze záporné na kladnou.

```r
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
```

```r
# f(x) = 7x − 9
f <- function(x) { 7*x - 9 }

# interval ⟨1, 2⟩ a přesnost ε = 1e-6
root <- bisection(f, a = 1, b = 2, eps = 1e-6)

# root ≈ hodnota x, kde hledáme řešení rovnice f(x) = 0
print(root)

# f(x) = 0 -> f(root) ≈ 0
print(f(root))
```

#### Příklad zadání

Najděte numericky řešení rovnice x^3 - x - 1 = 0 na intervalu <1, 2> s přesností eps = 1e-6.

```r
f <- function(x) { x^3 - x - 1 }
root <- bisection(f, a = 1, b = 2, eps = 1e-6)
print(root)
print(f(root))
```

viz [METHODS.md](https://github.com/ondrejsvorc/UJEP/blob/main/2.%20year/NUM/METHODS.md)