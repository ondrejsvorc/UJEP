library(MASS)
library(car)

data("Pima.te")

?Pima.te
str(Pima.te)

# npreg:  Počet těhotenství (number of pregnancies).
# glu:    Koncentrace glukózy v plasmě (klíčový ukazatel).
# bp:     Diastolický krevní tlak (blood pressure).
# skin:   Tloušťka kožní řasy na tricepsu (indikátor podkožního tuku).
# bmi:    Index tělesné hmotnosti (Body Mass Index).
# ped:    Funkce rodinné anamnézy diabetu (diabetes pedigree function).
# age:    Věk (roky).
# type:   Yes = má cukrovku, No = nemá

# type - vysvětlovaná proměnná
# ostatní - vysvětlující proměnné

# Předpoklady
# - vysvětlovaná proměnná musí být dikotomická proměnná
# - absence multikolinearity

# Obecný zápis logistické regrese
# - ln(p / (1 - p)) = b0 + b1*x1 + b2*x2 + ... + bn*xn

summary(Pima.te)
head(Pima.te)

# ln(p/(1-p)) = -9.514 + 0.141*npreg + 0.037*glu - 0.009*bp + 0.013*skin + 0.079*bmi + 1.110*ped + 0.018*age
model <- glm(type ~ ., data = Pima.te, family = binomial)
summary(model)

# Pr(>|z|)
# - Nulová hypotéza (H0): Daný faktor nemá na cukrovku žádný vliv (beta_i = 0).
# - Alternativní hypotéza (H1): Daný faktor má na cukrovku statisticky významný vliv (beta_i != 0)

# Statisticky významné regresory:
# - glu (cukr v krvi je základním diagnostickým kritériem pro diabetes + pokud má někdo dlouhodobě vysokou hladinu cukru v krvi, je to v podstatě definice cukrovky)
# - bmi (obezita je hlavním rizikovým faktorem pro vznik diabetu 2. typu)
# - npreg (diabetes má silnou dědičnou složbu)
# - ped (těhotenství představuje pro ženský organismus obrovskou metabolickou zátěž)

# ln(p/(1-p)) = -9.514 + 0.141*npreg + 0.037*glu + 0.079*bmi + 1.110*ped
# Pro optimální model jsem zvolil pouze ty regresory, které byly statisticky významné.
# To nicméně není korektní postup - ten je použít stepwise regression (kroková regrese).
# Další kritérium pro zvolení optimálního modelu je AIC (případně BIC), které jsem zde též nezohlednil.
model <- glm(type ~ npreg + glu + bmi + ped, data = Pima.te, family = binomial)
summary(model)

# Zde byla otázka na interpretaci výsledku predict.
result <- predict(model, newdata = data.frame(npreg = 4, glu = 80, bmi = 23, ped = 0.5))
result

# Test multikolinearity
# - VIF < 5 (regresory jsou na sobě nezávislé)
# - VIF > 10 (regresory spolu silně souvisý)
vif(model)

or <- exp(coef(model))
ci <- exp(confint(model))
result <- round(cbind(OR = or, CI = ci), 3)
print(result)

# Odds Ration (Poměr šancí)
# - OR = 1 (žádný vliv)
# - OR > 1 (zvyšuje šanci)
# - OR < 1 (snižuje šanci)

# glu (OR = 1.039)
# - S každou jednotkou glukózy navíc roste šance na cukrovku o 3,9 % 
#   (1.039 - 1 = 0.039, což je 3,9 %)

# bmi (OR = 1.088)
# - S každým bodem BMI navíc roste šance na cukrovku o 8,8 % 
#   (1.088 - 1 = 0.088, což je 8,8 %)

# npreg (OR = 1.195)
# - S každým dalším těhotenstvím roste šance na cukrovku o 19,5 % 
#   (1.195 - 1 = 0.195, což je 19,5 %)

# ped (OR = 3.208)
# - S každou jednotkou indexu rodinné anamnézy roste šance na cukrovku o 220,8 % 
#   (3.208 - 1 = 2.208, což je 220,8 %)