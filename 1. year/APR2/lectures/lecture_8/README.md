# Dědičnost (inheritance)

## Mechanismus v OOP jazycích

* zavedeno v Simule 68 
* podpora ve většině OOP jazyků

* mechanismus se může mírně lišit v různých OOP.
* využití se podstatně liší mezi různými OOP jazyky (a jak OOP návrh)
* kritika nadužívání (nepříjemné efekty)


Co je společné pro dědičnost:
    týká se tříd (nikoliv objektů), je to vztah mezi třídami

1. dědění (převzetí něčeho z bázové třídy)

   1.1 dědění metod

bázová třída -> odvození ->  odvozená třída
odvozená třída dědí všechny metody bázové třídy (lze je použít nejen
pro instance bazové, ale i odvozené)

```python
class X(list):
    pass

x = X()
len(x) # dědí __len__
x.append(2) # dědí append


```
    1.2.  dědění datových členů
        musí být děděny i datové členy (je nutné pro funkci zdědděných metod)
        !!! tento mechanismus je v Pythonu složitější

```python
class A:
    def __init__(self, data):
        self.data = data
    def print(self):
        print(self.data)

class B(A):
    pass
```

v zásadě funguje jen pokud nevyžadujeme nový konstruktor

2.  přidání a předefinování
    2.1 přidání metod

    lze přidat další metody

    2.2 přidání nových datových členů (objekt se rozšíří o datové členy)

    2.3 je nutné vytvořit nový konstruktor (je nutné inicializovat nové datové členy
        nelze použít původní konstruktor (zastínění resp. náhrada)

```python
class A:
    def __init__(self, data):
        self.data = data
    def print(self):
        print(self.data)

class B(A):
    def __init__(self, data, description):  # zastíní původní
        # je nutné volat konstruktor předka (aby inicializoval zdědené)
        super().__init__(data)
        self.description = description
        
    def get_description(self):  # přidaná metoda
        return self.description

    def print(self):
        print(f"{self.data} {self.description}")
    # byla zděděna metoda print
```
    2.4 je možno předefinovat metody (override)
        původní metodu nahradíme jinou (musí mít stejné jméno)

3. zajištění polymorfismu

polymorfismus: schopnost vytvořit kód, který umožňuje využívat objekty
různých tříd

x::Mecislo
x + 1
1 + x

a je int,double,str, všechny, které definují __add__
 OR
b je int,double,str všechny, které poddporuji __radd__

duck polymorfismus: v Pythonu nejsou důležité třídy, ale poskytované
metody

x.f()

duck: musí podporovat tu metodu
      musí plnit kontrakt (chování metody)
        kontrakt: precondition (co musí splňovat parametry)
                 postcondition (návratová hodnota, nový stav)
                 invariant (co metoda nezmění)
                 jaké výjimky vzniknou


dědičnost a polymorfismus
 * objekty bázové třídy lze považovat za objekty odvozené třídy
 * (substituční princip)
 * formální aspekt:
```python
a = A(5)
isinstance(a, A) # určitě True
b = B(8, "popisek")
isinstance(b, A) # instance odvozené je zároveň i instancí bázové třída
```

ale prekticky je dulěžitější reálná zastupitelnost:

jestliže použujeme objekty odvozené na místě, kde jsou očekávány
objekty bázové, tak nesmíme poznat rozdíl (splňují celý kontrakt)

v Pythonu dědičnost dodá jen formální aspekt (typová kontrola)
nepřidá kontrolu kontraktu

A je odvozeno z B tak platí A je podtyp B resp. B  je nadtyp A
bázová třída = nadtřída
odvozená třída = podtřída

## Použítí mechanismu dědičnosti v Pythonu

1. odvození z abstraktní bázové třídy
   class MyContainer(collections.abc.Container):
        ...

    důvod je polymorfismus:
        využit je mechanismus předefinování/přidaní  metod
   nepovinné! (duck polymorfismus)

2. mixiny
   v Pythonu lze dědit z vice tříd najednou (vícenásobná dědičnost) 
   
   dědíte ze dvou:
    základní třída (běžná třída s nějakým rozhraním, má datové členy)
    třída příměs: která dodává dodatečnou funkčnost 
    (má jen jednu jedinou metodu)
  
## Dědičnost jako implementace specializace/generalizace
  objekty specializované třídy:
    mají nějakou funkčnost navíc
    specializované chování metod (musí splňovat kontrakt obecné třídy, ale mohou něco přidávat)

  1. obecná třída
  2. specializovaná třída (objekty specializované třídy jsou vlastní podmnožinou obecné třídy)

### Princip substituce (Liskov Substitution Principle)
  musí být vztah podtypu a nadtypu

  dědičnost: je jeden z prostředků (možná nejlepší) pro implementaci specializace

  bázová třída : odvozená třída
  obecná třída : specializovaná třída
  nadtřída (nadtyp) : podtřída (podtyp)

  racionální čísla : celá čísla
  1. Jsou celá čísla speciálním případem racionálních čísel? 
    (ano, celá čísla jsou podmnožinou racionálních čísel)
  2. Platí substituční princip? (může vždy celé číslo stát za racionální? ano)

  class Rational:
    ...

  class Integer(Rational):
    ...

  existují specifické metody pouze pro Integer (ano, např. is_prime, modulo)
  bude potřeba něco (např. metody, číselné operace) předefinovat (ne)
  bude potřeba něco (např. atributy) přidat (ne, ale naopak v Integer je jeden navíc - jmenovatel je vždy 1)
  dědičnost v takovéto podobě není vhodná


  Třída Syn dědí ze třídy Otec - je to správně? (není to správně)
  muselo by platit: syni jsou podmnozinou otců
  muselo by platit: každý syn je zároveň otcem
  muselo by platit: kde očekáváte otce, lze použít syna

  Třída CerveneAuto dědí ze třídy Auto - je to správně? (není to správně)
  neplatí vztah specializace/generalizace
  není potřeba přidat nějaké metody
  není potřeba modifikovat metody
  nejsou potřeba nové atributy

  Třída Pes dědí ze třídy Savec - je to správně? (není to správně)
  Třída Pes dědí ze třídy Zivocich - je to správně?  (ano)
  Třída Hlodavec dědí ze třídy Zivocich a třída Kralik dědí ze třídy Hlodace - je to správně? (ano)
    
  Třída Zakaznik dědí ze třídy Zamestnanec - je to správně (není to správně)
  zákazník nemá mzdu, pracovní dobu, ...
  
  Třída Zamestnanec i Zakaznik dedi ze třídy Osoba - je to správně (ne tak úplně)
  Osoba - identifikátor, datum narození, pohlaví, adresa
  nepotřebujeme znát o každém zákazníkovi všechny tyto informace