## MongoDB
- https://pepa.holla.cz/wp-content/uploads/2016/07/MongoDB-The-Definitive-Guide-2nd-Edition.pdf
- vše se vytváří automagicky
- pracuje s JSON a JavaScript a rozšiřuje jej o další datové typy (např. date, regular expression, object id, binary data, code)
- dokument může mít max. 16 MB
  - není optimalizovaná gigabytových souborů (např. video)
- dokumenty mohou být vnořené

### Názsvosloví
- dokument = řádek
- kolekce = tabulka

### Příkazy
- $set
- $unset
- $inc
- $push
- $each
- $sort
- $slice
- $gte
- $lte
- $lt
- $gt
- $in
- $nin
- $or
- $and

## Neo4j
- grafová databáze
- 2 verze
  - open-source (omezení na pouze jednu databázi)
  - komerční (bez omezení) - dockerizovaná verze je doporučena
- dotazovací jazyk Cypher (**není omezen na Neo4j!**)
- Neo4j Aura
- napíšeme Cypher -> vrátí JSON

### Cypher
- https://neo4j.com/docs/getting-started/cypher/
- deklarativní
- příkazy se píšou v pořadí, ve kterém se vykonávají
- podobný SQL
- popisuje uzly a hrany
- hrana je popisována hranatými závorkami
- uzly jsou popisovány kulatými závorkami
- properties uzlů jsou popisovány složenými závorkami
- orientovaný graf (když potřebujeme, můžeme ho chápat i jako neorientovaný)
- nodes a otherNodes je label
- labely vztahů SCREAMING SNAKE CASE, labely uzlů PascalCase

```
(:nodes)-[:ARE_CONNECTED_TO]->(:otherNodes)
```

#### Pattern matching
- všechny uzly, které splňují vzor (p:Person) - mají label Person
```
MATCH (p:Person)
RETURN p
```

### Příklady
```
CREATE (:MESTO { name: "Aš" })
CREATE (:MESTO { name: "Louny" })

MATCH (odkud:MESTO { name: "Aš" }), (kam:MESTO { name: "Louny" })
CREATE (odkud)-[:BUS]->(kam)

CREATE (from:MESTO { name: "Most" }), (to:MESTO { name: "Louny" }) CREATE (from)-[:BUS]->(to)

CREATE (:MESTO { name: "Most" })-[path:BUS]->(:MESTO { name: "Aš" }) RETURN path

CREATE (:MESTO { name: "Most" })-[path:BUS*]-(:MESTO { name: "Aš" }) RETURN path 

CREATE (:MESTO { name: "Most" })-[path:BUS*]-(:MESTO { name: "Aš" }) WHERE size(path) >= 1 RETURN path

CREATE (:MESTO { name: "Most" })-[path:BUS]->(:MESTO { name: "Louny" }) SET path.distance=20 RETURN path

MATCH (p) RETURN p
```