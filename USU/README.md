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

#### Učení s učitelem
- anglicky supervised learning
- model se učí ze vstupních dat a zároveň i ze správných výstupů (labels)
- cílem je najít funkci, která mapuje vstupy na výstupy
- klasifikace, regrese

#### Učení bez učitele
- anglicky unsupervised learning
- model se učí ze vstupních dat, ale nezná správné výstupy
- cílem je najít strukturu nebo nějaké vzory v datech
- shlukování, redukce dimenzionality

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

#### Precision
- prediktivní hodnota pozitivního testu (Positive Predictive Value)
- `TP / (TP + FP)` = počet správných klasifikací (pouze pozitivních) děleno počet všech klasifikací (pouze pozitivních)

#### Recall
- `TP / (TP + FN)` = počet správných klasifikací (pouze pozitivních) děleno počet všech správných pozitivních klasifikací a špatných negativních klasifikací

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