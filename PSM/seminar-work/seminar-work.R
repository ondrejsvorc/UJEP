setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load("SatData.RData");

# Počet respondentů
nrow(satisfaction)

# Škála proměnných
summary(satisfaction)

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

# Vytvoření kompozitních proměnných
IMAG <- pc1(satisfaction, blocks$IMAG)
EXPE <- pc1(satisfaction, blocks$EXPE)
QUAL <- pc1(satisfaction, blocks$QUAL)
VAL  <- pc1(satisfaction, blocks$VAL)
SAT  <- pc1(satisfaction, blocks$SAT)
LOYX <- pc1(satisfaction, blocks$LOYX)

dat <- data.frame(IMAG,EXPE,QUAL,VAL,SAT,LOYX,
                  switch = satisfaction$switch,
                  switch_bin = as.integer(satisfaction$switch >= 5))

# Rozdělení podle prahu switch >= 5
table(dat$switch_bin)
prop.table(table(dat$switch_bin)) * 100

# Logistická regrese pro odchod klienta
model <- glm(switch_bin ~ IMAG + EXPE + QUAL + VAL + SAT + LOYX, data=dat, family=binomial)
summary(model)

# Výpočet odds ratio a intervalů spolehlivosti
or <- exp(coef(model))
ci <- exp(confint(model))
round(cbind(or, ci), 3)

# Vizualizace rozdílů v loajalitě podle odchodu
boxplot(LOYX ~ switch_bin, data=dat, 
        names=c("Nechce odejít","Chce odejít"),
        main="Rozdíl v loajalitě podle rozhodnutí o odchodu")
