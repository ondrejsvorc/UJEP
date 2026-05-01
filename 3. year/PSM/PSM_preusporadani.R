######################
### Odhady zalozene na preusporadani dat
######################
library(DescTools)

### Pouzijte data PlantGrowth
##  porovnava se vaha ziskane plodiny pri dvou osetrenich a jedne kontrolni skupine
data("PlantGrowth")

## Nejprve checeme odhadnout stredni hodnotu (populacni prumer) a rozptyl prumeru
wt <- PlantGrowth$weight 

### bezny postup 
(original_mean <- mean(wt))
  # prumer
(original_variance <- (MeanSE(wt))^2)
  # rozptyl prumeru

### vyuziti metody Jackknife
n <- length(wt)
jackknife_means <- numeric(n)
  
# vytvoreni n vyberu, kde kazdy ma jednu vynechanou hodnotu
for (i in 1:n) {
  jackknife_sample <- wt[-i]
  jackknife_means[i] <- mean(jackknife_sample)
}
  
# odhad metodou Jackknife
(jackknife_mean <- mean(jackknife_means))
# vychyleni (bias) odhadu
(bias <- (n - 1) * (original_mean - jackknife_mean))
# rozptyl odhadu
(jackknife_variance <- (n - 1) * mean((jackknife_means - jackknife_mean) ^ 2))
  
# jake je rozdeleni Jackknife odhadu?
hist(jackknife_means, col = "lightgreen")

### vyuziti Bootstrapu
# pocet bootstrapovych vyberu
num_resamples <- 1000

n <- length(wt)
bootstrap_means <- numeric(num_resamples)

# bootstrapove vybery s vracenim   
for (i in 1:num_resamples) {
    # Resample with replacement
  bootstrap_sample <- sample(wt, size = n, replace = TRUE)
  bootstrap_means[i] <- mean(bootstrap_sample)
}
  
# odhad metodou Bootstrap
(bootstrap_mean <- mean(bootstrap_means))
# vychyleni (bias) odhadu
(bias <- bootstrap_mean - original_mean)
# rozptyl odhadu
(bootstrap_variance <- var(bootstrap_means))

# jake je rozdeleni bootstrapoveho odhadu
hist(bootstrap_means, col = "lightblue")
  
# pro jednoducha data vsechny 3 metody dobre funguji

###################################
### Samostatne

## Jak odhadnout sikmost vahy?
## Odhadnete ruznymi zpusoby stredni hodnotu a rozptyl vyse hladiny Huronskeho jezera
data("LakeHuron")

# -0.1457988 - levostranné zešikmění
Skew(wt)

(mean(wt))
(var(wt))
(MeanSE(wt))^2

n <- length(wt)
jackknife_skews<- sapply(1:n, function(i) Skew(wt[-i]))
(jackknife_skew <- Skew(jackknife_skews))
(jackknife_bias <- (n - 1) * (Skew(wt) - jackknife_skew))
(jackknife_variance <- (n - 1) * mean((jackknife_skews - jackknife_skew)^2))
hist(jackknife_skews, col = "orange")

###################################

### pro odhad intervalu spolehlivosti se pouziva bud klasicky zpusob, nebo metoda bootstrap

## urcete interval spolehlivosti obema zpusoby
# vyjde Vam rucni vypocet bootstrapoveho intervalu spolehlivosti stejne / obdobne
#   jako pri pouziti prednastavene funkce?

jackknife_skew - sqrt(jackknife_variance)*qnorm(0.975)
jackknife_skew + sqrt(jackknife_variance)*qnorm(0.975)

BootCI(wt, FUN = Skew)

###################################
### Dvouvyberovy test

## porovnejte dva leky na spani
data("sleep")
  # promenna extra obsahuje informaci, o kolik se prodlouzil spanek

# Testovane hypotezy
#   H0: oba leky funguji stejne
#   H1: mezi leky je rozdil

### Klasicky postup
par(mfrow = c(1, 2))
tapply(sleep$extra, sleep$group, PlotQQ)
par(mfrow = c(1, 1))
  # graficky test normality, vse se zda OK

var.test(sleep$extra ~ sleep$group)
  # test shody rozptylu, vse se zda OK

t.test(sleep$extra ~ sleep$group, var.eq = T)
  # na hladine vyznamnosti 5% se mezi leky neprokazal vyznamny rozdil

### Permutacni test
set.seed(101) 
nsim <- 9999
res <- numeric(nsim) 

# generovani permutaci pro permutacni test
for (i in 1:nsim) {
  perm <- sample(nrow(sleep))
  psleep <- transform(sleep, extra = extra[perm])
  res[i] <- mean(psleep$extra[psleep$group == 1])-
    mean(psleep$extra[psleep$group == 2])
    # ulozim rozdil mezi prumery
}

obs <- mean(sleep$extra[sleep$group == 1]) - mean(sleep$extra[sleep$group == 2])
  # pozorovana hodnota rozdilu prumeru, pridam ji k nagenerovanym permutacnim hodnotam
res <- c(res, obs)

# zobrazeni vysledku spolu s nasi pozorovanou hodnotou
hist(res, col = "lightblue", las = 1, main = "")
abline(v = obs, col = "red")

# p-hodnota = procento vysledku v absolutni hodnote vetsi nez ten nas
mean(abs(res) >= abs(obs))
  # vysledek odpovida t-testu

###################################
### Samostatne

## Zkuste si test spocitat metodou bootstrap (tj. pro vyhodnoceni nepouzit permutace, ale bootstrapove vybery)

## Porovnejte prvni osetreni a kontrolu u dat PlantGrowth.
#   Porovnani provedte jak klasicky, tak permutacnim testem, tak bootstrapem

## Porovnejte vsechny tri osetreni uvedenymi tremi zpusoby
#   Jako statistiku vyhodnocujici rozdil mezi tremi vybery muzete pouzit napr.
#   sum(ni * mean(Yi)^2), tj. soucet pres vsechny skupiny pocet hodnot ve skupine krat prumer skupiny na druhou

data("PlantGrowth")

ctrl <- PlantGrowth$weight[PlantGrowth$group == "ctrl"]
trt1 <- PlantGrowth$weight[PlantGrowth$group == "trt1"]

obs <- mean(ctrl) - mean(trt1) # observation

set.seed(123)
B <- 10000
boot_diffs <- replicate(B, mean(sample(ctrl, replace = TRUE)) - mean(sample(trt1, replace = TRUE)))

mean(abs(boot_diffs) >= abs(obs))

hist(boot_diffs, col = "lightblue", main = "Bootstrap rozdíly")
abline(v = obs, col = "red", lwd = 2)

t.test(weight ~ group, data = subset(PlantGrowth, group %in% c("ctrl", "trt1")), var.equal = TRUE)

weight <- PlantGrowth$weight
group <- PlantGrowth$group
(group_sizes <- table(group))
(group_means <- tapply(weight, group, mean))
(obs_stat <- sum(group_sizes * group_means^2))

###################################

library(lmPerm)
  # knihovna obsahujici permutacni test ve funkci lmp

result <- lmp(formula = sleep$extra ~ sleep$group)
summary(result)