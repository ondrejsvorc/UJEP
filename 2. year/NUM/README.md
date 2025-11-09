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