# 📝 **Shrnutí statistických cvičení v R**

---

## **1. Hlavní témata**

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

# Rozdělení pravděpodobnosti

## Pravděpodobnostní funkce
- Vyjadřuje pravděpodobnost, že náhodná proměnná nabyde právě dané hodnoty x (=)
- Příklad: Pokud hodíme kostkou, jaká bude pravděpodobnost, že padne právě číslo 4 (x = 4)

## Distribuční funkce
- Vyjadřuje pravděpodobnost, že náhodná proměnná nabyde menší nebo rovno dané hodnoty x (<=)
- Příklad: Pokud hodíme kostkou, jaká bude pravděpodobnost, že padne číslo menší nebo rovno 4 (x <= 4)

## Pravděpodobností vs Distribuční funkce
- distribuční funkce není nic jiného než suma pravděpodobnostních funkcí
- P(x ≤ 3) = P(x = 0) + P(x = 1) + P(x = 2) + P(x = 3)
- čili, jakákoliv úloha, kterou lze vyřešit pomocí distribuční funkce lze zároveň převést na řešení pomocí pravděpodobnostních funkcí
- distribuční funkce P(x ≤ 3) vlastně vypočítává pravděpodobnost, že čtyřka padne 0, 1, 2 nebo 3 krát
- výstup distribuční funkce se též někdy nazývá kumulativní pravděpodobnost (což nyní dává smysl - kumuluje výsledky pravděpodobnostních funkcí, které postupně sčítá)

```r
# Pravděpodobnost, že když hodím kostkou 10krát, tak padne např. čtyřka maximálně 3krát (binomické rozdělení).

k = 3
n = 10
p = 1/6

# Vypočítáno distribuční funkcí
# Výsledek: 0.9302722
pbinom(q = k, size = n, prob = p)

# Vypočítáno sumou/součtem pravděpodobnostních funkcí
# Výsledek: 0.9302722
dbinom(x = 0, size = n, prob = p) + dbinom(x = 1, size = n, prob = p) + dbinom(x = 2, size = n, prob = p) + dbinom(x = 3, size = n, prob = p)

# Zkrácený zápis případu výše
# Výsledek: 0.9302722
sum(dbinom(x = 0:k, size = n, prob = p))
```

# Diskrétní rozdělení
- mají integer hodnoty (diskrétní)
- Příklad: Počet mincí, počet událostí, počet úspěchů v sérii pokusů

## Binomické rozdělení
- Určuje pravděpodobnost že nastane určitý počet úspěchů v určitém počtu pokusů, kde každý pokus má stejnou pravděpodobnost úspěchu
- Rozdělení si můžeme zapamatovat dle začátku názvu "bi", které naznačuje, že mohou nastat pouze dva případy (úspěch/neúspěch)  

### Parametry
`k` = Počet úspěchů, který nás zajímá  
`n` = Celkový počet pokusů  
`p` = Pravděpodobnost úspěchu v jednom pokusu (0 ≤ p ≤ 1)  

### Funkce v R
`dbinom(k, n, p)` = Vrací pravděpodobnost, že náhodná proměnná s binomickým rozdělením nabude přesně k úspěchů při n pokusech, kde každý pokus má pravděpodobnost úspěchu p  
`pbinom(k, n, p)` = Vrací pravděpodobnost, že náhodná proměnná s binomickým rozdělením nabude maximálně k úspěchů (≤ k) při n pokusech, kde každý pokus má pravděpodobnost úspěchu p  

### Příklad (`dbinom`)
Jaká je šance, že při 10 hodech kostkou padne šestka třikrát?
```r
k <- 3    # Počet úspěchů (třikrát šestka)
n <- 10   # Celkový počet pokusů (hodů)
p <- 1/6  # Pravděpodobnost šestky v jednom pokusu (hodu)

pravdepodobnost <- dbinom(k, n, p) # Pravděpodobnostní funkce
print(pravdepodobnost) # 0.1550454
```
Pravděpodobnost, že při 10 hodech kostkou padne šestka přesně třikrát, je přibližně 15,5 %.

