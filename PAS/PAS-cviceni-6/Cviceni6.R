# Každý test vypočítá testovou statistiku a p-value (p-hodnotu)

# Fisherův exaktní test


# nactete databazi Policie.RData
load("Policie.rdata")

library(DescTools)
# aktivuje knihovny

#######################
### Hodnoceni normality
# Graficke i ciselne testy normality

# Ohodnotte normalitu promenne vaha
vaha <- Policie$weight

# histogram
# - máme malo pozorování
# - nemá normální rozdělení
hist(vaha, main="Histogram",xlab="Vaha v kg",ylab="Absolutni cetnosti",
    col="skyblue",border="darkblue")
  # s hustotou normalniho rozdeleni 
  hist(vaha ,main="Histogram",xlab="Vaha v kg",ylab="Hustota",
    col="skyblue",border="darkblue",freq=F)
    # je treba vykreslit histogram prepocteny na hustotu
  lines(x<-seq(50,140,by=0.2),dnorm(x,mean(vaha),sd(vaha)),col=2)

# Graficky test: Q-Q plot - Quantile Comparison plot
PlotQQ(vaha, pch=19)
    # body lezi priblizne na primce, data maji priblizne normalni rozdeleni

# Pro "rozumne" velka data (od 50 do cca 300 pozorovani)
#   je mozne vypocitat i ciselny test normality
# Testujeme
#   H0: data maji normalni rozdeleni 
#   vs.
#   H1: data nemaji normalni rozdeleni
shapiro.test(vaha)
  # p-hodnota 0.2045 > alfa 0.05 => H0 nezamitame
  # data maji priblizne normalni rozdeleni
  LillieTest(vaha)
  AndersonDarlingTest(vaha,"pnorm",mean=mean(vaha),sd=sd(vaha))
    # testu existuje vice
  
## Otestujte normalitu promenne fat (procento tuku), a promenne pulse (puls).
tuk <- Policie$fat
# Histogram je sešikmený (má pravostranný chvost)
hist(tuk, main="Histogram",xlab="Tuk",ylab="Absolutni cetnosti",
     col="skyblue",border="darkblue")
# Q-Q-Plot 
PlotQQ(tuk, pch=19)
shapiro.test(tuk)
# p-value je 0.03 (3 %), tedy p-value <= alfa
# zamítáme H0, platí H1 (tedy data nemají normální rozdělení)

puls <- Policie$pulse
hist(puls, main="Histogram",xlab="Puls",ylab="Absolutni cetnosti",
     col="skyblue",border="darkblue")
PlotQQ(puls, pch=19)
shapiro.test(puls)
# p-value je přibližně 29,99 %, tedy p-value > alfa => nezamítáme H0 a neprokázal jsem platnost alternativní hypotézy, tudíž mají přibližně normální rozdělení

#############################
### Vztah dvou ciselnych promennych 

## Jaky je vztah mezi vahou a vyskou?
# Graficky pomoci bodoveho grafu
vaha <- Policie$weight
vyska <- Policie$height
# Kdyby byl mezi proměnnými vztah, viděli bychom nějaký trend (roustoucí, klesající)
# Zde menší přímá lineární závislost
plot(vaha ~ vyska, pch=19,main="Rozptylovy graf",xlab="Vyska v cm",ylab="Vaha v kg")
  # Co z grafu vidite?
  abline(lm(vaha ~ vyska), col=2, lwd=2)
    # je mozne prikreslit i primku linearni zavislosti
    # lm = lineární model
  
# Korelacni koeficient
# 0.6428311 - střední závislost
cor(vaha, vyska, use="complete.obs")
  # co o zavislosti vite?

## Souvisi spolu pulse a vaha?
puls <- Policie$pulse

# Rozptylovy graf
plot(puls ~ vaha, pch=19,main="Rozptylovy graf",xlab="Vaha v kg",ylab="Puls bpm")
  abline(lm(puls ~ vaha), col=2, lwd=2)

# Korelacni koeficient
# Nepřímá slabá závislost
cor(puls, vaha, use="complete.obs")
  # je tato zavislost vyznamna? nevíme, vede to na test o nezávislosti

## Test o vyznamnosti korelacniho koeficientu (test o linearni zavislosti)
# Testovane hypotezy
#   H0: promenne spolu linearne nesouvisi (cor = 0) - tím je myšlena ta jedna možnost = lineárně nezávislé znamená, že cor = 0 (žádná jiná možnost není)
#   vs. 
#   H1: promenne spolu souvisi (cor != 0) - tím je myšleno více možností = cokoliv jen ne nula
cor.test(puls, vaha)
  # t = -1.7518 (testová statistika)
  # p-hodnota 0.0862 > alfa 0.05 => H0 nezamitam
  # Na hladine vyznamnosti 5% se neprokazala souvislost mezi vahou a pulsem.
  #   A co na hladine vyznamnosti 10%? V ten moment bychom zamítli nulovou hypotézu, protože p-hodnota 0.0862 <= alfa 0.1

# Predpokladem pouziti Pearsonova korelacniho koeficientu je 
#   normalita obou promennych - mame? ano

## Souvisi spolu vyska a procento tuku?
## I když tuk nemá normální rozdělení, tak to zkusíme
#   H0: promenne spolu linearne nesouvisi (cor = 0)
#   vs. 
#   H1: promenne spolu souvisi (cor != 0)
plot(vyska ~ tuk, pch=19,main="Rozptylovy graf",xlab="Tuk v %",ylab="Vyska v cm")
abline(lm(vyska ~ tuk), col=2, lwd=2)
cor(vyska, tuk, use="complete.obs")

