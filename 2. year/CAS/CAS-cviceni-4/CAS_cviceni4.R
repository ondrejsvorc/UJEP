#######################
## Testy nahodnosti pro radu typu bily sum
library(randtests)
plot(discoveries)

# Je tato rada nahodna?
difference.sign.test(discoveries)
  # test zalozeny na znamenkach diferenci
diff(discoveries,1)
  # takto vypadaji diference
sign(diff(discoveries,1))
  # takto vypadaji znamenka diferenci
table(sign(diff(discoveries,1)))
  # a tady vidime pocty kladnych a zapornych diferenci
  # podle tohoto testu je rada nahodna

# pro testy zalozene na korelacnich koeficientech potrebuji poradove cislo hodnot
index <- 1:length(discoveries)
cor.test(discoveries, index, method = "kendall")
  # test zalozeny na Kandallove korelacnim koeficientu
  # korelacni koeficient pro usporadane promenne
cor.test(discoveries, index, method = "spearman")
  # test zalozeny na Spearmanove korelacnim koeficientu
  # test pro spojite promenne zalozeny na poradich
  # oba tyto testy ukazuji mirnou zapornou korelaci (rada klesa),
  #   ktera je na hladine vyznamnosti 5% vyznamna

# dalsi testy
runs.test(discoveries)
  # Wald-Wolfowitz Runs Test
discoveries - median(discoveries)
  # rada odchylek od medianu
sign(discoveries - median(discoveries))
  # znamenka odchylek
(zn <- sign(discoveries - median(discoveries))[sign(discoveries - median(discoveries)) != 0])
  # znamenka s vynechanymi nulami
abs(diff(zn))
  # body, kde se mi meni znamenko
sum(abs(diff(zn)))/2 + 1
  # pocet useku se stejnymi znamenky
  # rada se tvari nahodne

# pro zajemce
cox.stuart.test(discoveries)
  # znamenkovy test porovnavajici dve poloviny casove rady proti sobe
bartels.rank.test(discoveries)
  # poradova verze Neumannova podiloveho testu

###############################
### Samostatne

# H0: řada je náhodná
# H1: řada není náhodná
# Čili, když je p-hodnota < 0.05, zamítáme H0 (řada není náhodná)
# Pokud je p-hodnota >= 0.05, nemáme důkazy pro zamítnutí H0, platí H1 (řada je náhodná)

# Máme 4 testy, přičemž každý test je založen na něčem jiném
# Podle toho se můžeme rozhodnout, který je správný pro konkrétní řadu
# 1. Test založený na znamenkách diferencí
#    - měří pouze to, kolikrát jde řada nahoru a kolikrát jde dolů
#    - ten tedy říká, že ano, data jsou náhodná, klesají a stoupají, ale mylně (pro LakeHuron nevhodný test)
# 2. Testy založené na korelačním koeficientu (Kendalův test, Spearmanův test)
#    - měří trend, jestli monotónně stoupá nebo monotónně klesá, je pro něj tedy důležitý monotónní trend (lineární?)
# 3. Test založený na rozdílu od mediánu
#    - měří, kolik hodnot je nad mediánem a kolik pod mediánem
#    - 

# je rada LakeHuron nahodna?
data("LakeHuron")
plot(LakeHuron)
difference.sign.test(LakeHuron) # řada je náhodná (takže špatný test)
runs.test(LakeHuron) # řada není náhodná
cor.test(LakeHuron, 1:length(LakeHuron), method = "kendall") # řada není náhodná
cor.test(LakeHuron, 1:length(LakeHuron), method = "spearman") # máme shodné hodnoty, udělá pouze aproximaci, řada není náhodná

#   hladina Huronskeho jezera
# je rada lh nahodna?
data("lh")
plot(lh)
runs.test(lh) # řada není náhodná
table(sign(diff(lh,1)))

#   Luteinizing Hormone in Blood Samples
# je rada nhtemp nahodna?
data("nhtemp")
plot(nhtemp)
runs.test(nhtemp) # řada není náhodná
table(sign(diff(nhtemp,1)))

#   Average Yearly Temperatures in New Haven
###############################

# Autokorelacni a parcialni autokorelacni funkce 
data(lh)
  # Luteinizing Hormone in Blood Samples
plot(lh)
  # v rade neni evidentni zadny trend ani sezonnost

# autokovariancni funkce
acf(lh,type="covariance")
acf(lh,type="covariance",plot=F)
  # vypis hodnot, prvni z nich je rozptyl rady
# autokorelacni funkce
acf(lh)
# Bartletova aproximace
# nad mezí - autokorelační funkce je významná
# pod mezí - autokorelační funkc je nevýznamná

acf(lh,plot=F)
  # opet si muzeme nechat hodnoty vypsat
# parcialni autokorelacni funkce
pacf(lh)
  # parcialni autokorelacni funkce
pacf(lh,plot=F)
  # vypis hodnot, prvni z nich je stejna jako u autokorelacni funkce

# Ktere korelace jsou nenulove? Ktere modely pripadaji pro radu v uvahu?
par(mfrow=c(2,1))
acf(lh);pacf(lh)
par(mfrow=c(1,1))
  # nakresleni obou funkci pod sebe

# test na nulovost autokorelacni funkce
Box.test(lh, lag=2, type="Ljung-Box")
  # rucne najdete hodnotu, kterou by nemela prekrocit druha autokorelace

# nulovost autokorelacni funkce residui znamena, ze mame spravny model

# pomoci funkce arima.sim(n = ,list(ar = ,ma = )) nasimulujte rady typu
#   MA(1) s parametrem theta1 = 0.75
#   MA(1) s parametrem theta1 = -0.75
#   MA(1) s parametrem theta1 = 1.5
#   AR(1) s parametrem phi1 = 0.75
#   AR(1) s parametrem phi1 = - 0.75
#   AR(1) s parametrem phi1 = 1.5
# podivejte se, jak rady vypadaji a jak vypadaji jejich autokorelacni a parcialni autokorelacni funkce

rada <- arima.sim(n=100, list(ar = 0.75))
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

rada <- arima.sim(n=100, list(ar = -0.75))
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

rada <- arima.sim(n=100, list(ar = 1.5)) # rada nesplnuje predpoklady (neni stacionarni)
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

rada <- arima.sim(n=100, list(ma = 0.75))
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

rada <- arima.sim(n=100, list(ma = -0.75))
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

rada <- arima.sim(n=100, list(ma = 1.5))
plot(rada)
par(mfrow=c(2,1))
acf(rada)
pacf(rada)
par(mfrow=c(1,1))

# podivejte se na radu ldeaths
#   vypoctete jeji autokorelacni a parcialni autokorelacni funkci
#   ocistete ji od trendu a sezonnosti a podivejte se na autokorelacni funkci 
#     a parcialni autokorelacni funkci jejich residui
