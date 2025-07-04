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
10. PHP (pole, objekty, výjimky)
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

## 3.

### XML Schema
- novější alternativa k DTD
- narozdíl od DTD:
  - podporuje datové typy
  - podporuje jmenné prostory
  - píše se v XML
- způsob, kterým se píše XML Schema se řídí dle XML Schema Definition (XSD)
- `<xs:schema>` = kořenový element
  - atributy:
    - `xmlns:xs`
    - `targetNamespace`
    - `xmlns`
    - `elementFormDefault`
- `<xs:element>` = deklarace elementu
  - atributy:
    - `name` = název elementu
    - `type` = datový typ elementu
    - `default` = implicitní hodnota elementu
    - `fixed` = fixní/konstantní hodnota elementu
- `<xs:attribute>` = deklarace atributu
  - atributy:
    - `name` = název atributu
    - `type` = datový typ atributu
    - `default` = implicitní hodnota atributu
    - `fixed` = fixní/konstantní hodnota atributu
    - `use="required"` = označení atributu jako povinného
- datové typy:
  - `xs:string` = textový řetězec
  - `xs:decimal` = desetinné číslo
  - `xs:integer` = celé číslo
  - `xs:boolean` = pravdivostní hodnota
  - `xs:date` = datum
  - `xs:time` = čas


#### class.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<class
  xmlns="http://www.mojeschema.cz"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.mojeschema.cz class.xsd">
  <student>
    <firstname>Graham</firstname>
    <lastname>Bell</lastname>
    <age>20</age>
  </student>
</class>
```

#### class.xsd
```xml
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="http://www.mojeschema.cz"
           xmlns="http://www.mojeschema.cz"
           elementFormDefault="qualified">
  <xs:element name="class">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="student">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="firstname" type="xs:string"/>
              <xs:element name="lastname" type="xs:string"/>
              <xs:element name="age" type="xs:int"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
```

### XSD omezení
- synonymum fazety
- používají se pro definici přípustných hodnot elementů a atributů

```xml
<xs:element name="cena">
  <xs:simpleType>
    <xs:restriction base="xs:integer">
      <xs:minInclusive value="10"/>
      <xs:maxInclusive value="100"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

```xml
<xs:element name="ovoce">
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:enumeration value="jablko"/>
      <xs:enumeration value="pomeranč"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

```xml
<xs:element name="jmeno">
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:pattern value="[A-Z][a-z]{2}"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

```xml
<xs:element name="heslo">
  <xs:simpleType>
    <xs:restriction base="xs:string">
      <xs:minLength value="5"/>
      <xs:maxLength value="12"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

```xml
<xs:whiteSpace value="preserve"/> <!-- zachová vše tak, jak je: mezery, taby, nové řádky -->
<xs:whiteSpace value="replace"/>  <!-- tabulátory a nové řádky se nahradí mezerami -->
<xs:whiteSpace value="collapse"/> <!-- všechny mezery se zredukují na jednu -->
```

### XSD indikátory
- dělí se na indikátory:
  - pořadí:
    - `<xs:all></xs:all>` = všechny podřízené elementy se musí vyskytovat, ale na pořadí nezáleží
    - `<xs:choice></xs:choice>` = musí se vyskytovat pouze jeden z podřízených elementů
    - `<xs:sequence></xs:sequence>` = všechny podřízené elementy se musí vyskytovat v daném pořadí
  - výskytu:
    - atribut `minOccurs` = minimální počet výskytů (implicitně 1)
    - atribut `maxOccurs` = maximální počet výskytů (implicitně 1)
  - skupiny:
    - `<xs:group name=""></xs:group>` = skupina elementů, kterou lze znovu použít
    - `<xs:attributeGroup name=""></xs:attributeGroup>` = skupina atributů, kterou lze znovu použít

```xml
<xs:all>
  <xs:element name="firstName" type="xs:string"/>
  <xs:element name="lastName" type="xs:string"/>
</xs:all>
```

```xml
<xs:choice>
  <xs:element name="email" type="xs:string"/>
  <xs:element name="phone" type="xs:string"/>
</xs:choice>
```

```xml
<xs:sequence>
  <xs:element name="firstName" type="xs:string"/>
  <xs:element name="lastName" type="xs:string"/>
</xs:sequence>
```

```xml
<xs:element name="middleName" type="xs:string" minOccurs="0"/>
```

```xml
<xs:group name="addressGroup">
  <xs:sequence>
    <xs:element name="street" type="xs:string"/>
    <xs:element name="city" type="xs:string"/>
  </xs:sequence>
