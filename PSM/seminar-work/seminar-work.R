# Ředitel banky si u Vás objednal analýzu výsledků dotazníkového šetření realizovaného na skupině zákazníků banky.
# Jeho dotaz zní: jak bych měl navýšit zisk banky?
# Vaším úkolem je vymyslet svou vlastní optimální strategii působení na zákazníky tak,
# aby se vylepšil jejich vztah k bance.

# Mezi marketéry velkých firem se klade zásadní důraz na následující
# tři proměnné: celková spokojenost, ochota firmu doporučit, víra že u firmy vydržím.
# Můžete se zaměřit na některou z těchto proměnných, nebo na jejich kombinaci (např. pomocí váženého průměru)
# a hledat regresní optimální model, na čem tato proměnná závisí.
# Následně pak vyhodnotíte, na které faktory by se banka měla zaměřit především.

satisfaction <- get(load("SatData.RData"))
View(satisfaction)

# Výběr relevantních proměnných (vstupy + výstup)
model_data <- satisfaction[, c(
  "reputation", "trustworthiness", "seriousness", "solidness", "care",
  "exp_products", "exp_services", "service", "solutions",
  "qual_products", "qual_services", "range_products", "qual_personal", "qual_overall",
  "benefits", "investments", "quality", "price",
  "satisfaction"
)]

# Regresní model
model <- lm(satisfaction ~ ., data = model_data)

# Shrnutí výsledků
summary(model)

# Seřazení prediktorů podle významnosti
coeffs <- summary(model)$coefficients
coeffs[order(coeffs[,4]), ]
