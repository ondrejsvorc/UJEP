# 📝 **Shrnutí statistických cvičení v R**

---

## **1. Hlavní témata (s vysvětlením)**

### **1.1 Popisná statistika**

#### **Statistiky polohy**
- **Průměr (`mean`)**: Součet všech hodnot vydělený jejich počtem. Používá se pro měření střední hodnoty dat.
  - **Nevýhoda:** Citlivý na odlehlé hodnoty.
  - **Příklad:**
  ```r
  mean(c(1, 2, 3, 4, 100)) # Výsledek je silně ovlivněn hodnotou 100
  ```

- **Medián (`median`)**: Prostřední hodnota dat seřazených podle velikosti. Je robustní vůči odlehlým hodnotám.
  - **Příklad:**
  ```r
  median(c(1, 2, 3, 4, 100)) # Medián není ovlivněn hodnotou 100
  ```

- **Modus (`Mode`)**: Nejčastěji se vyskytující hodnota v datové sadě.
  - **Unimodální rozdělení:** Má jeden výrazný vrchol.
    ```r
    Mode(c(1, 2, 2, 3, 4)) # Výsledek: 2
    ```
  - **Bimodální rozdělení:** Má dva výrazné vrcholy.
    ```r
    Mode(c(1, 2, 2, 4, 4, 5)) # Výsledek: 2, 4
    ```
  - **Multimodální (polymodální) rozdělení:** Má více než dva vrcholy.
    ```r
    Mode(c(1, 2, 2, 4, 4, 5, 5)) # Výsledek: 2, 4, 5
    ```
  - **Amodální rozdělení:** Nemá žádný výrazný vrchol (rovnoměrné rozdělení).
    ```r
    Mode(c(1, 2, 3, 4, 5)) # Žádná hodnota nemá vyšší frekvenci
    ```

- **Useknutý průměr (`mean(trim = 0.1)`)**: Průměr vypočtený po odstranění krajních hodnot na obou stranách. Parametr `trim` udává procento odstraněných hodnot.
  - **Příklad:**
  ```r
  mean(c(1, 2, 3, 4, 100), trim = 0.2) # Odstraní 20 % krajních hodnot
  ```

#### **Statistiky variability**
- **Směrodatná odchylka (`sd`)**: Měří průměrnou vzdálenost hodnot od průměru.
  - **Příklad:**
  ```r
  sd(c(1, 2, 3, 4, 5))
  ```

- **Rozptyl (`var`)**: Druhá mocnina směrodatné odchylky.
  - **Příklad:**
  ```r
  var(c(1, 2, 3, 4, 5))
  ```

- **Mezikvartilové rozpětí (`IQR`)**: Rozdíl mezi třetím (Q3) a prvním (Q1) kvartilem. Odolné vůči odlehlým hodnotám.
  - **Příklad:**
  ```r
  IQR(c(1, 2, 3, 4, 5))
  ```

- **MAD (`mad`)**: Medián absolutních odchylek od mediánu. Robustní statistika variability.
  - **Příklad:**
  ```r
  mad(c(1, 2, 3, 4, 5))
  ```

#### **Statistiky tvaru rozdělení**
- **Šikmost (`Skew`)**: Měří asymetrii dat.
  - Symetrická: Šikmost = 0
  - Pravostranná: Šikmost > 0
  - Levostranná: Šikmost < 0
  - **Příklad:**
  ```r
  Skew(c(1, 2, 3, 4, 10))
  ```

- **Špičatost (`Kurt`)**: Měří, jak moc jsou data špičatá ve srovnání s normálním rozdělením.
  - **Příklad:**
  ```r
  Kurt(c(1, 2, 3, 4, 5))
  ```

### **1.2 Frekvenční rozdělení a kumulativní četnosti**
- **Absolutní četnost (`table`)**: Počet výskytů hodnot.
- **Relativní četnost (`prop.table`)**: Podíl jednotlivých hodnot.
- **Kumulativní četnost (`cumsum`)**: Postupný součet četností.
- **Příklad:**
```r
x <- c('A', 'B', 'A', 'C', 'B', 'A')
tab <- table(x)
kac <- cumsum(tab)
krc <- cumsum(prop.table(tab))
data.frame(cbind("n(i)"=tab,"N(i)"=kac,"f(i)"=prop.table(tab),"F(i)"=krc))
```