</xs:group>
```
```xml
<xs:group ref="addressGroup"/>
```

```xml
<xs:attributeGroup name="commonAttrs">
  <xs:attribute name="id" type="xs:ID"/>
  <xs:attribute name="lang" type="xs:string"/>
</xs:attributeGroup>
```
```xml
<xs:complexType>
  <xs:attributeGroup ref="commonAttrs"/>
</xs:complexType>
```

## 4.

### XML a CSS
- CSS = **C**ascading **S**tyle **S**heets (kaskádové styly)
- soubor .xml se po otevření v prohlížeči zobrazuje jako text
- CSS umožňuje obsah .xml souboru zobrazit v hezké grafické podobě

table.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/css" href="table.css"?>
<table>
  <name>Stůl</name>
  <width>100</width>
  <height>50</height>
</table>
```
table.css
```css
table {
  border: 1px solid black;
}

name, width, height {
  display: block;
  margin: 5px;
}
```

### XML a XSL
- XSL = E**x**tensible **S**tylesheet **L**anguage
- umožňuje transformaci XML do jiného formátu (např. HTML)
- dále umožňuje filtrování, řazení, podmínky a smyčky
- skládá se z:
  - XSL se skládá z:
    - XSLT – jazyk pro transformaci
    - XPath – navigace a výběr dat

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="sbirka.xsl"?>
<sbírka>
  <kniha>
    <autor>Tolstoj</autor>
    <název>Válka a mír</název>
  </kniha>
</sbírka>
```

```xsl
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <body>
        <h1>Sbírka knih</h1>
        <table border="2">
          <tr bgcolor="yellow">
            <th>Autor</th>
            <th>Název</th>
          </tr>
          <xsl:for-each select="sbírka/kniha">
            <tr>
              <td><xsl:value-of select="autor"/></td>
              <td><xsl:value-of select="název"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
```

## 5.

### XPath
- XPath = XML Path Language
- indexace je od 1, ne od 0

```xml
<?xml version="1.0" encoding="UTF-8"?>
<sbirka>
  <kniha id="b1" jazyk="cs">
    <autor>Franz Kafka</autor>
    <nazev>Proměna</nazev>
    <rok_vydani>1915</rok_vydani>
    <naklad>30000</naklad>
  </kniha>
  <kniha id="b2" jazyk="en">
    <autor>George Orwell</autor>
    <nazev>1984</nazev>
    <rok_vydani>1949</rok_vydani>
    <naklad>500000</naklad>
  </kniha>
  <kniha id="b3" jazyk="ru">
    <autor>Lev Tolstoj</autor>
    <nazev>Válka a mír</nazev>
    <rok_vydani>1869</rok_vydani>
    <naklad>100000</naklad>
  </kniha>
</sbirka>
```

```
/sbirka/kniha/nazev                         <--- všechny názvy knih (absolutní cesta)
/sbirka/kniha[1]/nazev                      <--- název první knihy
/sbirka/kniha[last()]/autor                 <--- autor poslední knihy
//autor                                     <--- všichni autoři (kdekoli v dokumentu)
//kniha[@jazyk='cs']                        <--- knihy psané česky
//kniha[@id='b2']/nazev                     <--- název knihy s id="b2"
//kniha/naklad[text() > 100000]             <--- náklady větší než 100 000
//kniha[naklad > 100000]/nazev              <--- názvy knih s nákladem > 100 000
//kniha[autor='Franz Kafka']/rok_vydani     <--- rok vydání Kafkovy knihy
//kniha[2]/@jazyk                           <--- jazyk druhé knihy
//kniha/@id                                 <--- všechny hodnoty atributu id
//kniha[1]/../kniha[2]/nazev                <--- název druhé knihy (přes relativní cestu)
//kniha[1]/nazev/text()                     <--- text názvu první knihy
//kniha[@jazyk='ru'][position()=1]/autor    <--- autor první ruské knihy
//kniha[rok_vydani < 1900]/nazev            <--- knihy vydané před rokem 1900
//kniha[position() mod 2 = 1]/nazev         <--- názvy knih na lichých pozicích
//*                                         <--- všechny elementy v dokumentu
//@*                                        <--- všechny atributy v dokumentu
```

## 6.

### JavaScript
- skriptovací, interpretovaný jazyk s dynamickým typovým systémem
- proměňuje statickou stránku na dynamickou
- využití:
  - interakce s uživatelem
  - manipulace s HTML elementy
  - dynamické vykreslování obsahu

### JSON
- JSON = **J**ava**S**cript **O**bject **N**otation
- klíče i hodnoty jsou v uvozovkách (kromě čísel, boolean, null)
- struktura: objekty `{}`, pole `[]`, primitivní typy
- serializace = převod objektu na JSON (`JSON.parse`)
- deserializace = převod JSON na objekt (`JSON.stringify`)

#### person.json
```json
{
  "jmeno": "Jan",
  "vek": 25,
  "student": true,
  "znamky": [1, 2, 3],
  "kontakt": {
    "email": "jan@example.com"
  }
}
```

### Serializace
```javascript
const json = `{
  "jmeno": "Jan",
  "vek": 25,
  "student": true,
  "znamky": [1, 2, 3],
  "kontakt": {
    "email": "jan@example.com"
  }
}`;

