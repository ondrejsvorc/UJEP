## Úvod do strojového učení

### Užitečné zdroje
- https://drive.google.com/drive/folders/1f0D0NqCkrUqNKdc9jZDM1FpeRWiIOlF-

### Strojové učení
- cílem je vytvořit model, který se učí z dat a následně dělá predikce nebo rozhodnutí bez explicitního naprogramování pravidel
- podoblast umělé inteligence

### Úlohy strojového učení
- klasifikace
- regrese
- shlukování
- detekce anomálií
- redukce dimenzionality

### Glosář
- feature = vstupní proměnná (např. věk)
- feature space = prostor všech možných kombinací vstupních proměnných
- label = očekávaný výstup (např. nemoc ano/ne)
- model = matematická funkce, kterou se snažíme naučit

### Druhy strojového učení

#### Učení s učitelem
- anglicky supervised learning
- model se učí ze vstupních dat a zároveň i ze správných výstupů (labels)
- cílem je najít funkci, která mapuje vstupy na výstupy
- klasifikace, regrese

### KNN algoritmus
- k nearest neighbors (k-nejbližších sousedů)
- neparametrický algoritmus
- lze využít jak pro regresi, tak i pro klasifikaci
- předpovídá třídu nebo hodnotu nového datového bodu na základě jeho nejbližších sousedů
- pracuje s principem - body, které jsou si blízko si jsou podobné

### OvR
- One-vs-rest (jeden vs zbytek)
- způsob jak jak použít binární klasifikátor pro multiclass klasifikační problém
- binární klasifikátor umí rozlišit jen mezi 2 třídami - problém se musí rozdělit
- dekonstruuje multiclass úlohu na N binárních úloh, kde N = počet tříd
- pro N tříd se trénuje N binárních klasifikátorů (to dělá implicitně OvR, ty netrénujeme explicitně my)
- příklad:
  1. Řekněme, že chceš klasifikovat typ dokumentu podle jeho obsahu (článek, faktura, e-mail)
  2. Cílem je tedy klasifikovat vstupní text do jedné z těchto 3 tříd
  3. Udělá si 3 samostatné modely (je to článek, nebo něco jiného; je to faktura, nebo něco jiného; je to e-mail, nebo něco jiného) - proto ten název - jeden vs/nebo zbytek
  4. Každý model si vypočítá pravděpodobnost, takže třeba Model 1: 0.2 -> asi to nejsou noviny, Model 2: 0.8 -> dost možná to je faktura, Model 3: 0.4 -> asi ne e-mail
  5. Faktura má největší pravděpodobnost, takže daný obsah klasifikuje jako fakturu
  6. A stejným způsobem to dělá pro všechny data.

```python
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split

X, y = load_iris(return_X_y=True)  # 3 třídy
X_train, X_test, y_train, y_test = train_test_split(X, y)

model = LogisticRegression(multi_class='ovr')  # Zde říkáme, že se má použít OvR
model.fit(X_train, y_train)
```

#### Regrese
- cílem regrese je předpovědět spojitou (číslenou) hodnotu
- např. odhad ceny bytu, předpověď teploty, hmotnost člověka podle výšky
- hledá přímku, která co nejlépe prochází daty
- snaží se minimalizovat chybu mezi predikcí a realitou
- používá se metoda nejmenších čtverců (least squares)

#### Metriky regrese
- MAE (Mean absolute error)
- MSE (Mean squared error)
- R^2 score (koeficient determinace)

#### LASSO regrese (L1 regularizace)
- pokud feature není moc užitečný, nastav jeho váhu rovnou na nulu
- funguje jako automatický výběr feature
- některé vstupy úplně vyřadí
- použití:
  - když některé features jsou určitě zbytečné
  - chceš, aby si model sám vybral ty důležité

#### Ridge regrese (L2 regularizace)
- všechny feature nech v modelu, ale zmenši váhu těch neužitečných
- udrží všechny features
- změkčuje vliv těch, co nejsou moc důležité
- použití:
  - hodně features, ale chceš všechny využít
  - některé možná nejsou úplně relevantní (tak těm nastaví velmi malou váhu)

#### Logistická regrese
- učení s učitelem
- model tedy ví, co má predikovat a každému vstupu (x) je znám výstup (label, y)
- lineární model, který predikuje pravděpodobnost patření do třídy
- využívá sigmoidu

#### Princip logistické regrese
1. Máme nějaké vstupní atributy (features) - můžeme si je představit jako sloupce v tabulce.
2. Každý z těchto atributů dostane od modelu určitou váhu, která vyjadřuje, jak moc je daný atribut důležitý pro predikci/klasifikaci.
3. Například pokud máme atributy x1 (počet výskytů konkrétních slov), x2 (počet slov psaných VELKÝMI PÍSMENY), x3 (počet vykřičníků) a odpovídající váhy w1, w2, w3, model spočítá vážený součet jako: z = w1 * x1 + w2 * x2 + w3 * x3 + b,
kde b je tzv. bias - volitelný posun výsledku.
4. Tento výsledek z se následně vloží do aktivační funkce - v případě logistické regrese je to sigmoidní funkce, která převede výsledek na hodnotu mezi 0 a 1.
5. Výsledná hodnota se potom interpretuje jako pravděpodobnost, že daný vstup patří do určité třídy (například že e-mail je spam) - nazývejme ji `p`
6. Model se při učení učí, a to tím, že porovnává `p` se známým `y/labelem`, resp. spočítá pomocí ztrátové funkce, o jak moc se netrefil a upraví váhy tak, aby byl příště už blíž k realitě

