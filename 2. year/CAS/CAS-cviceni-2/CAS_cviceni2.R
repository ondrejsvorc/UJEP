############################
### nacteni knihoven, ktere pracuji s casovymi radami
library(TTR)
library(zoo)
library(forecast)
  # dalsi uzitecne funkce obsazene primo v knihovne stats

############################
### Vyhlazeni casovych rad

### Vyhlazeni pomoci klouzavych prumeru 

kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)
  # veky, ve kterych zemreli anglicti kralove
kings.ts <- ts(kings)
plot(kings.ts)
  # trendova slozka bez sezonnosti

# klouzave prumery prvniho radu ruzne delky
kings.rm3 <- rollmean(kings.ts, 3)
kings.rm5 <- rollmean(kings.ts, 5)
kings.rm7 <- rollmean(kings.ts, 7)
kings.rm9 <- rollmean(kings.ts, 9)
kings.rm11 <- rollmean(kings.ts, 11)
  # pro krajni body odhady nejsou

# Dobrý odhad vyhlazuje
# Dobrý odhad nejde proti hodnotám (okno je moc krátké - musíme brát delší) - nemá jít obráceně než původní řada (časová řada třeba někde stoupá, ale vyhlazení třeba klesá v dané oblasti)
# Světle modrá je asi nejlepší, fialová "ukrojila" příliš pozorování
plot(kings.ts)
lines(kings.rm3, col = 2)
lines(kings.rm5, col = 3)
lines(kings.rm7, col = 4)
lines(kings.rm9, col = 5)
lines(kings.rm11, col = 6)
legend(34, 40, legend=c("puvodni rada", "KP delky 3", "KP delky 5", "KP delky 7", "KP delky 9", "KP delky 11"),
       lty=1, col=1:6, cex=0.8)
  # podivame se na vysledky a podle toho, jak detailni vyhlazeni chceme, volime delku klouzaveho prumeru
  # neni dobre, kdyz vyhlazena rada vykazuje opacne vykyvy nez rada puvodni 
  #   to znaci male vyhlazeni

# klouzave prumery tretiho radu
vahy <- (1/35)*c(-3, 12, 17, 12, -3)
kings.rm3.5 <- rollapply(kings.ts, 5, 
                    function(z){return(weighted_mean = weighted.mean(z, vahy))})
vahy <- (1/231)*c(-21, 14, 39, 54, 59, 54, 39, 14, -21)
kings.rm3.9<-rollapply(kings.ts, 9, 
                    function(z){return(weighted_mean = weighted.mean(z, vahy))})

plot(kings.ts)
lines(kings.rm3.5, col = 2)
lines(kings.rm3.9, col = 3)
  # mame lepsi vysledky nez obycejnymi klouzavymi prumery?

###################################
### funkcne zapsatelny trend
# pokud jsme tvar trendu schopni odhadnout z dat, je mozne pocitat primo model zavislosti na case
cas <- 1:42
lin.trend <- lm(kings ~ cas)
kv.trend <- lm(kings ~ cas + I(cas^2))
kub.trend <- lm(kings ~ cas + I(cas^2) + I(cas^3))

plot(kings.ts)
abline(lin.trend, col = 2)
lines(cas,fitted(kv.trend), col = 3)
lines(cas,fitted(kub.trend), col = 4)
legend(34, 40, legend=c("puvodni rada", "linearni trend", "kvadraticky trend", "kubicky trend"),
       lty=1, col=1:4, cex=0.7)

# porovnani, ktery trend je lepsi
summary(lin.trend)$r.squared # koeficient determinace (vysvětlí 16 % variability)
summary(kv.trend)$r.squared # koeficient determinace (vysvětlí 29 % variability)
summary(kub.trend)$r.squared # koeficient determinace (vysvětlí 32 % variability)
  # procento variability vysvetlene modelem

AIC(lin.trend)
AIC(kv.trend)
AIC(kub.trend)
  # Akaikeho informacni kriterium - cim mensi tim lepsi
BIC(lin.trend)
BIC(kv.trend)
BIC(kub.trend)
  # Bayesovske informacni kriterium - cim mensi tim lepsi
  # idealni model se jevi kvadraticky (ale stejně ho používat nebudeme)

#############################
### Vyhlazeni pomoci exponencialniho vyrovnani

## Jednoduche exponencialni vyhlazovani - vhodne pro lokalne konstantni trend
rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
  # rocni srazky v Londyne merene v palcich z let 1813 az 1912
rain.ts <- ts(rain, start = c(1813))
plot(rain.ts)
  # aditivni rada s konstantnim trendem

rain.exp <- HoltWinters(rain.ts, beta = FALSE, gamma = FALSE)
  # jednoduche exponencialni vyrovnani
plot(rain.exp)
  # vykresli data i s odhadnutym trendem
rain.exp$fitted
  # predpovedi, neboli hodnoty trendu
rain.exp$SSE
  # sum of squared errors - soucet druhych mocnin chyb odhadu
rain.exp
  # odhadnuta hodnota parametru alpha

# cim mensi alpha, tim vetsi vyhlazeni
rain.exp2 <- HoltWinters(rain.ts, alpha = 0.01, beta = FALSE, gamma = FALSE)
plot(rain.exp2)
# cim vetsi alpha, tim mensi vyhlazeni
rain.exp2 <- HoltWinters(rain.ts, alpha = 0.05, beta = FALSE, gamma = FALSE)
# beta = linearni trend
# gamma = sezonnost
plot(rain.exp2)