### Příklad (`pbinom`)
Jaká je pravděpodobnost, že při 10 hodech kostkou padne šestka nejvýše třikrát?

```r
k <- 3    # Nejvýše třikrát šestka
n <- 10   # Celkový počet pokusů (hodů)
p <- 1/6  # Pravděpodobnost šestky v jednom pokusu (hodu)

pravdepodobnost <- pbinom(k, n, p) # Distribuční funkce
print(pravdepodobnost) # 0.9302722
```
Pravděpodobnost, že při 10 hodech kostkou padne šestka nejvýše třikrát, je přibližně 93,0 %

## **Poissonovo rozdělení**  
- Určuje pravděpodobnost, že nastane k událostí v pevně stanoveném časovém úseku nebo prostoru, pokud je průměrná frekvence výskytu známá.

### Parametry 
- `k` = Počet událostí, který nás zajímá
- `λ (lambda)` = Průměrný počet událostí za jednotku času nebo prostoru (λ > 0)

### Funkce v R:
- `dpois(k, lambda)` = Vrací pravděpodobnost, že nastane přesně k událostí při průměrné frekvenci výskytu **λ**
- `ppois(k, lambda)` = Vrací pravděpodobnost, že nastane nejvýše k událostí při průměrné frekvenci výskytu **λ**


## Příklad (`dpois`)  
Jaká je pravděpodobnost, že určitým bodem na silnici projede za hodinu přesně 20 aut, pokud průměrně projede 15 aut?

```r
k <- 20       # Počet aut (přesně 20)
lambda <- 15  # Průměrný počet aut za hodinu

pravdepodobnost <- dpois(k, lambda) # Pravděpodobnostní funkce
print(pravdepodobnost) # 0.0516
```
Pravděpodobnost, že určitým bodem projede přesně 20 aut za hodinu, je přibližně 5,2 %.

## Příklad (`ppois`)  
Jaká je pravděpodobnost, že určitým bodem na silnici projede za hodinu nejvýše 20 aut, pokud průměrně projede 15 aut?

```r
k <- 20       # Nejvýše 20 aut
lambda <- 15  # Průměrný počet aut za hodinu

pravdepodobnost <- ppois(k, lambda) # Distribuční funkce
print(pravdepodobnost) # 0.8686
```
Pravděpodobnost, že určitým bodem projede nejvýše 20 aut za hodinu, je přibližně 86,9 %.

## Hypergeometrické rozdělení
- Určuje pravděpodobnost, že při **výběru n prvků bez vracení** z celkového souboru bude právě **k prvků požadovaného typu**.

### Parametry
- `k` = Počet úspěchů, který nás zajímá ve výběru.  
- `w` = Počet prvků v kolekci, jejichž výběr považujeme za úspěch.  
- `b` = Počet prvků v kolekci, jejichž výběr považujeme za neúspěch.  
- `n` = Počet vybraných prvků.

### Funkce v R

- `dhyper(k, w, b, n)` = Vrací pravděpodobnost, že při **výběru n prvků** bude přesně **k úspěchů** z celkového souboru s **w úspěšnými a b neúspěšnými prvky**.  
- `phyper(k, w, b, n)` = Vrací pravděpodobnost, že při **výběru n prvků** bude **nejvýše k úspěchů** z celkového souboru s **w úspěšnými a b neúspěšnými prvky**.  

## Příklad (`dhyper`)
Jaká je pravděpodobnost, že při výběru 5 karet z balíčku, kde je 15 modrých, 20 červených a 25 zelených karet, budou přesně 3 karty modré?

```r
k <- 3        # Počet modrých karet (přesně 3)
w <- 15       # Počet modrých karet v balíčku
b <- 20 + 25  # Počet červených a zelených karet (45)
n <- 5        # Počet vybraných karet

pravdepodobnost <- dhyper(k, w, b, n) # Pravděpodobnostní funkce
print(pravdepodobnost) # 0.2279
```
Pravděpodobnost, že mezi 5 vybranými kartami budou přesně 3 modré karty, je přibližně 22,8 %.

## Příklad (`phyper`)
Jaká je pravděpodobnost, že při výběru 5 karet z balíčku, kde je 15 modrých, 20 červených a 25 zelených karet, budou nejvýše 3 karty modré?

