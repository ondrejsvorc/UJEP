####################
### Nektere dalsi moznosti casovych rad

library(fpp3)

####################
### Porovnani deterministickeho trendu a stochastickeho trendu
#   tj. porovnani regrese s ARMA chybou a ARIMA modelu

# vstupni data - letecka doprava v australii 
aus_airpassengers |>
  autoplot(Passengers) +
  labs(y = "Passengers (millions)",
       title = "Total annual air passengers")
# je videt rostouci trend

## deterministicky model - linearni zavislost na case a modelovani residui jako ARMA
fit_deterministic <- aus_airpassengers |>
  model(deterministic = ARIMA(Passengers ~ 1 + trend() +
                                pdq(d = 0)))
report(fit_deterministic)
  # model: Yt = 0.9014 + 1.4151 * t + et
  #        et = 0.9564 * e(t-1) + ft
  #        ft ~ iid N(0, 4.343)

## stochasticky trend - ARIMA
fit_stochastic <- aus_airpassengers |>
  model(stochastic = ARIMA(Passengers ~ pdq(d = 1)))
report(fit_stochastic)
  # model: Yt = Y0 + 1.4191 * t + et
  #        et = e(t-1) + ft
  #        ft ~ iid N(0, 4.271)

# rozdil neni ani tak v odhadech modelu, ale v presnosti predikce do budoucna
aus_airpassengers |>
  autoplot(Passengers) +
  autolayer(fit_stochastic |> forecast(h = 20),
            colour = "#0072B2", level = 95) +
  autolayer(fit_deterministic |> forecast(h = 20),
            colour = "#D55E00", alpha = 0.65, level = 95) +
  labs(y = "Air passengers (millions)",
       title = "Forecasts from trend models")
  # modre je stochasticky model, oranzove deterministicky
  # deterministicky model ma mensi chybovost

#####################################
### Modely harmonicke regrese ( s vyuzitim fourierova rozvoje)

# vstupni data
recent_production <- aus_production |>
  filter(year(Quarter) >= 1992)
recent_production |>
  autoplot(Beer) +
  labs(y = "Megalitres",
       title = "Australian quarterly beer production")
  # periodicka data s klesajicim trendem

# linearni model
fit_beer <- recent_production |>
  model(TSLM(Beer ~ trend() + season()))
report(fit_beer)
  # bezny zpusob modelovani trendu a sezonnosti
  # model: Yt = 441.8 - 0.34 * t -34.66 * Q2 - 17.82 * Q3 + 72.8 * Q4 + et  

# jak odhad sedi na data
augment(fit_beer) |>
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Beer, colour = "Data")) +
  geom_line(aes(y = .fitted, colour = "Fitted")) +
  scale_colour_manual(
    values = c(Data = "black", Fitted = "#D55E00")
  ) +
  labs(y = "Megalitres",
       title = "Australian quarterly beer production") +
  guides(colour = guide_legend(title = "Series"))

# predpovedi
fc_beer <- forecast(fit_beer)
fc_beer |>
  autoplot(recent_production) +
  labs(
    title = "Forecasts of beer production using regression",
    y = "megalitres"
  )

# harmonicka regrese - model pomoci clenu Fourierovy rady
fourier_beer <- recent_production |>
  model(TSLM(Beer ~ trend() + fourier(K = 2)))
report(fourier_beer)
  # model: Yt - 446.9 - 0.34 * t + 8.9 * cos(2pit/4) - 53.7 * sin(2pit/4) - 14 * cos(4pit/4) + et

# jak model sedi na data
augment(fourier_beer) |>
  ggplot(aes(x = Quarter)) +
  geom_line(aes(y = Beer, colour = "Data")) +
  geom_line(aes(y = .fitted, colour = "Fitted")) +
  scale_colour_manual(
    values = c(Data = "black", Fitted = "#D55E00")
  ) +
  labs(y = "Megalitres",
       title = "Australian quarterly beer production") +
  guides(colour = guide_legend(title = "Series"))

# predpovedi
fc_beer <- forecast(fourier_beer)
fc_beer |>
  autoplot(recent_production) +
  labs(
    title = "Forecasts of beer production using regression",
    y = "megalitres"
  )

# modely jsou prakticky totozne

#################################
### Kombinace harmonicke regrese a ARMA chyb
# vstupni data - naklady na jidlo v Autralii
aus_cafe <- aus_retail |>
  filter(
    Industry == "Cafes, restaurants and takeaway food services",
    year(Month) %in% 2004:2018
  ) |>
  summarise(Turnover = sum(Turnover))
aus_cafe |>
  autoplot(Turnover) +
  labs(y = "$ billions",
       title = "Australian eating out expenditure")
  # periodicka data s rostoucim trendem