const person = JSON.parse(json);
```

### Deserializace
```javascript
const person = {
  jmeno: "Jan",
  vek: 25,
  student: true,
  znamky: [1, 2, 3],
  kontakt: {
    email: "jan@example.com"
  }
};

const json = JSON.stringify(person);
```

```javascript
const xhr = new XMLHttpRequest();
xhr.open("GET", "person.json", true);
xhr.onload = () => {
  if (xhr.status !== 200) {
    console.error("Chyba při načítání JSON:", xhr.status);
    return;
  }
  const person = JSON.parse(xhr.responseText);
  console.log(person.jmeno); // "Jan"
};
xhr.send();
```

## 7.

### DOM
- DOM = Document Object Model
- objektová reprezentace HTML/XML dokumentu jako stromu uzlů
- každý HTML element je objekt
- přístup ke každému uzlu: čtení, úprava, mazání, přidávání

### Základní JavaScript metody pro manipulaci s DOM
- `document.getElementById`
- `document.querySelector`
- `document.querySelectorAll`
- `document.getElementsByClassName`
- `document.getElementsByTagName`

```html
<!DOCTYPE html>
<html lang="cs">
<head>
  <meta charset="UTF-8" />
  <title>DOM demo</title>
</head>
<body>
  <h1 id="nadpis">Nadpis</h1>
  <p class="paragraf">První odstavec</p>
  <p class="paragraf">Druhý odstavec</p>
  <div id="box">
    <span class="info">Info 1</span>
    <span class="info">Info 2</span>
  </div>
  <button id="tlacitko">Klikni</button>
</body>
</html>
```

```javascript
document.getElementById("nadpis");                  // <h1 id="nadpis">Nadpis</h1>
document.getElementsByClassName("paragraf");        // HTMLCollection(2) [<p>, <p>]
document.getElementsByTagName("span");              // HTMLCollection(2) [<span>, <span>]
document.querySelector("div#box span.info");        // <span class="info">Info 1</span>
document.querySelectorAll("p.paragraf");            // NodeList(2) [<p>, <p>]
```

```javascript
const nadpis = document.getElementById("nadpis");
nadpis.textContent = "Nový nadpis";
```

```javascript
const p = document.querySelector(".paragraf");
p.innerHTML = "<strong>Tučný text</strong>";
```

### Event
- česky událost
- akce, která se stane v dokumentu (např. kliknutí, pohyb myši, stisk klávesy)
- typy událostí:
  - onclick = kliknutí
  - oninput = změna hodnoty ve vstupním elementu
  - onsubmit = odeslání formuláře
  - onblur = element ztratí focus
  - ...
- s prefixem `on` se píšou do HTML, bez prefixu se pak píšou do `.addEventListener` (např. onclick v HTML, ale click v .addEventListener)

### Event Listener
- naslouchá události a reaguje na ni funkcí

```javascript
const btn = document.getElementById("tlacitko");
btn.addEventListener("click", () => {
  alert("Klik!");
});
```
```javascript
btn.removeEventListener("click", funkce);
```
```html
<form id="formular">
  <input type="text" placeholder="Zadej něco..." />
  <button type="submit">Odeslat</button>