# 0.008 (0.8 %) <= alfa (5 %) -> zamítáme H0, platí H1
# cor = 0.3680092 - ano, proměnné spolu souvisí (závislost je slabá, ale statisticky významná)
cor.test(vyska, tuk)

## Souvisi spolu reakcni doba a procento tuku?
## Testy nezjišťují kauzalitu, která je v přírodě, ale jestli se proměnné chovají podobně
## Tedy procento tuku by spíše souviselo s váhou
reakcni_doba <- Policie$react
plot(reakcni_doba ~ tuk, pch=19,main="Rozptylovy graf",xlab="Tuk v %",ylab="Reakční doba")
abline(lm(reakcni_doba ~ tuk), col=2, lwd=2)
cor(reakcni_doba, tuk, use="complete.obs")

# 0.9099 (90 %) > alfa (5 %) -> nezamítáme H0
# cor = 0.016 - proměnné spolu nesouvisí
cor.test(reakcni_doba, tuk)
cor.test(reakcni_doba, tuk, method="spearman")

#####################################
### Priklady na pravdepodobnost

### Diskretni rozdeleni
## - hodnoty jsou jasně oddělitelné
## Binomicke rozdeleni: n - pocet pokusu, p - pst uspechu
# pbinom(k,n,p) - distribucni funkce (když se ptám na více výsledků)
# dbinom(k,n,p) - pravdepodobnostni funcke (když se ptám pouze na 1 výsledek)

# Pravdepodobnostni funkce k prikladu 2
n <- 13
p <- 1-120/375
dbinom(6, n, p) # ~ 6 %

# Pravděpodobnost jednotlivých výsledků
# Nejvíce pravděpodobná možnost je, že 4 zaspí
plot(0:13,dbinom(0:13,13,120/375),col="green3",type="h", 
     main="Pravdepodobnostni funkce Bi(13,0.32)",
     xlab="Pocet uspechu",ylab="p(x)")
points(0:13,dbinom(0:13,13,120/375),col="green3",pch=19)

# Distribucni funkce k prikladu 2
sum(dbinom(7:13, n, 120/375))
1 - pbinom(6, n, 120/375)

pbinom(2, n, 120/375)


pbinom(0, n, 1-120/375)

plot(pbinom(0:13,13,120/375), type = "s", col="purple",
     main = "Distribucni funkce Bi(13,0.32)",
     xlab = "Pocet uspechu", ylab = "F(x)")

# Priklady 1, 7

## Hypergeometricke rozdeleni: w - pocet bilych kouli v osudi, b - pocet cernych kouli v osudi
#   n - pocet kouli tazenych z osudi
# phyper(k,w,b,n) - distribucni funkce
# dhyper(k,w,b,n) - pravdepodobnostni funcke

# Pravdepodobnostni funkce k prikladu 5
plot(5:20,dhyper(5:20,35,15,20),col="green3",type="h", 
     main="Pravdepodobnostni funkce Hy(35,15,20)",
     xlab="Pocet uspechu",ylab="p(x)")
points(5:20,dhyper(5:20,35,15,20),col="green3",pch=19)

# Distribucni funkce k prikladu 5
plot(5:20,phyper(5:20,35,15,20), type = "s", col="purple",
     main = "Distribucni funkce Hy(35,15,20)",
     xlab = "Pocet uspechu", ylab = "F(x)")

x <- 15       # Počet spolehlivých žadatelů ve výběru
m <- 35       # Počet spolehlivých žadatelů v populaci
n <- 15       # Počet nespolehlivých žadatelů v populaci
k <- 20       # Velikost výběru
p <- dhyper(x, m, n, k)
p


# Priklad 1
dbinom(3, 4, 0.85) # s vracením
dhyper(3, 850, 150, 4) # bez vracení (1000 * 0.85 = 850, 1000 * 0.15 = 150)

# Priklady 16, 21


## Geometricke rozdeleni: p - pravdepodobnost uspechu, k - pocet neuspechu pred prvnim uspechem
# pgeom(k,p) - distribucni funkce
# dgeom(k,p) - pravdepodobnostni funcke

# Pravdepodobnostni funkce k prikladu 3
plot(0:10,dgeom(0:10,0.65),col="green3",type="h", 
     main="Pravdepodobnostni funkce Hy(0.65)",
     xlab="Pocet uspechu",ylab="p(x)")
points(0:10,dgeom(0:10,0.65),col="green3",pch=19)

# Distribucni funkce k prikladu 3
plot(0:10,pgeom(0:10,0.65), type = "s", col="purple",
     main = "Distribucni funkce Ge(0.65)",
     xlab = "Pocet uspechu", ylab = "F(x)")

# Priklady 4

## Poissonovo rozdeleni: lambda - stredni hodnota
# ppois(k,lambda) - distribucni funkce
# dpois(k,lambda) - pravdepodobnostni funcke

# Pravdepodobnostni funkce k prikladu 6
plot(0:15,dpois(0:15,5),col="green3",type="h", 
     main="Pravdepodobnostni funkce Po(5)",
     xlab="Pocet uspechu",ylab="p(x)")
points(0:15,dpois(0:15,5),col="green3",pch=19)

# Distribucni funkce k prikladu 6
plot(0:15,ppois(0:15,5), type = "s", col="purple",
     main = "Distribucni funkce Po(5)",
     xlab = "Pocet uspechu", ylab = "F(x)")

# Priklady 14

## Negativni binomicke rozdeleni: n - pocet uspechu, p - pst uspechu
# pnbinom(k,n,p) - distribucni funkce
# dnbinom(k,n,p) - pravdepodobnostni funcke