#### Sigmoida
- transformuje libovolné číslo do intervalu (0, 1)
- nelinerální funkce
- sigma(z) = 1 / (1 + e^z), kde z je reálné číslo
- nabývá tedy hodnot od (0, 1)
  - limitně se přibližuje k 0, když jde do mínus nekonečna
  - limitně se přibližuje k 1, když jde do nekonečna
  - v bode 0 (z = 0) nabývá hodnoty 0.5
  - hodnota sigmoidy je interpretovatelná jako pravděpodobnost (např. 0.76 = 76 %)

#### Učení bez učitele
- anglicky unsupervised learning
- model se učí ze vstupních dat, ale nezná správné výstupy
- cílem je najít strukturu nebo nějaké vzory v datech
- shlukování, redukce dimenzionality

#### K-means algoritmus
- iterativní shlukovací algoritmus
- shluk se nazývá také cluster a shlukování také jako clusterování
- třídí data do `k` shluků na základě jejich vlastností
- parametr `k` se uvádí při volání algoritmu
- shluky jsou definovány svými centroidy, což jsou body ve stejném prostoru jako shlukované objekty
- objekty se zařazují do toho shluku, jehož centroidu jsou nejblíže
- parametry:
  - data
  - k = počet kýžených shluků
  - maximální počet iterací
- princip:
  1. Náhodné zvolení centroidů
  2. Výpočet vzdálenosti každého bodu od každého centroidu
  3. Označkování bodů do n množin, kde n je počet centroidů, na základě toho, k jakému centroidu jsou nejblíže
  4. Výpočet nových centroidů na základě průměrné hodnoty bodů v množinách
  5. Opakovat do určité doby (Konvergence / Maximum iterací)
  6. Znovuzvolení centroidů

#### Zpětnovazebné učení
- anglicky reinforcement learning
- základem je interakce s prostředím (zde se hovoří spíše o agentovi než o modelu)
- agent na základě pozorování volí akci a tou ovlivňuje prostředí
- odměny správné chování a tresty za to nesprávné

#### Kombinace učení s učitelem a bez učitele
- anglicky semi-supervised learning
- pouze k části vstupních dat je známý správný vstup

### Klasifikace
- přiřazení vstupu do jedné z předem definovaných tříd (kategorií)
- model, který provádí klasifikaci se nazývá **klasifikátor**

#### Druhy klasifikace
- binární = prvky mohou být právě v jedné ze dvou tříd (např. je spam / není spam)
- multiclass = prvky mohou být právě v jedné ze tří a více tříd (např. druh květiny)
- multilabel = prvky mohou být ve více třídách zároveň (např. tagy u článků)

### Algoritmy binární klasifikace
- logistická regrese
- algoritmus K-NN
- rozhodovací stromy (Decision Trees, DT)
- metoda podpůrných vektorů (Support Vector Machine, SVM)
- naivní Bayesovský klasifikátor (Naive Bayes)

### Hodnocení klasifikátorů
- matice záměn (confusion matrix)
- přesnost (accuracy)
- F1 skóre (F1 score)

#### Accuracy
- `TP + TN / (TP + TN + FP + FN)` = počet správných klasifikací (ať už pozitivních nebo negativních) děleno počet všech klasifikací
- kolik toho klasifikujeme správně

#### Precision
- prediktivní hodnota pozitivního testu (Positive Predictive Value)
- `TP / (TP + FP)` = počet správných klasifikací (pouze pozitivních) děleno počet všech klasifikací (pouze pozitivních)
- jak moc se dá věřit našemu ANO

#### Recall
- `TP / (TP + FN)` = počet správných klasifikací (pouze pozitivních) děleno počet všech správných pozitivních klasifikací a špatných negativních klasifikací
- jaký podíl všech ANO odhalíme

#### F1 skóre
- `2 * precision * recall / (precision + recall)`

#### Matice záměn
- tabulka, která ukazuje, kolik vstupů bylo správně a kolik špatně klasifikováno
- true positive (TP) = model správně poznal pozitivní případ
- true negative (TN) = model správně poznal negativní případ
- false positive (FP) = model špatně označil negativní případ jako pozitivní
- false negative (FN )= model nezachytil pozitivní případ a označil ho jako negativní
- True Positive Rate (TPR) = Senzitivita = kolik je správně klasifikováno pozitivních
- True Negative Rate (TNR) = Specificita = kolik je správně klasifikováno negativních
- konkrétní příklad matice záměn:
  - TP = správně označený spam
  - TN = správně označený normální e-mail
  - FP = normální e-mail chybně označený jako spam
  - FN = spam chybně označený jako normální