</form>
```

```javascript
const form = document.getElementById("formular");
form.addEventListener("submit", (e) => {
  e.preventDefault(); // zabrání odeslání formuláře
  console.log("Formulář byl zachycen.");
});
```

## 8.

### XML DOM
- XML načtené jako strom (DOM)
- umožňuje přístup ke všem uzlům (element, atribut, text, ...)

```javascript
const xhr = new XMLHttpRequest();
xhr.open("GET", "knihy.xml", true);
xhr.onload = () => {
  const xml = xhr.responseXML;
  const knihy = xml.getElementsByTagName("kniha");
  console.log(knihy.length);
};
xhr.send();
```

```javascript
node.parentNode         // rodič
node.firstChild         // první potomek
node.lastChild          // poslední potomek
node.childNodes         // všechny děti
```

```javascript
node.nodeName           // název elementu
node.nodeValue          // hodnota (pro text, atribut)
node.nodeType           // typ uzlu
```

```javascript
let xmlDoc;
const xhr = new XMLHttpRequest();
xhr.open("GET", "knihy.xml", true);
xhr.onload = () => {
  if (xhr.status === 200) {
    xmlDoc = xhr.responseXML;
  }
};
xhr.send();
```

```javascript
const xmlString = `
<sbirka>
  <kniha>
    <autor>Franz Kafka</autor>
    <nazev>Proměna</nazev>
  </kniha>
</sbirka>`;

const parser = new DOMParser();
const xmlDoc = parser.parseFromString(xmlString, "text/xml");

const kniha = xmlDoc.getElementsByTagName("kniha")[0];
const autor = kniha.getElementsByTagName("autor")[0].textContent;
console.log(autor); // Franz Kafka
```

## 9.

### PHP
- skriptovací jazyk na straně serveru
- kód uvnitř `<?php ?>`
- proměnné začínají `$`

### HTML formulář
- párový tag, který umožňuje uživatelům zadávat a odesílat data
- má 2 hlavní atributy = action a method
- action = cesta ke skriptu, kterému se posílají data formuláře
- method = HTTP metoda, která se použije k odeslání dat (GET, POST)
  - GET = přenáší data formuláře v URL adrese jako součást adresy (využití: menší data, filtrování)
  - POST = přenáší data formuláře v těle požadavku (využití: větší nebo citlivá data)
- přístup v superglobálních proměnných $_POST a $_GET (asociativní pole)
- klíčem je hodnota atributu `name` konkrétního formulářového prvku

```html
<form method="post" action="zpracuj.php">
  <input name="jmeno">
  <button type="submit">Odeslat</button>
</form>
```
```php
$jmeno = $_POST["jmeno"];     // obsah input elementu
```

```php
file_put_contents("data.txt", "text");          // zápis
$obsah = file_get_contents("data.txt");         // čtení
```
```php
$f = fopen("data.txt", "w");
fwrite($f, "text");
fclose($f);
```

## 10.

### Pole
```php
$pole = array(1, 2, 3);        // indexované
$osoba = [                     // asociativní
  "jmeno" => "Anna",
  "vek" => 22
];

echo $osoba["jmeno"];          // Anna
echo $pole[0]                  // 1

foreach ($pole as $hodnota) {
  echo $hodnota;
}
foreach ($osoba as $klic => $hodnota) {
  echo "$klic: $hodnota";
}
```

### Třída
```php
class Osoba {
  public $jmeno;

  function __construct($jmeno) {
    $this->jmeno = $jmeno;
  }

  function pozdrav() {
    return "Ahoj, jsem $this->jmeno";
  }
}

