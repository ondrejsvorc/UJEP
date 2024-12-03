#############################
### Priklady na pravdepodobnost

### Diskretni rozdeleni
## Binomicke rozdeleni: n - pocet pokusu, p - pst uspechu
#   pocet uspechu v n-pokusech
# pbinom(k,n,p) - distribucni funkce
# dbinom(k,n,p) - pravdepodobnostni funcke
# stredni hodnota n*p
# rozptyl n*p*(1-p)

## Hypergeometricke rozdeleni: w - pocet bilych kouli v osudi, b - pocet cernych kouli v osudi
#   n - pocet kouli tazenych z osudi
#   pocet bilych kouli mezi n tazenymi
# phyper(k,w,b,n) - distribucni funkce
# dhyper(k,w,b,n) - pravdepodobnostni funcke
# stredni hodnota n*w/(w+b)
# rozptyl (n*w/(w+b))*(1-w/(w+b))*((w+b-n)/(w+b-1))

## Geometricke rozdeleni: p - pravdepodobnost uspechu
# cekani na prvni uspech, do prikazu se zadava pocet neuspechu pred prvnim uspechem
# pgeom(k,p) - distribucni funkce
# dgeom(k,p) - pravdepodobnostni funcke
# stredni hodnota (1-p)/p
# rozptyl (1-p)/p^2


## Poissonovo rozdeleni: lambda - stredni hodnota
# pocet udalosti
# ppois(k,lambda) - distribucni funkce
# dpois(k,lambda) - pravdepodobnostni funcke
# stredni hodnota lambda
# rozptyl lambda

#################################
### Spojita rozdeleni
## Normalni rozdeleni: mu - stredni hodnota, sigma - smerodatna odchylka
# pnorm(x,mu,sigma) - distribucni funkce
# qnorm(x,mu,sigma) - kvantilova funkce


# Příklad 19
# Hypergeometricke rozdeleni
# phyper(k,w,b,n) - distribucni funkce
# dhyper(k,w,b,n) - pravdepodobnostni funcke
w <- 6
b <- 43
n <- 6
k <- 3
dhyper(k, w, b, n) 



# Příklad 20
# Poissonovo rozdělení
# ppois(k,lambda) - distribucni funkce
# dpois(k,lambda) - pravdepodobnostni funcke
lambda <- 9 # průměrný počet za 3 hodiny (když za hodinu příjdou v průměru 3, tak za 3 hodin jich příjde v průměru 9 = 3*3)
k <- 2
1 - ppois(k, lambda) # P(x > 2) = 1 - P(x <= 2)
lambda <- 1 # když za hodinu příjdou v průměru 3, tak kolik jich příjde v průměru za 20 minut? no, tak 3 lidi za hodinu, tak to v průměru za každých 20 minut musí přijít jeden člověk
k <- 0
dpois(k, lambda) # P(x = 0)



# Příklad 15 (modifikovaný, neodpovídá zadání)
# - Binomické rozdělení
# - bereme v potaz pouze Českou republiku
# - když vyberu 10 lidí, tak tam bude alespoň 7 žen
# - nevíme, kolik lidi v České republice bylo (proto to nemůže být hypergeometrické)
n <- 10
p <- 0.5076
k <- 6
1 - pbinom(k,n,p) # P(z 10 lidí bude alespoň 7 žen) = P(x >= 7) = 1 - P(x < 7) = 1 - P(x <= 6)
# - Jaká je pravděpodobnost, že první žena bude 4. na pohovoru
# - Geometrické rozdělení (čekáme na prnví úspěch)
# P(první žena bude čtvrtá) = P(x = 4)
# počet neúspěchů: 3
# pravděpodobnost, že bude žena: 0.5076
dgeom(3, 0.5076)


# Příklad S 6
# - spojité normální/gaussovské rozdělení

# a) Určete P(x > 18)
# - střední hodnota = 23
# - o^2 = 25 = rozptyl (sigma kvadrát) => odmocnina z rozptylu je směrodatná odchylka = 5
# - pnorm(k, 23, 5)
# - k získám z: P(x > 18) = 1 - P(x <= 18)
k <- 18
1 - pnorm(k, 23, 5)