# 6 modelu vyuzivajicich az 6 clenu fourierovy rady
#   nahodna slozka rady je modelovana jako ARMA model bez periodicke casti
fit <- model(aus_cafe,
             `K = 1` = ARIMA(log(Turnover) ~ fourier(K=1) + PDQ(0,0,0)),
             `K = 2` = ARIMA(log(Turnover) ~ fourier(K=2) + PDQ(0,0,0)),
             `K = 3` = ARIMA(log(Turnover) ~ fourier(K=3) + PDQ(0,0,0)),
             `K = 4` = ARIMA(log(Turnover) ~ fourier(K=4) + PDQ(0,0,0)),
             `K = 5` = ARIMA(log(Turnover) ~ fourier(K=5) + PDQ(0,0,0)),
             `K = 6` = ARIMA(log(Turnover) ~ fourier(K=6) + PDQ(0,0,0))
)

fit |>
  forecast(h = "2 years") |>
  autoplot(aus_cafe, level = 95) +
  facet_wrap(vars(.model), ncol = 2) +
  guides(colour = "none", fill = "none", level = "none") +
  geom_label(
    aes(x = yearmonth("2007 Jan"), y = 4250,
        label = paste0("AICc = ", format(AICc))),
    data = glance(fit)
  ) +
  labs(title= "Total monthly eating-out expenditure",
       y="$ billions")
  # vykresleni vylepsujici se predikce

# nejlepsi model
fit_best <- model(aus_cafe,
                  ARIMA(log(Turnover) ~ fourier(K=6) + PDQ(0,0,0)))
report(fit_best)
  # jak vypada model?

############################
### Zavislost na jinych radach s ARMA chybami

# vstupni data - zavislost spotreby energie na teplote
vic_elec_daily <- vic_elec |>
  filter(year(Time) == 2014) |>
  index_by(Date = date(Time)) |>
  summarise(
    Demand = sum(Demand) / 1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)
  ) |>
  mutate(Day_Type = case_when(
    Holiday ~ "Holiday",
    wday(Date) %in% 2:6 ~ "Weekday",
    TRUE ~ "Weekend"
  ))

# je videt nelinearni zavislost na teplote
vic_elec_daily |>
  pivot_longer(c(Demand, Temperature)) |>
  ggplot(aes(x = Date, y = value)) +
  geom_line() +
  facet_grid(name ~ ., scales = "free_y") + ylab("")

# jsou zrejme rozdily v pracovnich dnech a o vikendech
vic_elec_daily |>
  ggplot(aes(x = Temperature, y = Demand, colour = Day_Type)) +
  geom_point() +
  labs(y = "Electricity demand (GW)",
       x = "Maximum daily temperature")

# model nelinearni zavislosti na teplote se zavislosti na pracovnim dni a ARMA chybami
fit <- vic_elec_daily |>
  model(ARIMA(Demand ~ Temperature + I(Temperature^2) +
                (Day_Type == "Weekday")))
report(fit)
  # pomerne slozita cast pro ARMA chyby

fit |> gg_tsresiduals()
  # kontrola chyb modelu

