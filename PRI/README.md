## PRI

### Užitečné odkazy
- https://github.com/JanBurle/UJEP/tree/main/KI-PRI
- https://github.com/pavelberanek91/UJEP/tree/main/PRI
- https://www.w3schools.com/xml/default.asp
- https://validator.w3.org/

### Okruhy ke zkoušce
1. XML (syntaxe, prolog, entity, jmenné prostory, definice well-formed, znaková sada)
   - první řádek XML souboru
   - deklarace elementů
   - atributy (povinné, nepovinné)
   - ...
2. DTD (interní, externí, elementy, obsah elementů, ...)
3. XML Schema
4. CSS a XSLT (zobrazení XML souboru)
5. xPath
6. JavaScript a JSON
7. JavaScript a DOM HTML (události, event listener, ...)
8. JavaScript a DOM XML (získání a procházení DOM, XMLHttpRequest, ...)
9. PHP (syntaxe, struktura, formuláře, práce se soubory)
10. PHP (pole, objekty, výjimky, )
11. PHP a JSON (jak odeslat konkrétní parametr na PHP, jak ho PHP zpracuje a jak klientovi vrátí JSON - resp. odesílání JSON z klienta na server a ze serveru zpátky na klienta)
12. PHP a DOM XML
13. SimpleXML, PHP a XSLT

Umět uvést jednoduché příklady. Budou nám k okruhu zadávány jednoduché úkoly.
1. příklad: Máme textový řetězec "abc abb abc" a chceme spočítat, kolikrát se v něm nachází každé z písmenek.
2. příklad: Náhodný výběr určitých prvků z pole (funkce rand).

## 1.

### XML
- XML = e**X**tensible **M**arkup **L**anguage (rozšiřitelný značkovací jazyk)

### XML dokument
- jakýkoliv text zapsaný podle pravidel XML
- nejčastěji obsah `.xml` souboru
- nemusí být vždy v souboru – může být v paměti, ve stringu, odpovědí z API, ...
- musímít kořenový element

### Značkovací jazyk
- používá značky (tags), kterými popisuje strukturu a význam dat

### Značka
- dělí se na:
  - počáteční (`<jmeno>`)
  - koncová (`</jmeno>`)
- case sensitive (`<jmeno>` != `<Jmeno>`)

### Element
- skládá se z:
  - počáteční značky
  - obsahu
    - jednoduchý = obsahuje pouze text
    - elementy = obsahuje vnořené elementy
    - směsný = obsahuje text i vnořené elementy
    - prázdný = neobsahuje nic (ani text, ani elementy)
  - koncové značky
- kořenový = musí existovat právě jeden v celém XML dokumentu, všechny další elementy jsou do něj vnořeny
- vnořený = element vnořený v jiném elementu (tedy všechny elementy krom kořenového)
- rodičovský = obsahuje jeden nebo více vnořených elementů (tedy kořenový element je zároveň rodičovský, obsahuje-li další elementy)
- sourozenecký = elementy se stejným rodičem, se stejnou úrovní vnoření
- dítě = element přímo vnořený v rodiči (dítě rodiče)
- vnuk =  element vnořený ve vnořeném elementu (dítě dítěte)

```xml
<kniha>
  <autor>
    <jmeno>Jan</jmeno>
  </autor>
</kniha>
```
Element `kniha` je kořenovým elementem a zároveň rodičem elementu `autor`. Element `autor` je rodičem elementu `jmeno`, který je jeho dítětem a zároveň vnukem elementu `zprava`.

### Značka vs Element
- značka je součástí syntaxe (syntaktický prvek)
- element tvoří strukturu dokumentu