### Redukce dimenzionality
- cílem je zmenšit počet vstupních proměnných (features), aniž bychom ztratili zásadní informaci
- důvody: zrychlení výpočty a snížení přeučení

#### Metoda PCA
- metoda analýzy hlavních komponent
- Principal Component Analysis
- metoda učení bez učitele
- využívá Singular Value Decomposition (SVD)
- metoda na snížení počtu dimenzí mnohorozměrných dat
- umožňuje převést mnoho features  na několik málo, které jsou nezávislé  a zároveň zachycují maximum variability v datech

#### Metoda LDA
- Linear Discriminant Analysis
- metoda učení s učitelem

#### Další metody
- t-SNE
- UMAP

### Rozhodovací strom
- model, který dělá postupné rozhodnutí podle hodnot vstupních proměnných, dokud nedojde k výstupní třídě
- metoda učení s učitelem
- využití: regrese, klasifikace
- umí pracovat jak s kategoriálními, tak i numerickými daty
- jsou snadno interpretovatelné
- náchylné na přeučení (obzvlášť, když je strom příliš hluboký)
- skládá se z kořenového uzlu a dále se větví do dalších uzlů
- jsou binární (každý uzel má pouze 2 větve, 2 další uzly) nebo nebinární (alespoň jeden uzel má více než 2 uzly)
- další dělení může být na klasifikační a regresní

### Random Forest
- kolekce rozhodovacích stromů, jejichž výsledky jsou agregovány do jednoho

#### Impurita
- synonymum nečistota
- přesněji node impurity (nečistota uzlu)
- míra toho, jak moc jsou v daném uzlu pomíchané různé třídy
- více tříd, vyšší impurita
- cílem stromu je dělit data tak, aby impurita uzlů byla co nejnižší
- princip: pokud si náhodně vyberu jeden vzorek z uzlu a náhodně mu přiřadím třídu podle toho, jak často se tam třídy vyskytují, jaká je pravděpodobnost, že jsem ho označil špatně?

#### Entropie
- čím více jsou třídy ve stejném poměru, tím vyšší je entropie
- když uzel obsahuje jen jednu třídu -> entropie = 0 (ideální, žádná nejistota).

#### Gini impurity
- alternativa k entropii
- měří pravděpodobnost, že náhodně vybraný vzorek bude špatně klasifikován, pokud přiřadíme třídu náhodně podle četností

#### Prořezávání stromů (prunning)
- po tréninku může být strom příliš hluboký/přeučený
- prunning = zkracování stromu tím, že se odstraní části, které nepřinášejí zlepšení

#### Regresní stromy
- stromy, které neklasifikují, ale předpovídají číselnou hodnotu
- v uzlech není třída, ale průměr cílové proměnné

#### Seskupování stromů a lesy
- používáme více rozhodovacích stromů a jejich výstupy agregujeme

#### Bagging - Bootstrap Aggregating
- bootstrap = technika náhodného výběru dat s opakováním
- vytvoříme více trénovacích sad výběrem s opakováním z původních dat (takže bootstrap)
- pro každou sadu natrénujeme jeden strom
- výstupy stromů spočítáme dohromady (např. většinové hlasování) - typ stromů s největším počtem stejných výsledků vyhrává

#### Boosting
- trénuje se jeden strom po druhém
- každý nový strom se soustředí na chyby těch předchozích
- kombinují se váženě jejich výstupy

### Lineární klasifikátor
- model, který rozděluje vstupní prostor pomocí přímky (2D), roviny (3D), nebo hyperroviny (nD)
- vstupy (features) jsou body v prostoru a model najde "čáru", která odděluje třídy
- data jsou buď linerálně nebo nelinerálně separabilní

#### Perceptron
- nejjednodušší model neuronové sítě
- funguje jen pro lineárně separabilní data
- druhy: single-layer (SLP) a multi-layer (MLP)

#### Ztrátová funkce
- říká modelu, jak špatně se trefuje
- pro klasifikaci se většinou využívá Binary Cross-Entropy (také se nazývá Log-loss)

#### Aktivační funkce
- sigmoida
- hyperbolický tangens (tanh) = rozšíření oboru hodnot sigmoidy na interval od -1 do +1
- relu
- lulu (leaky relu)
- lineární
- softmax

#### Regularizace
- ochrana proti přeučení (overfitting)
- L1 (Lasso) – některé váhy stáhne přesně na nulu - výběr feature
- L2 (Ridge) – váhy "zmenší", ale nezruší

### SVM
- Support Vector Machine (Metoda podpůrných vektorů)
- funguje i pro nelineárně separabilní data (při použití kernelu)

#### Kernel trick
- jádrová transformace - kernelizace
- pomocí transformace převede vstupní prostor do vyšší dimenze, kde jsou data lineárně oddělitelná

#### Příklady jader
- lineární
- polynomiální
- RBF (Radial Basis Function)
- tanh

### Neuronová síť
- multi-layer perceptron je vlastně druh neuronové sítě
- aktivační funkce např. ReLU
- trénuje se pomocí zpětné propagace (backpropagation)