# Evidence postav

Aplikace pro evidenci postav.

## Databáze postav

### Datum
* rok
* měsíc (nepovinný)
* týden (nepovinný)
* den v týdnu (nepovinný)

### Atributy postav
* jméno
* přezdívka (nepovinná)
* datum narození
* datum úmrtí (nepovinné)
* události [seznam]
  * start: datum
  * konec: datum
  * popisek
  * lokace

### Operace, která se hodí
* průřez aktivit postav v nějakém čase či intervalu

### Persistentní uložiště
* serializace do JSONu
* JSON soubor: pole objektů

### Uživatelské rozhraní
* momentálně skript
* v budoucnu něco příjemnějšího