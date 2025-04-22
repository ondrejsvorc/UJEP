############################
library(forecast)
library(dynlm)
library(lmtest)
library(TSA)
# nacteni knihoven

############################
data("M1Germany")
head(M1Germany)
  # ekonomicka ctvrtletni data z Nemecka
  # M1 index "financni zasoby"

plot(M1Germany)
  # ctyri casove rady, kdy nas zajima, jaky je vztah mezi logm1 a ostatnimi

# Crosskorelacni funkce
par(mfrow = c(3,1))
ccf(M1Germany$logm1, M1Germany$logprice, na.action = na.pass)
ccf(M1Germany$logm1, M1Germany$loggnp, na.action = na.pass)
ccf(M1Germany$logm1, M1Germany$interest, na.action = na.pass)
par(mfrow = c(1,1))
  # je videt vysoka korelovanost s ostatnimi radami
  # s logprice a loggnp s nulovym zpozdenim
  # s interest se zpozdenim 4 roky

# regresni modely
fit1 <- dynlm(M1Germany$logm1 ~ M1Germany$logprice + M1Germany$loggnp + M1Germany$interest)
  # zavislost v aktualnim case
summary(fit1)
  # shrnuti modelu
# ale neni lepsi brat i promenne interest zavislost se zpozdenim?
fit2 <- dynlm(M1Germany$logm1 ~ M1Germany$logprice + M1Germany$loggnp + L(M1Germany$interest, -16))
  # zpozdena zavislost o 4 kroky na Interest
summary(fit2)
  # zavislost na interest se zde neprojevila

acf(fit1$residuals)
  # mam korelovana residua, musim pridat jeste cast arima 
  #   nebo zavislost na vlastnich zpozdenych pozorovanich

fit3 <- dynlm(M1Germany$logm1 ~ M1Germany$logprice + M1Germany$loggnp + M1Germany$interest + 
                L(M1Germany$logm1, 1))
summary(fit3)
acf(fit3$residuals)
  # zavislost na minule hodnote

fit4 <- dynlm(M1Germany$logm1 ~ M1Germany$logprice + M1Germany$loggnp + M1Germany$interest + 
                L(M1Germany$logm1, 4))
summary(fit4)
acf(fit4$residuals)
  # zavislost o jednu sezonu zpet dava lepsi vysledky

fit5 <- dynlm(M1Germany$logm1 ~ M1Germany$logprice + M1Germany$loggnp + M1Germany$interest + 
                L(M1Germany$logm1, 1) + L(M1Germany$logm1, 4))
summary(fit5)
acf(fit5$residuals)
  # zavislost o jednu sezonu i na minule hodnote
  # autokorelovanost residui se tim prilis nevyresila - bude lepsi sahnout k ARMA modelum pro residua

# vytvoreni matice regresoru
x.reg <- as.matrix(M1Germany[,2:4])
fit6 <- auto.arima(M1Germany$logm1, xreg = x.reg)
summary(fit6)
  # residua se ridi ARMA procesem az na prvnich sezonnich diferencich
coeftest(fit6)
  # vsechny koeficienty modelu jsou vyznamne
acf(fit6$residuals, na.action = na.pass)
  # nekorelovana residua - dobry model
checkresiduals(fit6)

# jak model sedi na data
figure <- ts.intersect(M1Germany$logm1, fitted(fit6))
plot.ts(figure, plot.type = "single", col=c("black","red"), 
        lty=c(1,1), lwd=c(1,1),
        main = "'Classic' Linear Model - Original (black) and Fitted series (red)") 

# pokud budu chtit predikovat bez znalosti jinych rad, tento model mi prilis nepomuze
# samostatna auto arima
fit7 <- auto.arima(M1Germany$logm1)
summary(fit7)
coeftest(fit7)
acf(fit7$residuals, na.action = na.pass)
  # nekorelovana residua - dobry model

# jak model sedi na data
figure <- ts.intersect(M1Germany$logm1, fitted(fit7))
plot.ts(figure, plot.type = "single", col=c("black","red"), 
        lty=c(1,1), lwd=c(1,1),
        main = "'Classic' Linear Model - Original (black) and Fitted series (red)") 

# ktery model je lepsi?
BIC(fit6)
BIC(fit7)
  # model s regresory je lepsi

BIC(fit5)
  # dynamicky model s korelovanymi residui

# predpovedi pro model fit7
for7 <-forecast(fit7)
plot(for7)
for7
  # vykresleni a vypsani predpovedi s intervaly spolehlivosti

#############################
### Samostatne

# pouzijte databazi EuStockMarkets a zkuste najit optimalni model pro index DAX
  # databaze burzovnich indexu
plot(EuStockMarkets)
head(EuStockMarkets)
dax <- EuStockMarkets[,"DAX"]
plot(dax, main="Index DAX", ylab="Hodnota", col="blue")

fit_dax <- auto.arima(dax, seasonal = FALSE)
summary(fit_dax)
checkresiduals(fit_dax)

forecast_dax <- forecast(fit_dax, h=20)
plot(forecast_dax)

x.reg <- as.matrix(EuStockMarkets[,2:4])
fit <- auto.arima(dax, xreg = x.reg, seasonal = FALSE)
checkresiduals(fit)

# nactete data EMG a hledejte optimalni model pro radu iEMG
#############################
## periodogram - hledani cyklu
plot(lynx)
  # data s evidentnimi cykly, ale nejedna se o sezonni data

n <- length(lynx)
FF <- abs(fft(lynx)/sqrt(n))^2
  # Fast Discrete Fourier Transform
P <- (4/n)*FF[1:(n/2 + 1)] 
  # potrebujeme prvnich (n/2)+1 hodnot FFT transformace
P <- P[-1]
  # prvni hodnota je nesmzslna

f <- (0:(n/2))/n 
  # this creates harmonic frequencies from 0 to .5 in steps of 1/n.
f <- f[-1]
plot(f, P, type="l")
  # periodogram rucne
(fr.max <- f[which.max(P)])
  # frekvence s maximalni hodnotou periodogramu
1/fr.max

per <- periodogram(lynx)
abline(h=0)

per$freq
per$spec
(fr.max <- per$freq[which.max(per$spec)])
  # frekvence s maximalni hodnotou periodogramu
1/fr.max
  # delka cyklu

############################
### Samostatne 

# hledejte delku cyklu pro slunecni aktivitu
data("sunspots")
  # mesicni data
plot(sunspots)

per <- periodogram(sunspots)
(fr.max <- per$freq[which.max(per$spec)])
frequency(sunspots) # frekvence 12 měsíců
1/fr.max/12 # 10

df <- data.frame(freq = per$freq, spec = per$spec)
df_sorted <- df[order(-df$spec), ]
second_max_freq <- df_sorted$freq[2]
second_max_period <- 1 / second_max_freq
second_max_period # 120

plot(M1Germany$interest)
frequency(M1Germany$interest)
