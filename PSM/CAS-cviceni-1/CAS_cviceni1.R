#############################
### Dekompozice casove rady

# ts = vytváří časovou řadu (time series)
# decompose = dekompozice časové řady

births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
  # mesicni pocty narozenych v New Yorku od ledna 1946 do prosince 1959
  # frekvence - 12 měsíců, takže 12 hodnot za rok
  # start - počáteční časový údaj (rok a měsíc) - abychom věděli, kdy časová řada začíná
births.ts <- ts(births, frequency=12, start=c(1946,1))
  # prevedeni na casovou radu
plot(births.ts)
  # vykresleni rady
  # rada ma konstantni rozptyl, uvazuje se aditivni model

births.dec <- decompose(births.ts)
plot(births.dec)
  # rada byla rozlozena na trend, sezonni slozku a nahodnou chybu
  # pokud je sezonní složka menší než trendová, tak není zajímavá
(sez <- births.dec$seasonal)
  # sezonni slozka
(trend <- births.dec$trend)
  # je mozne odhadnout krivkou logistickeho trendu
(ns <- births.dec$random)
  # nahodna slozka

plot(AirPassengers)
  # pocty cestujicich vybranou leteckou spolecnosti v letech 1949 - 1960
  # rada ma rostouci rozptyl, uvazuje se multiplikativni model
  # zde není vhodný aditivní model
AirP.dec <- decompose(AirPassengers, type = "multiplicative")
plot(AirP.dec)

# muzete vyzkouset na radach co2, lynx
plot(co2)
plot(decompose(co2))

plot(lynx)
# Za každý rok 1 číslo
# Má frekvenci 1, takže nemá žádnou sezonnost
(lynx)


#############################
#### Hledani trendu v ukazkovych datech

load("Trendy.RData")

### Linearni trend
time<-1971:2000

rada<-Examples1[,1]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

mod1<-lm(rada.ts~time)
summary(mod1)
coef(mod1)
# AIC - dobrý pro porovnání více modelů se stejnými daty (který je lepší)
# Pro ohodnocení jednoho modelu je lepší koeficient determinace 
AIC(mod1)
lines(time,fitted(mod1),col=2)

############################
## Kvadraticky trend

rada<-Examples1[,2]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

# otestování kvadratického modelu
mod1<-lm(rada.ts~time+time2)
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=2)

# otestování lineárního modelu
mod1<-lm(rada.ts~time)
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=3)
# Čím menší AIC, tím lepší model (kvadratický je tedy vhodnější)

############################
## Exponencialni trend

rada<-Examples1[,3]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

ln.rada.ts<-log(rada.ts)
mod1<-lm(ln.rada.ts~time)
summary(mod1)
coef(mod1)
exp(coef(mod1))
AIC(mod1)
lines(time,exp(fitted(mod1)),col=2)

time2 <- time * time
mod1<-lm(rada.ts~time+time2)
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=3)

mod1<-lm(rada.ts~time)
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=4)

##############################
## Logisticky trend
x<-1:30

rada<-Examples1[,4]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)
-(log(120))/log(0.7)

# S-křivka = SSLogic
mod1<-nls(rada.ts ~ SSlogis(time, Asym, xmid, scal))
mod1<-nls(rada.ts ~ SSlogis(x, Asym, xmid, scal))
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=4)

# Gompertzova křivka = SSgompertz
mod1<-nls(rada.ts ~ SSgompertz(time, Asym, b2, b3))
mod1<-nls(rada.ts ~ SSgompertz(x, Asym, b2, b3))
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=2)

##############################
## Gompertzova krivka

rada<-Examples1[,5]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)
-(log(13.2))/log(0.8)

mod1<-nls(rada.ts ~ SSgompertz(time, Asym, b2, b3))
mod1<-nls(rada.ts ~ SSgompertz(x, Asym, b2, b3))
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=4)

mod1<-nls(rada.ts ~ SSlogis(time, Asym, xmid, scal))
mod1<-nls(rada.ts ~ SSlogis(x, Asym, xmid, scal))
summary(mod1)
coef(mod1)
AIC(mod1)
lines(time,fitted(mod1),col=2)

##############################
## zkuste dalsi rady ze souboru Examples1
rada<-Examples1[,6]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)
time<-1971:2000
mod1<-lm(rada.ts~time)
AIC(mod1)
lines(time,fitted(mod1),col=4)

rada<-Examples1[,7]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

rada<-Examples1[,8]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

rada<-Examples1[,9]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)

rada<-Examples1[,10]
rada.ts<-ts(rada,start=1971)
plot(rada.ts)