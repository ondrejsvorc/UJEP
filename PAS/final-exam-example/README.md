# Odpovědi na vzorový zápočtový test z předmětu PAS

## Vzorové zadání
- [PAS_2024-06-27.pdf](PAS_2024-06-27.pdf)

## Soubor k prvním 6 otázkám
- [Popisne_math.pdf](Popisne_math.pdf)

# Úlohy na interpretaci výstupu

## Otázka č. 1
Proměnná Rank má nejvíce asymetrické rozdělení. Na histogramu vidíme silné (pozitivní) pravostranné zešikmení. Šikmost pro proměnnou Rank vychází 1.9078128,
což je v absolutní hodnotě ta největší hodnota. Platí, že čím větší je absolutní hodnota šikmosti, tím je rozdělení více asymetrické. Špičatost pak vychází 3.36332229, jedná se o vysokou špičatost, nejvyšší ze všech proměnných.

![Histogram](https://github.com/user-attachments/assets/d4632ec7-7d28-4052-8e69-d29927902cb1)
![Šikmost](https://github.com/user-attachments/assets/a9868064-94ed-4c5d-a8c5-483acf51ccab)

## Otázka č. 2
Ano, průměrné skóre testů z matematiky a výsledek rozřazovacího testu spolu souvisí. Korelační koeficient vychází 0.5651063. Tj. středně silná (protože korelační koeficient nabývá hodnot na intervalu <-1, 1>, a jsme cca v polovině, tudíž středně silná) a přímá korelace. Přímá proto, že studenti s vyšším průměrným skóre z testů matematiky mají tendenci mít lepší výsledky v rozřazovacím testu, a platí to i naopak.

Nejprve mi přišlo zvláštní tvrdit, že to platí i naopak (pokud by to neplatilo, korelace by byla nepřímá) - tedy tvrdit že studenti s lepšími výsledky v rozřazovacím testu mají tendenci mít vyšší průměrné skóre z testů z matematiky. Zdá se zvláštní tvrdit, že vyšší skóre v rozřazovacím testu může „zpětně“ ovlivnit výsledky předchozích testů. Korelace neimplikuje příčinnost (kauzalitu), ale ukazuje na vzájemný vztah. Korelace pouze říká, že skóre spolu souvisí, nikoli že jedno způsobuje druhé.

Pokud mají studenti vyšší skóre v rozřazovacím testu (PlcmtScore), je pravděpodobné, že už dříve měli dobré dovednosti v matematice, které se projevily i v průběžných testech (GPAadj).
Naopak, pokud měli dobrou průpravu v matematice a dosáhli dobrého průměru (GPAadj), logicky lze očekávat, že i v rozřazovacím testu uspějí lépe.

Navíc, obě proměnné reflektují stejnou skrytou dovednost (a tou je matematika). To znamená, že korelace je způsobena společným faktorem, který ovlivňuje obě proměnné, a proto je vztah vzájemný.

Závěrem bych to shrnul asi takto: „Studenti s lepšími matematickými dovednostmi mají tendenci dosahovat lepších výsledků jak v rozřazovacím testu, tak v průběžných matematických testech.“

![Matice bodových grafů](https://github.com/user-attachments/assets/3f2d2f80-e48e-46ea-af8e-2fb81fc95c4f)
![Korelační matice](https://github.com/user-attachments/assets/b65d18ab-b822-4917-a408-d5e624acee5e)

## Otázka č. 3
80% kvantil (tj. taková známka, že 80 % studentů má tuto známku nebo lepší) vychází na známku B.
To znamená, že 80 % studentů dosáhlo úrovně B nebo lepší známky (A+, A, A−, B+)

80% kvantil zjistíme ze sloupce kumulativní rel. četnosti. V této tabulce vidíme, že kumulativní relativní četnost dosáhne a překročí 80 % u známky B (kde je 96.39 %). Tudíž 80% kvantilem je známka B.

Zde by si člověk mohl říci, že přeci v 80% kvantilu jsou pouze známky A+ (0.0241), A (0.3735), A- (0.5663), B+ (0.6868), Zdálo by se, že B (0.9639) už tam nepatří, nicméně tím, že mezi B+ (0.6868) a B (0.9639) není nic dalšího - v důsledku toho je B nejen 80% kvantilem, ale také např. 81% kvantilem, 82% kvantilem, 90% kvantilem atd.

![Kumulativní relativní četnosti](https://github.com/user-attachments/assets/0be348d3-f6a3-4d6f-b6d0-52fa4270a19b)

## Otázka č. 4
Obě proměnné (SATM a PlcmtScore) vykazují převážně symetrické (vyčteno z tvaru histogramů a také z údajů šikmost ≈ −0.17 až −0.21), unimodální rozdělení s mírnou tendencí k levé (negativní) šikmosti. Nejvýraznější vrchol (modus) se u SATM objevuje mezi 60–65, zatímco u PlcmtScore mezi 35–40, přičemž PlcmtScore má dlouhlejší pravý ocas (s hodnotami v pásmu 50–55).

Z hlediska variability:
SATM: variační koeficient (SD) kolem 6.64, IQR ≈ 9. PlcmtScore: SD ≈ 8.62, IQR ≈ 11.5. PlcmtScore tudíž vykazuje vyšší absolutní variabilitu (SD i IQR) a zároveň vyšší relativní variabilitu (koeficient variace 0.22 vs. 0.10). Minima i maxima obou rozdělení neobsahují extrémně vzdálené outliery, takže „vousy“ na boxplotu jsou sice mírně delší, ale nepřekračují standardní hranice. Celkově lze tedy říci, že PlcmtScore má větší rozptyl a pokrývá širší spektrum hodnot, zatímco SATM je poněkud soustředěnější kolem středních hodnot (kolem 60–65).

![SATM](https://github.com/user-attachments/assets/175507c8-c615-4f12-82ba-636f8009cea1)
![PlctmScore](https://github.com/user-attachments/assets/e82cf097-0a26-4066-b0cb-485eba18292e)

![SD a IQR](https://github.com/user-attachments/assets/de88c8b3-1cd2-47d1-9b31-a218c17d7e26)
![CoefVar](https://github.com/user-attachments/assets/70a88c6b-4648-4cfe-a6ca-35bf7d657c67)

![SATM Boxplot](https://github.com/user-attachments/assets/f82afd15-eb52-4ec6-b29a-a2392ba74803)
![PlctmScore Boxplot](https://github.com/user-attachments/assets/67fa3f1c-c904-4fc6-8952-f11aa5a10da2)

## Otázka č. 5
Z jádrové křivky hustoty i tvaru histogramu je patrné, že proměnná Size je vícemodální, a dle mého názoru vykazuje tři lokální maxima (tedy tři vrcholy neboli módy).

Zde si ale nejsem jistý odpovědí. Úkolem bylo interpretovat pouze z histogramu a z jádrového odhadu hustoty (vyznačená křivka). Nicméně, když jsem si zkusil zjistit módy pomocí příkazu (viz kód níže), výsledkem byly 2 módy, přičemž každý se nacházel právě 4krát. Hodnota 525 jako samostatný mód vizuálně neodpovídá histogramu. Je tedy pravděpodobné, že numerický výstup odráží detaily dat, které histogram agregoval do širšího intervalu.

Soudě z histogramu jako takového bych řekl, že proměnná Size je vícemodální, soudě z numerického výstupu, že je bimodální.

```r
Mode(Math$Size)
# [1] 350 525
# attr(,"freq")
# [1] 4
```

![Vícemodální](https://github.com/user-attachments/assets/0a21b895-04b5-4a92-b728-917bdfaef283)

## Otázka č. 6
Přibližně 81,93 % studentů (68 z 83) se řídilo doporučenou obtížností kurzu. Zbývajících 18,07 % studentů (15 z 83) doporučení nedodrželo. Z celkového počtu 83 studentů je vidět, že 27,71 % (23 z 83) zvolilo kurz těžší, než bylo doporučeno, zatímco pouze 2,41 % (2 z 83) si vybralo kurz lehčí, než se doporučovalo.

To ale není konzistentní. Logicky by počet studentů, kteří se odchýlili od doporučení (15), měl odpovídat součtu studentů, kteří zvolili těžší (23) nebo lehčí kurz (2), což dohromady činí 25 studentů.

Identifikoval jsem 24 nevalidních záznamů:
```r
# Student, který je označený, že splnil doporučení, nemůže mít zároveň zaznamenáno, že si zvolil příliš těžký, nebo příliš lehký kurz.
# Student, který je označený, že nesplnil doporučení, musí mít zároveň zaznamenáno, že si zvolil buď příliš těžký, nebo příliš lehký kurz.
problems <- rbind(
  Math[Math$RecTaken == 1 & (Math$TooHigh == 1 | Math$TooLow == 1), ],
  Math[Math$RecTaken == 0 & Math$TooHigh == 0 & Math$TooLow == 0, ]
)
print(problems)
```
Bez odstranění těchto záznamů, podle mého momentálního názoru, nelze jednoznačně zodpovědět na otázku. Některé záznamy spadají do vzájemně neslučitelných kategorií, ačkoli by měly být jednoznačně klasifikovány pouze v jedné z nich. Zkreslují tak statistiky.

# Úlohy pro popisnou a infereční statistiku

## Otázka č. 1
Průměrná velikost třídy je odhadnuta na 341,66 studentů. Na základě dat byl vypočítán 95% interval spolehlivosti (308,0; 375,3). To znamená, že s 95% pravděpodobností se skutečný průměrný počet studentů ve třídě nachází v tomto intervalu. Interval ukazuje míru nejistoty odhadu – čím užší je interval, tím přesnější je odhad. V našem případě interval naznačuje střední míru nejistoty, což může být způsobeno rozptylem dat nebo velikostí vzorku.

```r
velikosti_trid <- na.omit(Math$Size)
interval_spolehlivosti <- MeanCI(class_sizes, conf.level = 0.95)
print(interval_spolehlivosti)
```
![Interval spolehlivosti](https://github.com/user-attachments/assets/3fe3df7d-481b-4056-8f88-3274fa40dbcb)

## Otázka č. 2
Protože jsem identifikoval 24 nevalidních záznamů v Otázce č. 6 z minulé sekce a usoudil jsem, že zkreslují statistiky, nemá za mě
význam bez jejich odstranění tuto úlohu řešit.

## Otázka č. 3
Ano, proměnná GPAadj má odlehlá pozorování, konkrétně jsem identifikoval 3 unikátní hodnoty: 29, 30 a 31. K identifikaci odlehlých hodnot v proměnné GPAadj jsem zvolil krabicový graf (boxplot). Tento graf je vhodný, protože umožňuje rychlou vizuální detekci odlehlých hodnot, které se zobrazí jako samostatné body mimo "fousy" grafu. Následně jsem použil funkci Outlier() z knihovny DescTools, která numericky identifikovala odlehlé hodnoty na základě pravidla 1,5násobku IQR.

![Boxplot s odlehlými pozorováními](https://github.com/user-attachments/assets/6388e139-1d78-4760-aa56-607fca4ae93f)

```r
boxplot(Math$GPAadj,
        main = 'Krabicový graf proměnné GPAadj',
        xlab = 'Hodnoty GPA', 
        ylab = 'Dosažené GPA',
        col = 'lightgreen',
        border = 'black')

odlehla_pozorovani <- Outlier(Math$GPAadj, method = "boxplot", na.rm = TRUE)
print(odlehla_pozorovani)
```
![Odlehlé hodnoty](https://github.com/user-attachments/assets/1e9edb5c-b56e-4dac-9b00-898072802169)

# Úlohy na pravděpodobnost rozdělení

## Otázka č. 1
Jedná se o binomické rozdělení.

Důvody:
1) Máme pevný počet pokusů (n = 7, kde n je počet dní v týdnu)
2) Každý den můžeme hrníček považovat za nezávislý pokus.
3) Výběr hrníčku má pouze dva možné výsledky: žlutý hrníček (úspěch) nebo zelený hrníček (neúspěch).
4) Pravděpodobnost úspěchu (žlutý hrníček) je konstantní pro každý pokus (p = 5 / 8, kde 5 je počet žlutých hrníčků a 8 počet hrníčků celkem)

Odpověď: 0.475347 (47,53 %)

```r
n <- 7       # Počet dnů (pokusů)
p <- 5/8     # Pravděpodobnost úspěchu (žlutý hrníček)

# Pravděpodobnost alespoň 5 úspěchů
pravdepodobnost <- 1 - pbinom(4, size = n, prob = p)
cat("Pravděpodobnost, že budu pít ze žlutého hrníčku alespoň 5krát za týden, je:", pravdepodobnost, "\n")
```
## Otázka č. 2
a) P(x <= 84)  
b) 1 - P(x <= 129)  
c) P(x <= 125) - P(x <= 109)  
d) P(x <= 99)  

a) 0.1430612 (14,3 %)  
b) 0.02659757 (2,27 %)  
c) 0.2264628 (22,65 %)  
d) 0.2241298 (22,41 %)

```r
stredni_hodnota <- 100    # Střední hodnota IQ
smerodatna_odchylka <- 15 # Směrodatná odchylka IQ (odmocnina z uvedeného rozptylu 225)

# (a) Pravděpodobnost, že IQ bude nižší než 85
iq_pod_85 <- pnorm(84, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude nižší než 85, je:", iq_pod_85, "\n")

# (b) Pravděpodobnost, že IQ bude alespoň 130 (vstup do Mensy)
iq_nad_130 <- 1 - pnorm(129, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude alespoň 130, je:", iq_nad_130, "\n")

# (c) Pravděpodobnost, že IQ bude v rozsahu 110–125
iq_110_125 <- pnorm(125, mean = stredni_hodnota, sd = smerodatna_odchylka) - pnorm(109, mean = stredni_hodnota, sd = smerodatna_odchylka)
cat("Pravděpodobnost, že IQ bude mezi 110 a 125, je:", iq_110_125, "\n")

# (d) Pravděpodobnost, že dvě osoby budou mít obě IQ menší než 100
iq_pod_100 <- pnorm(99, mean = stredni_hodnota, sd = smerodatna_odchylka)
dve_osoby_pod_100 <- iq_pod_100 * iq_pod_100
cat("Pravděpodobnost, že dvě náhodné osoby budou mít obě IQ menší než 100, je:", dve_osoby_pod_100, "\n")
```