# b) Určete P(8 <= x <= 22)
# P(x => 8 AND x <= 22)
k1 <- 8
k2 <- 22
pnorm(k2, 23, 5) - pnorm(k1, 23, 5)

# c) P(X <= x) = 0.95
qnorm(0.95, 23, 5)

# d) P(X >= x) = 0.75 --> 0.25
qnorm(0.25, 23, 5)

# e) 
qnorm(0.025, 23, 5)
qnorm(0.975, 23, 5)



# hustota - vyska dospelych muzu
curve(dnorm(x,180,7),from=150,to=210, main="Hustota N(180, 49)",col="red",ylab="Hustota")
# distribucni funkce - vyska dospelych muzu
curve(pnorm(x,180,7),from=150,to=210, main="Distribucni funkce N(180, 49)",col="purple",ylab="Hustota")
# pravdepodobnost, ze nahodne vybrany muz bude mensi nez 170 cm
oldpar <- par(mfrow=c(1,2))
curve(dnorm(x,180,7),from=150,to=210, main="Hustota N(180, 49)")
lines(c(0,170),c(0,0),lwd=3,col="green") 
xx <- seq(150,170,length.out=101)
polygon(c(150,xx,170),c(0,dnorm(xx,180,7),0),col="green")
# umime-li zmerit velikost zelene plochy, mame pst :)

curve(pnorm(x,180,7),from=150,to=210, main="Distr. fce N(180, 49)")
lines(c(170,170),c(0,pnorm(170,180,7)),col="green",lty=2,lwd=2)
lines(c(0,170),c(pnorm(170,180,7),pnorm(170,180,7)),col="green",lty=2,lwd=2)
# hodnotu lze vycist z distribucni funkce
par(oldpar)

## Lognormalni rozdeleni: mu , sigma (velicina ln(X) ~ N(mu, sigma^2))
# plnorm(x,mu,sigma) - distribucni funkce
# qlnorm(x,mu,sigma) - kvantilova funkce
# stredni hodnota exp(mu+sigma^2/2)
# rozptyl (exp(sigma^2)+2)*exp(2*mu+sigma^2)

## Exponencialni rozdeleni: int - intenzita
# pexp(x,int) - distribucni funkce
# qexp(x,int) - kvantilova funkce
# distribucni funkce P(X <= t) = 1 - exp(-int*t)
# stredni hodnota 1/int
# rozptyl 1/int^2


# Příklad S 9
# Lognormální rozdělení

mi <- 5
sigmakvadrat <- 1
sigma <- sqrt(sigmakvadrat)

# a)
plnorm(100, mi, sigma) # P(x < 100) 

# b)
plnorm(100, mi, sigma) - plnorm(50, mi, sigma) # P(50 <= x <= 100)


# Příklad S 13
# Exponenciální rozdělení
# - rozdělení doby životnosti

# a) výrobek bude funkční alespoň 3000 dní
intenzita <- 1 / 2000
1 - pexp(3000, intenzita) # P(x >= 3000) = 1 - P(x <= 3000)

# b) výrobek nebude funkční delší dobu, než je jeho průměrná doba životnosti
intenzita <- 1 / 2000
pexp(2000, intenzita) # P(x <= 2000)

# c)
# - zde použijeme kvantilovou funkci
intenzita <- 1 / 2000
qexp(0.05, intenzita) # 102 dní, správný výsledek (v zadání je špatný)





#################################
### Centralni limitni veta
## Rozdeleni souctu nezavislych, stejne rozdelenych nahodnych velicin
#  konverguje k normalnimu pro pocet techto velicin rostouci nade vsechny meze.

# Normal - normální rozdělení
# Uniform - rovnoměrné rozdělení
# Gamma - exponenciální rozdělení
# Beta - beta rozdělení

library(TeachingDemos)
clt.examp(1) # průměr z 1 hodnoty (tudíž vlastně neprůměruju)
clt.examp(2) # průměr ze 2 hodnot
clt.examp(5)
clt.examp(10)
clt.examp(50)

# Dostatečný počet pozorování, má i výběrový průměr normální rozdělení

################################
### Nactete data Policie.RData
load("Policie.RData")

