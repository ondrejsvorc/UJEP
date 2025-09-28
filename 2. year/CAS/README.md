### Časová řada
- posloupnost dat měřených v pravidelných časových intervalech
- osa x: čas
- osa y: pozorovaná data

### Sezónnost
- pravidelné, opakující se kolísání během pevného období (např. rok, měsíc, týden), způsobené sezónními vlivy
- má konstantní délku periody, cyklus nikoli

### Trend
- dlouhodobý směr vývoje časové řady, ukazuje stoupání nebo klesání hodnot napříč časem
- může být lineární i nelineární

### Cyklus
- dlouhodobé, nepravidelné kolísání časové řady, často spojované s hospodářskými/ekonomickými vzestupy a pády, které nemá pevnou délku trvání jako sezónnost

### Náhodná složka
- nezachytitelné, nepredikovatelné odchylky, způsobené náhodnými faktory

### ACF
- autokorelační funkce
- vyjadřuje, jak silně současná hodnota časové řady souvisí s hodnotou, která byla k pozic zpět v čase
- měří tedy korelaci (souvislost)
- osa x: zpoždění (lags)
- osa y: hodnota korelace pro dané zpoždění

### PACF
### Aditivní model
### Multiplikativní model

### Úvod do časových řad
### Typy časových řad a příklady
### Cíle a metody analýzy časových řad
### Dekompozice časových řad – Trend, Sezónnost, Náhodná složka
### Aditivní vs. Multiplikativní model časové řady

### Trendová složka a její modely
- Lineární, Kvadratický, Exponenciální, Logistický, Gompertzův trend
- Testy na typ trendu
- Informační kritéria (AIC, BIC, AICc)

### Metoda klouzavých průměrů
- Jednoduché a vážené klouzavé průměry
- Vyhlazování okrajových hodnot
- Volba řádu a délky

### Exponenciální vyrovnání
- Jednoduché, dvojité, trojité exponenciální vyrovnání
- Adaptivní řízení pomocí indikátoru poruchy
- Předpovědi a výpočet intervalů

### Holt-Wintersova metoda
- Aditivní varianta
- Multiplikativní varianta
- Předpověď a srovnání

### Náhodná složka a testy náhodnosti
- Bílý šum
- Testy: znaménkový, Kendallův τ, Spearmanův ρ, Runs test, Ljung-Box

### Box-Jenkinsova metodologie – ARIMA modely

#### Stacionarita a autokorelační struktura
- Autokorelační a parciální autokorelační funkce
- Odhady a testy (Bartlett, Quenouille)

#### ARMA modely
- MA(q), AR(p), ARMA(p,q)
- Vlastnosti, podmínky stacionarity a invertibility
- Identifikace modelu pomocí ACF a PACF

#### Odhad ARMA modelu
- Metoda nejmenších čtverců (nelineární)
- Kritéria výběru modelu (AIC, BIC, HQ)
- Verifikace modelu (residua, Ljung-Box)

#### ARIMA a SARIMA modely
- Integrované modely (ARIMA(p,d,q))
- Diferencování a jeho volba
- Sezónní modely (SARIMA(p,d,q)(P,D,Q)s)
- Identifikace a odhad

### Závislosti mezi časovými řadami

#### Kroskorelační funkce
- Definice, výpočet, interpretace

#### Lineární dynamické modely
- Závislost na jiných řadách (regresory)
- Sezónnost, trend, autoregrese a ARMA složka v regresi
- Validace modelu (residua, transformace)