# pri exponencialnim vyhlazovani se bezne bere jako pocatek trendu prvni merena hodnota
# pokud chceme trend zacit v jine hodnote, je mozne vyuzit parametr l.start
plot(HoltWinters(rain.ts, beta = FALSE, gamma = FALSE, l.start = 25))
  # jak vypada odhad trendu zacinajiciho na hodnote 25

## Predpovedi z exponencialniho vyhlazovani
rain.exp.for <- forecast(rain.exp, h = 10)
  # vypocte 10 predpovedi na budouci uhrny srazek
plot(rain.exp.for)
lines(1814:1912, rain.exp$fitted[,1], col = 3)
  # zakresleni predpovedi do grafu
  # modra cara je bodova predpoved, tmave seda plocha 80% interval spolehlivosti
  #   a svetle seda plocha 95% interval spolehlivosti

## Dvojite exponencialni vyhlazovani - pri lokalne linearnim trendu
skirts <- scan("http://robjhyndman.com/tsdldata/roberts/skirts.dat",skip=5)	
  # rocni data o prumeru lemu sukni z let 1866 az 1911
skirts.ts <- ts(skirts, start = c(1866))
plot(skirts.ts)
  # je videt nejprve rostouci a pak klesajici trend bez sezonni slozky s minimalni chybou

skirts.exp <- HoltWinters(skirts.ts, gamma = FALSE)
  # Holtova metoda - zobecnene dvojite exponencialni vyrovnani
skirts.exp
  # odhadnute hodnoty parametru alfa a beta nam rikaji, ze odhady jsou zalozene 
  #   predevsim na nedavnych hodnotach (zavislost nejde daleko do minulosti)
plot(skirts.exp)
  # vykresleni odhadnuteho trendu
skirts.exp$SSE # pro porovnání alphy
  # Soucet druhych mocnin chyb odhadu

## Predpovedi z Holtova vyhlazovani
skirts.exp.for <- forecast(skirts.exp, h = 20)
  # vypocte 20 predpovedi
plot(skirts.exp.for)
lines(1868:1911, skirts.exp$fitted[,1], col = 3)
  # zakresleni predpovedi do grafu
  # modra cara je bodova predpoved, tmave seda plocha 80% interval spolehlivosti
  #   a svetle seda plocha 95% interval spolehlivosti

############################
## Parametry funkce HoltWinters:
# alpha - zodpovida za absolutni clen
# beta - zodpovida za linearni clen
# gamma - zodpovida za sezonni slozku

# pocita se vyhlazeni v podobe Y(t+h) = a(t) + h*b(t) + s(t - p + 1 + (h-1) mod p)
# jednotlive slozky jsou pocitany rekurentne a pri svem vypoctu vyuzivaji i ostatnich slozek:

# a(t) = alpha*(Y(t) - s(t - p)) + (1 - alpha)*(a(t - 1) + b(t - 1))
# b(t) = beta*(a(t) - a(t - 1)) + (1 - beta)*b(t - 1)
# s(t) = gamma*(Y(t) - a(t)) + (1 - gamma)*s(t - p)

# chcete-li vetsi vyhlazeni, pak pomuze volit mensi alpha
# pokud menite i parametr beta, pak musite hledat vhodnou kombinaci alpha, beta 

############################
## Najdete optimalni zpusob vyhlazeni u nasledujicich rad

## rocni hodnoty vysky hladiny Huronskeho jezera (nemá sezónnost)
plot(LakeHuron)
data <- LakeHuron

data.rm3 <- rollmean(data, 3)
data.rm5 <- rollmean(data, 5)
data.rm7 <- rollmean(data, 7)
data.rm9 <- rollmean(data, 9)
data.rm11 <- rollmean(data, 11)

plot(data)
lines(data.rm3, col = 2)
lines(data.rm5, col = 3)
lines(data.rm7, col = 4)
lines(data.rm9, col = 5)
lines(data.rm11, col = 6)
legend(34, 40, legend=c("puvodni rada", "KP delky 3", "KP delky 5", "KP delky 7", "KP delky 9", "KP delky 11"),
       lty=1, col=1:6, cex=0.8)

## pocty lidi pripojenych k internetu za minutu (má nějaké trendy)
plot(WWWusage)

## rocni prumerne teploty v New Haven
plot(nhtemp)

## rocni prutoky Nilu
plot(Nile)

## rada hlavniho indikatoru prodeje
plot(BJsales.lead)

## koncentrace CO2 v ovzdusi v Mauna Loa
plot(co2)
plot(decompose(co2))
co2.rm11 <- rollmean(co2, 11)
plot(co2)
lines(co2.rm11, col = 6)
legend(34, 40, legend=c("puvodni rada", "KP delky 3", "KP delky 5", "KP delky 7", "KP delky 9", "KP delky 11"), lty=1, col=1:6, cex=0.8)
plot(co2)
cas <- time(co2)
lin.trend <- lm(co2 ~ cas)
abline(lin.trend, col = 2)

## kvartalni hodnoceni americkych presidentu

## mesicni pocty vaznych nehod v Britanii
plot(UKDriverDeaths)
plot(decompose(UKDriverDeaths))
data <- UKDriverDeaths
data.rm13 <- rollmean(data, 13) # měsíční data, takže alespoň 12 pozorování (to je ale sudé číslo, takže 13)
plot(data)
lines(data.rm13, col = 6)