# predikce - nejprve je treba predikovat teplotu a pracovni dny
vic_elec_future <- new_data(vic_elec_daily, 14) |>
  mutate(
    Temperature = 26,
    Holiday = c(TRUE, rep(FALSE, 13)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )
  # teplota se vzala konstantne 26 a pridaly se k tomu charakteristiky jednotlivych dni

# predpoved spotreby el. energie
forecast(fit, vic_elec_future) |>
  autoplot(vic_elec_daily) +
  labs(title="Daily electricity demand: Victoria",
       y="GW")

##########################
### Vicenasobna (dvojita) perioda v rade 

# vstupni data - telefonaty do banky
bank_calls |>
  fill_gaps() |>
  autoplot(Calls) +
  labs(y = "Calls",
       title = "Five-minute call volume to bank")

calls <- bank_calls |>
  mutate(t = row_number()) |>
  update_tsibble(index = t, regular = TRUE)
  # v datech jsou chybejici hodnotz mimo pracovni dobu - vynechame je

# dekompozice rady na trend, prvni sezonnost a druhou sezonnost
calls |>
  model(
    STL(sqrt(Calls) ~ season(period = 169) +
          season(period = 5*169),
        robust = TRUE)
  ) |>
  components() |>
  autoplot() + labs(x = "Observation")

## Porovnani predpovedi z dekompozice + exponencialniho vyrovnani 
#   a harmonicke regrese
# dekompozice + exponencialni vyrovnani
my_dcmp_spec <- decomposition_model(
  STL(sqrt(Calls) ~ season(period = 169) +
        season(period = 5*169),
      robust = TRUE),
  ETS(season_adjust ~ season("N"))
)
# predpovedi
fc <- calls |>
  model(my_dcmp_spec) |>
  forecast(h = 5 * 169)

# Priprava dat pro vykresleni (pridani chybejicich hodnot)
fc_with_times <- bank_calls |>
  new_data(n = 7 * 24 * 60 / 5) |>
  mutate(time = format(DateTime, format = "%H:%M:%S")) |>
  filter(
    time %in% format(bank_calls$DateTime, format = "%H:%M:%S"),
    wday(DateTime, week_start = 1) <= 5
  ) |>
  mutate(t = row_number() + max(calls$t)) |>
  left_join(fc, by = "t") |>
  as_fable(response = "Calls", distribution = Calls)

# Vykresleni predpovedi na 3 tydny
fc_with_times |>
  fill_gaps() |>
  autoplot(bank_calls |> tail(14 * 169) |> fill_gaps()) +
  labs(y = "Calls",
       title = "Five-minute call volume to bank")

# harmonicka regrese - vyplati se pri dlouhych periodach (jine postupy na nich kolabuji)
fit <- calls |>
  model(
    dhr = ARIMA(sqrt(Calls) ~ PDQ(0, 0, 0) + pdq(d = 0) +
                  fourier(period = 169, K = 10) +
                  fourier(period = 5*169, K = 5)))

# predpovedi
fc <- fit |> forecast(h = 5 * 169)

# Priprava dat pro vykresleni (pridani chybejicich hodnot)
fc_with_times <- bank_calls |>
  new_data(n = 7 * 24 * 60 / 5) |>
  mutate(time = format(DateTime, format = "%H:%M:%S")) |>
  filter(
    time %in% format(bank_calls$DateTime, format = "%H:%M:%S"),
    wday(DateTime, week_start = 1) <= 5
  ) |>
  mutate(t = row_number() + max(calls$t)) |>
  left_join(fc, by = "t") |>
  as_fable(response = "Calls", distribution = Calls)

# Vykresleni predpovedi na 3 tydny
fc_with_times |>
  fill_gaps() |>
  autoplot(bank_calls |> tail(14 * 169) |> fill_gaps()) +
  labs(y = "Calls",
       title = "Five-minute call volume to bank")

#### 
# vstupni data: zavislost spotreby el.energie na teplote
vic_elec |>
  pivot_longer(Demand:Temperature, names_to = "Series") |>
  ggplot(aes(x = Time, y = value)) +
  geom_line() +
  facet_grid(rows = vars(Series), scales = "free_y") +
  labs(y = "")

# pridani pracovnich dni
elec <- vic_elec |>
  mutate(
    DOW = wday(Date, label = TRUE),
    Working_Day = !Holiday & !(DOW %in% c("Sat", "Sun")),
    Cooling = pmax(Temperature, 18)
  )
elec |>
  ggplot(aes(x=Temperature, y=Demand, col=Working_Day)) +
  geom_point(alpha = 0.6) +
  labs(x="Temperature (degrees Celsius)", y="Demand (MWh)")

# harmonicky model
## pozor, velka data - bezi dlouho!!!
fit <- elec |>
  model(
    ARIMA(Demand ~ PDQ(0, 0, 0) + pdq(d = 0) +
            Temperature + Cooling + Working_Day +
            fourier(period = "day", K = 7) +
            fourier(period = "week", K = 4) +
            fourier(period = "year", K = 2))
  )

# priprava dat pro vypocet predpovedi
elec_newdata <- new_data(elec, 2*48) |>
  mutate(
    Temperature = tail(elec$Temperature, 2 * 48),
    Date = lubridate::as_date(Time),
    DOW = wday(Date, label = TRUE),
    Working_Day = (Date != "2015-01-01") &
      !(DOW %in% c("Sat", "Sun")),
    Cooling = pmax(Temperature, 18)
  )
# predpovedi
fc <- fit |>
  forecast(new_data = elec_newdata)

fc |>
  autoplot(elec |> tail(10 * 48)) +
  labs(title="Half hourly electricity demand: Victoria",
       y = "Demand (MWh)", x = "Time [30m]")

#####################################

plot(lynx)
lynx_tsbl <- as_tsibble(lynx)
lynx_tsbl2 <- lynx_tsbl |> mutate(Time = 1:length(lynx))
fit <- lynx_tsbl2 |> model(TSLM(value ~ fourier(period = 10, K = 1)))
report(fit)

fits <- lynx_tsbl2 %>% model(
  K1 = ARIMA(value ~ fourier(period = 10, K = 1) + fourier(period = 40, K = 1)),
  K2 = ARIMA(value ~ fourier(period = 10, K = 1) + fourier(period = 40, K = 2)),
  K3 = ARIMA(value ~ fourier(period = 10, K = 1) + fourier(period = 40, K = 3)),
  K4 = ARIMA(value ~ fourier(period = 10, K = 1) + fourier(period = 40, K = 4))
)

best <- fits %>% select(which.min(glance(fits)$AICc))
report(best)
best %>% forecast(h = 20) %>% autoplot(lynx_tsbl2)

augment(best) %>% 
  mutate(Time = row_number()) %>%
  ggplot(aes(Time, value)) +
  geom_line() +
  geom_line(aes(y = .fitted), size = 1)