### XML Prolog
- volitelný první řádek XML elementu
- pseudoelement (připomíná element, ale není elementem)
- pořadí atributů musí být dodrženo, u klasických elementů ne
- atribut `version`: označuje verzi XML, ve které je dokument napsán
- atribut `encoding`: uvádí kódování znaků, které je použito v dokumentu
- atribut `standalone`: určuje, zda je dokument samostatný, tj. zda nevyžaduje externí zdroj (DTD, XML schéma) pro validaci
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
```

### Atribut
- dělí se na:
  - povinný = musí mít explicitně definovanou hodnotu
  - nepovinný = má implicitní hodnotu
- hodnota atributu musí být vždy v uvozovkách (lze použít buď jednoduché nebo dvojité)
- slouží jako metadata (data o datech) - aby přidaly další informace o daném elementu
- může být přepsán na vnořený element daného elementu

### Globální built-in atributy
- `<student xml:space="" xml:lang=""></student>`
- `xml:space="default"` = zbaví se nadbytečných mezer
- `xml:space="preserve"` = ponechá mezery
- `xml:lang="cs"` = říká, že obsah daného elementu je v češtině

### Entita
- dělí se na:
  - interní = náhrada textem v dokumentu
  - externí = načítání obsahu z externího zdroje
- speciální sekvence znaků, které reprezentují znaky, jež nelze (nebo se nehodí) psát přímo do textu
- příklady:
  - `&lt;` = <
  - `&gt;` = >
  - `&apos;` = '
  - `&quot;` = "
```xml
<vyraz>5 &lt; 10</vyraz>
```

### Jmenný prostor
- anglicky namespace
- atribut `xmlns` (ns = namespace)
- deklarace atributu `xmlns:prefix="URI"` nebo `xmlns="URI"`
- jednoznačně rozlišuje elementy/atributy podle původu a zabraňuje kolizím
- pomocí prefixu u prvku říkáme, že on a všechny jeho potomci patří do určitého jmenného prostoru
- standardně má být URI nějaká URL adresa, která vysvětluje strukturu daného XML dokumentu, ale ve skutečnosti místo URI můžeme napsat cokoliv - je to jen unikátní identifikátor daného jméného prostoru

### Well-formed vs Validní XML dokument
- well-formed = dodržuje syntaktická pravidla XML a může být zpracován XML parserem
- validní = je well-formed + struktura vyhovuje DTD/XSD

### Komentář
- `<!-- Toto je komentář -->`
- nemůže být vnořený do jiného komentáře
- atributy elementů nemohou být zakomentovány
- nemůže se nacházet nad XML prologem
- je ignorován parsery

## 2.

### DTD
- DTD = **D**ocument **T**ype **D**efinition
- dělí se na:
  - interní = definovaný uvnitř XML dokumentu zaobalený v `<!DOCTYPE>`
  - externí = definovaný mimo XML dokument
  - případně lze tyto dva přístupy kombinovat, interní má větší prioritu
- definuje strukturu a legální elementy a atributy XML dokumentu
- externí DTD náchylné na XXE útok
- `#PCDATA` = Parsed Character Data

#### Interní DTD
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE note [
  <!ELEMENT note (to,from,heading,body)>
  <!ELEMENT to (#PCDATA)>
  <!ELEMENT from (#PCDATA)>
  <!ELEMENT heading (#PCDATA)>
  <!ELEMENT body (#PCDATA)>
]>
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
```

#### Externí DTD
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE note SYSTEM "note.dtd">
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
```
#### note.dtd
```xml
<!ELEMENT note (to,from,heading,body)>
<!ELEMENT to (#PCDATA)>
<!ELEMENT from (#PCDATA)>
<!ELEMENT heading (#PCDATA)>
<!ELEMENT body (#PCDATA)>
```

### DTD značky
- `<!DOCTYPE>` = deklarace typu dokumentu
- `<!ELEMENT>` = deklarace dokumentu
- `<!ATTLIST>` = deklarace atributů
- `<!ENTITY>` = deklarace entity

### ELEMENT
```xml
<!ELEMENT jmeno (#PCDATA)>        <!-- text -->
<!ELEMENT prazdny EMPTY>          <!-- prázdný obsah -->
<!ELEMENT vsechno ANY>            <!-- libovolný obsah -->
<!ELEMENT osoba (jmeno, vek?)>    <!-- , = sekvence, ? = nula nebo jeden -->
<!ELEMENT rodina (osoba+)>        <!-- + = jeden a více -->
<!ELEMENT multi (a | b)>          <!-- | = buď a, nebo b -->
```

### DTD entity
```xml
<!ENTITY autor "Jan Novak">
<autor>&autor;</autor>
```

### CDATA
- CDATA = Character Data
- narozdíl od PCDATA není parsovaný XML parserem
- ekvivalentní zápisy:
  - `<msg><![CDATA[2 < 5]]></msg>` = zde je obsahem dá se říct literál `2 < 5`
  - `<msg>2 &lt; 5</msg>` = zde je obsahem PCDATA a entita `&lt;` je parsována

### ATTLIST
- `<!ATTLIST název_elementu název_atributu typ implicitní_hodnota>`
```xml
<!ATTLIST student
  id ID #REQUIRED                             <!-- unikátní identifikátor, povinný -->
  obor (informatika|ekonomie) "informatika"   <!-- výčet, výchozí hodnota je "informatika" -->
  aktivni CDATA #IMPLIED                      <!-- volitelný textový atribut -->
  jazyk CDATA #FIXED "cz"                     <!-- neměnný textový atribut, vždy "cz" -->
>
```
```xml
<student id="s001" obor="ekonomie" aktivni="ano"/>
```