```r
k <- 3        # Nejvýše 3 modré karty
w <- 15       # Počet modrých karet v balíčku
b <- 20 + 25  # Počet červených a zelených karet (45)
n <- 5        # Počet vybraných karet

pravdepodobnost <- phyper(k, w, b, n) # Distribuční funkce
print(pravdepodobnost) # 0.8901
```
Pravděpodobnost, že mezi 5 vybranými kartami budou nejvýše 3 modré karty, je přibližně 89,0 %.

## Příklad (`1 - phyper`)
Jaká je pravděpodobnost, že při výběru 5 karet z balíčku, kde je 15 modrých, 20 červených a 25 zelených karet, budou více než 3 karty modré?

```r
k <- 3        # Více než 3 modré karty
w <- 15       # Počet modrých karet v balíčku
b <- 20 + 25  # Počet červených a zelených karet (45)
n <- 5        # Počet vybraných karet

pravdepodobnost <- 1 - phyper(k, w, b, n) # Doplněk distribuční funkce
print(pravdepodobnost) # 0.1099
```
Pravděpodobnost, že mezi 5 vybranými kartami budou více než 3 modré karty, je přibližně 10,9 %.

## Geometrické rozdělení
- Určuje pravděpodobnost, že **první úspěch nastane po k neúspěšných pokusech** v sérii nezávislých pokusů, kde každý pokus má stejnou pravděpodobnost úspěchu **p**.  

### Parametry  
- `k` = Počet neúspěšných pokusů před úspěšným pokusem (k ≥ 0)  
- `p` = Pravděpodobnost úspěchu v jednom pokusu (0 ≤ p ≤ 1) 

### Funkce v R  
- `dgeom(k, p)` = Vrací pravděpodobnost, že první úspěch nastane `přesně po k neúspěšných pokusech`.  
- `pgeom(k, p)` = Vrací pravděpodobnost, že první úspěch nastane `nejvýše po k neúspěšných pokusech`.  

## Příklad (`dgeom`)  
Jaká je pravděpodobnost, že při házení mincí padne hlava poprvé při 8. pokusu (po 7 neúspěšných pokusech), pokud je pravděpodobnost úspěchu v jednom hodu 50 %?

```r
k <- 7       # 7 neúspěšných pokusů před úspěchem
p <- 0.50    # Pravděpodobnost úspěchu (hlava) v jednom hodu

pravdepodobnost <- dgeom(k, p) # Pravděpodobnostní funkce
print(pravdepodobnost) # 0.0078
```
Pravděpodobnost, že hlava padne poprvé při 8. pokusu, je přibližně 0,78 %.

## Příklad (`pgeom`)
Jaká je pravděpodobnost, že při házení mincí padne hlava nejvýše při 8. pokusu (po 7 nebo méně neúspěšných pokusech), pokud je pravděpodobnost úspěchu v jednom hodu 50 %?

```r
k <- 7       # Nejvýše 7 neúspěšných pokusů
p <- 0.50    # Pravděpodobnost úspěchu (hlava) v jednom hodu

pravdepodobnost <- pgeom(k, p) # Distribuční funkce
print(pravdepodobnost) # 0.9922
```
Pravděpodobnost, že hlava padne nejvýše při 8. pokusu, je přibližně 99,2 %.

## Negativní (Pascalovo) binomické rozdělení
- Určuje pravděpodobnost, že **nastane k neúspěchů před dosažením n úspěchů** v sérii nezávislých pokusů, kde každý pokus má pravděpodobnost úspěchu **p**.  
- Je zobecněním geometrického rozdělení pro **více než jeden úspěch**.  

### Parametry  
- `k` = Počet neúspěchů, které nás zajímají před dosažením `n` úspěchů (k ≥ 0)
- `n` = Počet požadovaných úspěchů (n > 0)
- `p` = Pravděpodobnost úspěchu v jednom pokusu (0 ≤ p ≤ 1) 