### **1.3 Jak interpretovat data**
1. Zjistit absolutní a relativní četnosti.
2. Prohlédnout si histogram a boxplot.
3. Identifikovat polohu (průměr, medián, modus).
4. Vyhodnotit variabilitu (směrodatná odchylka, IQR, MAD).
5. Zkontrolovat symetrii (šikmost, špičatost).
6. Analyzovat odlehlá pozorování.

### **1.4 Odlehlá pozorování**
- **Identifikace odlehlých hodnot pomocí boxplotu:**
```r
boxplot(tuk, range=3)
```
- **Doporučení:** Analyzovat odlehlé hodnoty individuálně.

### **1.5 Testování hypotéz**
- **Nulová hypotéza (H₀):** Data nemají významný rozdíl.
- **Alternativní hypotéza (H₁):** Data mají významný rozdíl.
- **Hladina významnosti (α):** Typicky 0.05.
- **Příklad:**
```r
t.test(mpg ~ am, data = mtcars)
```

---

### **1.4 Grafické metody**
- **Histogram:** Zobrazuje rozdělení kvantitativních dat.
  ```r
  hist(vyska)
  ```
- **Krabicový graf (Boxplot):** Zobrazuje medián, kvartily a odlehlé hodnoty.
  ```r
  boxplot(vyska)
  ```
- **Sloupcový graf:** Vhodný pro kategorické proměnné.
  ```r
  barplot(table(x))
  ```
- **Koláčový graf:** Pro zobrazení relativních četností.
  ```r
  pie(table(x))
  ```
- **Bodový graf (Scatter plot):** Zobrazuje vztah mezi dvěma kvantitativními proměnnými.
  ```r
  plot(vyska ~ hmotnost)
  ```
- **Frekvenční polygon:** Alternativa histogramu.
  ```r
  plot(table(vyska), type='l')
  ```

## **3. Příklad analýzy datového souboru**
```r
summary(mtcars)
mean(mtcars$mpg)
sd(mtcars$mpg)
IQR(mtcars$mpg)
Skew(mtcars$mpg)
Kurt(mtcars$mpg)
plot(mtcars$mpg ~ mtcars$hp)
abline(lm(mtcars$mpg ~ mtcars$hp), col='red')
t.test(mtcars$mpg, mu=20)
```

## **2. Kompletní seznam statistických příkazů**

```r
mean(x) # Průměr hodnot vektoru x
median(x) # Medián hodnot vektoru x
Mode(x) # Nejčastěji se vyskytující hodnota vektoru x
sd(x) # Směrodatná odchylka
var(x) # Rozptyl hodnot
IQR(x) # Mezikvartilové rozpětí
mad(x) # Medián absolutních odchylek
Skew(x) # Šikmost rozdělení
Kurt(x) # Špičatost rozdělení
t.test(x) # T-test pro testování hypotéz
shapiro.test(x) # Shapiro-Wilk test normality
table(x) # Absolutní četnosti
prop.table(table(x)) # Relativní četnosti
cumsum(table(x)) # Kumulativní absolutní četnosti
hist(x) # Histogram
boxplot(x) # Krabicový graf
barplot(table(x), col=2:5, main='Sloupcový graf') # Sloupcový graf
pie(table(x), col=2:5, main='Koláčový graf') # Koláčový graf
plot(x, y, main='Scatter plot', xlab='X', ylab='Y', pch=20, col='blue') # Bodový graf
abline(lm(y ~ x), col='red', lwd=2) # Přidání lineární regrese
grid() # Přidání mřížky do grafu
legend('topright', legend=c('Data', 'Lineární regrese'), col=c('blue', 'red'), pch=c(20, NA), lty=c(NA, 1), lwd=c(NA, 2)) # Legenda
lines(lowess(x, y), col='green', lwd=2) # LOESS křivka
quantile(x, probs=c(0.25, 0.75)) # Kvartily
fivenum(x) # Pětinásobné shrnutí (minimum, Q1, medián, Q3, maximum)
CoefVar(x) # Variabilita
```

---