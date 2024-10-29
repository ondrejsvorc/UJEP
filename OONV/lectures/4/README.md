## Jednodušeji definované třídy
- jen syntaktické pozlátko
- https://dl.ebooksworld.ir/books/CSharp.12.in.a.Nutshell.The.Definitive.Reference.9781098147440.pdf

### Anonymní typy
- možnost, jak vytvořit instance bez toho, aniž bychom definovali třídu
- návrhový vzor: přepravka, box (sloučení více hodnot do jednoho objektu)
- hodí se u LINQ (mezi)dotazů, kdy víme, že objekt nebudeme nikde předávat

### Tuples
- n-tice
- jsou mutable
- lze specifikovat jako návratový typ metody

### Records
- automaticky vygeneruje kopírovací konstruktor
- kompilují se do třídy
- 