$o = new Osoba("Jan");
echo $o->pozdrav();             // Ahoj, jsem Jan
```

### Výjimka
```php
try {
  throw new Exception("Chyba!");
} catch (Exception $e) {
  echo $e->getMessage();        // Chyba!
} finally {
  echo "Hotovo";
}
```

## 11.

### Odeslání JSON z klienta na server
- `json_encode`
- `json_decode`

#### example.html
```html
<!DOCTYPE html>
<html>
  <body>
    <button id="btn">Odeslat</button>
    <script>
      document.getElementById("btn").addEventListener("click", () => {
        const data = { jmeno: "Anna" };
        const xhr = new XMLHttpRequest();
        xhr.open("POST", "server.php", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onload = () => {
          if (xhr.status === 200) {
            const odpoved = JSON.parse(xhr.responseText);
            console.log(odpoved.vzkaz); // Ahoj, Anna
          }
        };
        xhr.send(JSON.stringify(data));
      });
    </script>
  </body>
</html>
```

#### server.php
```php
<?php
header("Content-Type: application/json");
$data = json_decode(file_get_contents("php://input"), true);
$jmeno = $data["jmeno"] ?? "neznámý";
echo json_encode(["vzkaz" => "Ahoj, $jmeno"]);
?>
```

## 12.

### DOM XML v PHP
- PHP má vestavěnou třídu `DOMDocument`
- umožňuje načítání, čtení, úpravy a zápis XML

#### knihy.xml
```xml
<sbirka>
  <kniha>
    <autor>Franz Kafka</autor>
    <nazev>Proměna</nazev>
  </kniha>
  <kniha>
    <autor>George Orwell</autor>
    <nazev>1984</nazev>
  </kniha>
</sbirka>
```

#### Čtení
```php
<?php
$xml = new DOMDocument();
$xml->load("knihy.xml");

$knihy = $xml->getElementsByTagName("kniha");

foreach ($knihy as $kniha) {
  $autor = $kniha->getElementsByTagName("autor")[0]->nodeValue;
  $nazev = $kniha->getElementsByTagName("nazev")[0]->nodeValue;
  echo "$autor – $nazev<br>";
}
?>
```

#### Úprava
```php
<?php
$xml = new DOMDocument();
$xml->load("knihy.xml");

$root = $xml->documentElement;
$nova_kniha = $xml->createElement("kniha");

$autor = $xml->createElement("autor", "Lev Tolstoj");
$nova_kniha->appendChild($autor);

$nazev = $xml->createElement("nazev", "Válka a mír");
$nova_kniha->appendChild($nazev);

$root->appendChild($nova_kniha);
$xml->save("knihy.xml");
?>
```

#### Tvorba
```php
<?php
$doc = new DOMDocument("1.0", "UTF-8");
$doc->formatOutput = true;

// kořen
$root = $doc->createElement("sbirka");
$doc->appendChild($root);

// 1. kniha
$kniha1 = $doc->createElement("kniha");
$kniha1->setAttribute("id", "1");

$autor1 = $doc->createElement("autor", "Franz Kafka");
$nazev1 = $doc->createElement("nazev", "Proměna");

$kniha1->appendChild($autor1);
$kniha1->appendChild($nazev1);
$root->appendChild($kniha1);

// 2. kniha
$kniha2 = $doc->createElement("kniha");
$kniha2->setAttribute("id", "2");

$autor2 = $doc->createElement("autor");
$autor2->appendChild($doc->createTextNode("George Orwell"));

$nazev2 = $doc->createElement("nazev");
$nazev2->appendChild($doc->createTextNode("1984"));

$kniha2->appendChild($autor2);
$kniha2->appendChild($nazev2);
$root->appendChild($kniha2);

// přístup a změna
$knihy = $doc->getElementsByTagName("kniha");
$knihy[0]->getElementsByTagName("nazev")[0]->nodeValue = "Zámek";

// uložení
$doc->save("vystup.xml");
```
Výstup tvorby
```xml
<?xml version="1.0" encoding="UTF-8"?>
<sbirka>
  <kniha id="1">
    <autor>Franz Kafka</autor>
    <nazev>Zámek</nazev>
  </kniha>
  <kniha id="2">
    <autor>George Orwell</autor>
    <nazev>1984</nazev>
  </kniha>
</sbirka>
```

## 13.

### SimpleXML
- jednodušší než DOMDocument
- vhodné pro čtení XML (ne moc pro úpravy)
- XML převede přímo na objekt (typu SimpleXMLElement)
  - objektový přístup: $xml->kniha[0]->autor
  - přístup k atributům: $kniha["id"]
  - přetypování je doporučeno: (string), (int), …
  - iteruje se pomocí foreach – jako u pole

#### Načtení XML
```php
<?php
$xml = simplexml_load_file("knihy.xml");

echo "<h3>Výpis knih:</h3>";

foreach ($xml->kniha as $kniha) {
  $id = (string) $kniha["id"];
  $autor = (string) $kniha->autor;
  $nazev = (string) $kniha->nazev;

  echo "<p>[$id] $autor – $nazev</p>";
}
?>
```

#### XSLT
```php
$xml = new DOMDocument();
$xml->load("knihy.xml");

$xsl = new DOMDocument();
$xsl->load("sablona.xsl");

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

echo $proc->transformToXML($xml);
```

#### sablona.xsl
```xsl
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/sbirka">
    <html><body>
      <xsl:for-each select="kniha">
        <p>
          <xsl:value-of select="autor" /> –
          <xsl:value-of select="nazev" />
        </p>
      </xsl:for-each>
    </body></html>
  </xsl:template>
</xsl:stylesheet>
```