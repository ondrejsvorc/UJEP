Zápočet: Ukázková aplikace s návrhovými vzory

C#
- syntaxe odvozená z jazyku C (poznáme dle složených závorek)
- statický typový systém (už v době překladu jsou známy datové typy)
- objektově-orientovaný
- třída Object je předkem všech

Java vs C#
- C# vznikl jako klon Javy
- Java konzervativní, C# inovativní

Návrhové vzory
- vznik kolem 1960
- nejsou fixní a zároveň trošku jejich implementace záleží na jazyce
- některé návrhové vzory mají speciální vestavěnou podporu (iterátor, singleton, …)

C#: Návrhové vzory
Pecinovský: Návrhové vzory pro Javu

Stáhnout Rider a zkusit si ho

C# -> přeloží se do bytecode -> ten se uloží do assembly, což je binární struktura, která obsahuje kód a metadata a je zapouzdřena do nějakého souboru (např. .exe, tedy standalone aplikace)

- datové typy 
	- hodnotové typy nepodléhají Garbage collectoru (zabírají méně paměti), nemohou nabývat null
	- čili nullable hodnotové typy mohou nabývat null, a už se musí dít boxing / unboxing
	- odkazové/refereční typy
	- boxing / unboxing

implicitně bez otazníku nebo Nullable<T> znamená, že jak hodnotové, tak referenční, nemohou být null
s otazníkem naopak dáváme kompilátoru najevo, že to null může být

když používáme metodu na hodnotovém typu, tak se musí provést boxing (proto mají jen metody zděděné od object)
proto existují statické metody (např. na char, string), aby se vyhnulo boxingu

- struct: je dobré používat pro držení hodnotových typů (v paměti se pak bude chovat jako hodnotový typ jako takový)

statická třída - množina statických metod a členů
lze dělat extension metody nad rozhraními (na tom je založen třeba LINQ)