### Funkce v R  
- `dnbinom(k, n, p)` = Vrací pravděpodobnost, že před dosažením **n úspěchů** nastane **přesně k neúspěchů**.  
- `pnbinom(k, n, p)` = Vrací pravděpodobnost, že před dosažením **n úspěchů** nastane **nejvýše k neúspěchů**.  
- `1 - pnbinom(k, n, p)` = Vrací pravděpodobnost, že před dosažením **n úspěchů** nastane **více než k neúspěchů**.  

---

## Příklad (`dnbinom`)  
Jaká je pravděpodobnost, že parta tří lidí vykrade banku přesně 5krát, než budou všichni tři chyceni, pokud je pravděpodobnost zatčení při každé loupeži 40 %?

```r
k <- 5       # Počet neúspěšných pokusů (5 úspěšných loupeží)
n <- 3       # Počet úspěchů (3 zatčení)
p <- 0.40    # Pravděpodobnost úspěchu (zatčení při loupeži)

pravdepodobnost <- dnbinom(k, n, p) # Pravděpodobnostní funkce
print(pravdepodobnost) # 0.0731
```
Pravděpodobnost, že parta vykrade banku přesně 5krát předtím, než budou všichni chyceni, je přibližně 7,3 %.

## Příklad (`pnbinom`)
Jaká je pravděpodobnost, že parta tří lidí vykrade banku nejvýše 5krát předtím, než budou všichni tři chyceni, pokud je pravděpodobnost zatčení při každé loupeži 40 %?

```r
k <- 5       # Nejvýše 5 úspěšných loupeží
n <- 3       # Počet úspěchů (3 zatčení)
p <- 0.40    # Pravděpodobnost úspěchu (zatčení při loupeži)

pravdepodobnost <- pnbinom(k, n, p) # Distribuční funkce
print(pravdepodobnost) # 0.8813
```
Pravděpodobnost, že parta vykrade banku nejvýše 5krát předtím, než budou všichni chyceni, je přibližně 88,1 %.

## Příklad (`1 - pnbinom`)
Jaká je pravděpodobnost, že parta tří lidí vykrade banku alespoň 6krát předtím, než budou všichni tři chyceni, pokud je pravděpodobnost zatčení při každé loupeži 40 %?

```r
k <- 5       # Více než 5 úspěšných loupeží
n <- 3       # Počet úspěchů (3 zatčení)
p <- 0.40    # Pravděpodobnost úspěchu (zatčení při loupeži)

pravdepodobnost <- 1 - pnbinom(k, n, p) # Doplněk distribuční funkce
print(pravdepodobnost) # 0.1187
```
Pravděpodobnost, že parta vykrade banku alespoň 6krát předtím, než budou všichni chyceni, je přibližně 11,9 %.

# Spojitá rozdělení
- Popisují spojité (nepřetržité) hodnoty
- Mezi dvěma libovolnými hodnotami existuje nekonečně mnoho dalších hodnot
- Hodnoty mohou být reálná čísla
- **Pravděpodobnost, že náhodná proměnná nabude přesně jedné hodnoty, je 0**
- Místo toho se pravděpodobnost vyjadřuje jako plocha pod křivkou hustoty pravděpodobnosti v určitém intervalu
- Spojitá rozdělení vyžadují jasně definovaný typ rozdělení (např. normální, exponenciální) a všechny potřebné parametry (střední hodnota, rozptyl)

## Normální rozdělení` 
- Popisuje rozložení hodnot náhodné proměnné kolem střední hodnoty (mean) se specifickým rozptylem (variance).

### Parametry  
- `μ` = Střední hodnota (např. průměrná výška)  
- `σ²` = Rozptyl (variance)
- `σ` = Směrodatná odchylka (standard deviation)

### Funkce v R
- `pnorm(x, mean, sd)` = Vrací pravděpodobnost, že náhodná proměnná bude **menší nebo rovna x**
- `1 - pnorm(x, mean, sd)` = Vrací pravděpodobnost, že náhodná proměnná bude **větší než x**

---

## Příklad (`pnorm`)
Jaká je pravděpodobnost, že náhodně vybraný muž je menší než 170 cm, pokud je průměrná výška mužů 180 cm a rozptyl je 49 cm²?

