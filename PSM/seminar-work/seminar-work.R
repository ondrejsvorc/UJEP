setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("SatData.RData");

cat("Počet respondentů:", nrow(satisfaction), "\n")
summary(satisfaction$switch)
hist(satisfaction$switch, breaks=seq(0.5, 10.5, by = 1), main="Rozložení odpovědí: Ochota odejít", xlab="switch")

# Škála proměnných
summary(satisfaction)
lapply(satisfaction, function(x) sort(unique(x)))
prop.table(table(satisfaction$switch))

cor(satisfaction[, c("switch","loyalty","return","recommendation")], use="complete.obs")

blocks <- list(
  IMAG = c("reputation","trustworthiness","seriousness","solidness","care"),
  EXPE = c("exp_products","exp_services","service","solutions","quality"),
  QUAL = c("qual_products","qual_services","range_products","qual_personal","qual_overall"),
  VAL  = c("benefits","investments","quality","price"),
  SAT  = c("satisfaction","expectations","comparison","performance"),
  LOYX = c("return","recommendation","loyalty")
)

# Extrahuje první hlavní komponenty (PC1 - PCA first component)
pc1 <- function(df, v) prcomp(df[, v], scale.=TRUE)$x[,1]

IMAG <- pc1(satisfaction, blocks$IMAG)
EXPE <- pc1(satisfaction, blocks$EXPE)
QUAL <- pc1(satisfaction, blocks$QUAL)
VAL  <- pc1(satisfaction, blocks$VAL)
SAT  <- pc1(satisfaction, blocks$SAT)
LOYX <- pc1(satisfaction, blocks$LOYX)

dat <- data.frame(IMAG,EXPE,QUAL,VAL,SAT,LOYX,
                  switch = satisfaction$switch,
                  switch_bin = as.integer(satisfaction$switch >= 8))

# Rozdělení podle prahu
table(dat$switch_bin)
prop.table(table(dat$switch_bin)) * 100

# Logistická regrese pro odchod klienta
model <- glm(switch_bin ~ IMAG + EXPE + QUAL + VAL + SAT + LOYX, data=dat, family=binomial)
summary(model)

# Výpočet poměru šancí a intervalu spolehlivosti
or <- exp(coef(model))
ci <- exp(confint(model))
round(cbind(or, ci), 3)

boxplot(LOYX ~ switch_bin, data=dat, 
        names=c("Nechce odejít","Chce odejít"),
        main="Rozdíl v loajalitě podle rozhodnutí o odchodu")

cat("\nVýznamné prediktory (p < 0.05):\n")
print(summary(model)$coefficients[summary(model)$coefficients[,4] < 0.05, ])



# ==============================================================================
# INTERPRETACE VÝSLEDKŮ PRO MANAŽERSKÝ GRAF
# ==============================================================================
# Výpočet dopadu v %: (1 - Odds Ratio) * 100
# Kladná hodnota (+) = snížení rizika odchodu (faktor, který drží klienta)
# Záporná hodnota (-) = zvýšení rizika odchodu
# ------------------------------------------------------------------------------

# 1. LOYX (Loajalita a doporučení)
# OR: 0.4886 | Dopad: +51 % | p < 0.001 (VÝZNAMNÉ)
# Klíčový faktor stability. Zvýšení loajality o 1 bod sníží šanci na odchod o 51 %.

# 2. IMAG (Image a důvěryhodnost banky)
# OR: 0.7605 | Dopad: +24 % | p = 0.024 (VÝZNAMNÉ)
# Významný faktor. Lepší reputace snižuje riziko odchodu o 24 %.

# 3. SAT (Celková spokojenost)
# OR: 0.8669 | Dopad: +13 % | p = 0.372 (NEVÝZNAMNÉ)
# Matematický náznak vlivu existuje, ale statisticky není v datech průkazný.

# 4. EXPE (Očekávání a zkušenosti)
# OR: 0.9168 | Dopad: +8 %  | p = 0.605 (NEVÝZNAMNÉ)
# Nízký a statisticky neprůkazný vliv na rozhodování o odchodu.

# 5. VAL (Vnímaná hodnota / Cena)
# OR: 0.9440 | Dopad: +6 %  | p = 0.793 (NEVÝZNAMNÉ)
# Cena a hodnota nejsou pro odchod klientů v tomto modelu rozhodující.

# 6. QUAL (Kvalita produktů a poradenství)
# OR: 1.0456 | Dopad: -5 %  | p = 0.799 (NEVÝZNAMNÉ)
# OR > 1 naznačuje mírný negativní vliv, ale výsledek je statisticky náhodný.
# ------------------------------------------------------------------------------