### Testovani hypotez
# Pred testem musime stanovit
#   testovane hypotezy: nulovou (H0) a alternativni (H1)
#   hladinu vyznamnosti (nejcasteji alfa = 0.05)
# Vyhodnoceni pomoci p-hodnoty
#   p-hodnota <= alfa => H0 zamitame, plati H1
#   p-hodnota > alfa => H0 nezamitame

## Pomoci jednovyberoveho t-testu na hladine vyznamnosti 5% rozhodnete,
#   zda prumerna vyska policistu muze byt 180 cm

# H0: vyska = 180 cm vs. H1: vyska != 180 cm (oboustranná alternativa)
vyska <- Policie$height
t.test(vyska, mu=180)
  # p-hodnota 0.0965 > 0.05 => nezamitame H0
  # Neprokazalo se, ze prumerna vyska policistu se lisi od 180 cm.
  #   Muze byt 180 cm.

## Pomoci jednovyberoveho t-testu na hladine vyznamnosti 5% rozhodnete,
#   zda prumerna hmotnost policistu muze byt 75 kg.
hmotnost <- Policie$weight
t.test(hmotnost, mu=75)
  # p-hodnota 0.03832 není větší 0.05 => zamítáme H0, platí H1
  # Nemůže být spíše 75 kg

## Pomoci jednovyberoveho t-testu na hladine vyznamnosti 5% rozhodnete,
#   zda prumerna hmotnost policistu je mensi nez 80 kg.

#####################
### Interval spolehlivosti pro prumer
# a jeho spojitost s jednovyberovym t-testem

## Spoctete 95% interval spolehlivosti pro prumer vysky kdyz vite, 
#  ze rozptyl vysky dospelych muzu je 49.
vyska <- Policie$height

# Rucni vypocet
mn <- mean(vyska)
sd <- sqrt(49)
n <- length(vyska)
alpha <- 0.05
q.n <- qnorm(1-alpha/2)

# Dolni mez
mn-q.n*sd/sqrt(n)
# Horni mez
mn+q.n*sd/sqrt(n)

# vypocet pomoci funkce v knihovne DescTools
MeanCI(prom2,sd=sd)

# a kdyby mi skutecny rozptyl nikdo nerekl?
# Rucni vypocet
mn <- mean(vyska)
sd <- sd(vyska)
n <- length(vyska)
alpha <- 0.05
q.t <- qt(1-alpha/2,n-1)

# Dolni mez
mn-q.t*sd/sqrt(n)
# Horni mez
mn+q.t*sd/sqrt(n)

# vypocet pomoci funkce v knihovne DescTools
MeanCI(vyska)
  # dostavam sirsi interval nez predtim, proc?
# spojitost s jednovyberovym t-testem
# interval spolehlivosti je soucasti vystupu z jednovyberoveho t-testu
t.test(vyska, mu = 0)
  # na zaklade intervalu spolehlivosti rozhodnete, zda prumerna vyska muzu
  #   muze byt 175 cm, 177 cm, 181 cm

## Spoctete 99%-ni interval spolehlivosti pro stredni hodnotu reakcni doby,
#  kdyz vim, ze rozptyl je 0.015 a kdyz nevim nic.
MeanCI( , conf.level=0.99)

###################################
## A jak spocitat interval spolehlivosti pro stredni hodnotu reakcni doby 
#  pomoci bootstrapu?
reakce <- Policie$react

boots <- list()
B <- 10000
for(i in 1:B) boots[[i]] <- sample(reakce,replace=TRUE)
  # bootstrapove vybery
means <- unlist(lapply(boots,mean))
  # bootstrapove prumery

hist(means,col="honeydew2",xlab="reakcni doba",
     main="Histogram bootstrapovych prumeru")
abline(v=mean(reakce),lwd=3,col="navy")
abline(v=quantile(means,probs=c(0.025,0.975)),lwd=3,col="red")
c(mean=mean(reakce),quantile(means,probs=c(0.025,0.975)))
  # bootstrapovy interval spolehlivosti

# Pomoci funkce
MeanCI(reakce,method="boot")
BootCI(reakce,FUN = mean)
  # pomoci parametru FUN mohu pocitat interval spolehlivosti pro libovolnou funkci
decil <- function(x) quantile(x,0.1)  
BootCI(prom3,FUN = decil)
  # bootstrapovy interval spolehlivosti pro dolni decil