```r
mean <- 180    # Střední hodnota
sd <- sqrt(49) # Směrodatná odchylka (odmocnina z rozptylu)
x <- 170       # Hledaná výška

pravdepodobnost <- pnorm(x, mean, sd) # Distribuční funkce
print(pravdepodobnost) # 0.1587
```
Pravděpodobnost, že náhodně vybraný muž je menší než 170 cm, je přibližně 15,9 %.

## Příklad (`1 - pnorm`)
Jaká je pravděpodobnost, že náhodně vybraný muž bude vyšší než průměrný hráč NBA (195 cm), pokud je průměrná výška mužů 180 cm a rozptyl je 49 cm²?

```r
mean <- 180    # Střední hodnota
sd <- sqrt(49) # Směrodatná odchylka (odmocnina z rozptylu)
x <- 195       # Hledaná výška

pravdepodobnost <- 1 - pnorm(x, mean, sd) # Doplněk distribuční funkce
print(pravdepodobnost) # 0.0668
```
Pravděpodobnost, že náhodně vybraný muž bude vyšší než 195 cm, je přibližně 6,7 %.

## Lognormální rozdělení 
- Popisuje hodnoty, jejichž **logaritmus je normálně rozdělen**.  
- Hodí se pro modelování dat, která jsou **kladná a mají výrazně pravostranné rozložení** (např. příjmy, ceny akcií). 

### Parametry  
- `μ` = Střední hodnota logaritmované proměnné  
- `σ` = Směrodatná odchylka logaritmované proměnné  

### Funkce v R
- `dlnorm(x, meanlog, sdlog)` = Vrací pravděpodobnost hustoty pro hodnotu `x` s danými parametry  
- `plnorm(x, meanlog, sdlog)` = Vrací pravděpodobnost, že náhodná proměnná bude **menší nebo rovna x**  
- `qlnorm(p, meanlog, sdlog)` = Vrací hodnotu odpovídající pravděpodobnosti `p` 
- `rlnorm(n, meanlog, sdlog)` = Generuje `n` náhodných hodnot z lognormálního rozdělení  

### Příklad (`plnorm`)
Jaká je pravděpodobnost, že cena akcie nepřekročí 50 jednotek, pokud logaritmus ceny sleduje normální rozdělení se střední hodnotou 3 a směrodatnou odchylkou 0.5?

```r
meanlog <- 3  # Střední hodnota logaritmované proměnné
sdlog <- 0.5  # Směrodatná odchylka logaritmované proměnné
x <- 50       # Hledaná hodnota

pravdepodobnost <- plnorm(x, meanlog, sdlog) # Distribuční funkce
print(pravdepodobnost) # 0.6915
```
Pravděpodobnost, že cena akcie nepřekročí 50 jednotek, je přibližně 69,2 %.

## Exponenciální rozdělení  
- Popisuje **čas nebo vzdálenost mezi dvěma po sobě jdoucími událostmi**, které nastávají **nezávisle a konstantní průměrnou rychlostí**. 

### Parametry
- `λ (lambda)` = Intenzita události *(počet událostí za jednotku času nebo prostoru, λ > 0)*  

### Funkce v R  
- `dexp(x, rate)` = Vrací **hustotu pravděpodobnosti** pro hodnotu `x` s parametrem `λ`
- `pexp(x, rate)` = Vrací pravděpodobnost, že náhodná proměnná bude **menší nebo rovna x** 
- `qexp(p, rate)` = Vrací hodnotu, která odpovídá pravděpodobnosti `p` *(kvantil)*
- `rexp(n, rate)` = Generuje `n` náhodných hodnot z exponenciálního rozdělení

## Příklad (`pexp`)  
Jaká je pravděpodobnost, že zákazník přijde do `5 minut`, pokud je průměrná frekvence příchodů `1 zákazník za 4 minuty` (λ = 0.25)?

```r
rate <- 0.25  # Intenzita události (1/4 zákazníci za minutu)
x <- 5        # Hledaný čas

pravdepodobnost <- pexp(x, rate) # Distribuční funkce
print(pravdepodobnost) # 0.7135
```