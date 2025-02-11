## Názvosloví

- `class A : B` -> A dědí z B / A rozšiřuje B
- `class A : IB` -> třída A implementuje B
- `interface IA : IB` -> IA rozšiřuje IB

## Dokumentace k rozhraním

- [IList\<T\>](https://learn.microsoft.com/cs-cz/dotnet/api/system.collections.generic.ilist-1?view=net-8.0)
- [ICollection\<T\>](https://learn.microsoft.com/cs-cz/dotnet/api/system.collections.generic.icollection-1?view=net-8.0)
- [IEnumerable\<T\>](https://learn.microsoft.com/cs-cz/dotnet/api/system.collections.generic.ienumerable-1?view=net-8.0)
- [IReadOnlyList\<T\>](https://learn.microsoft.com/cs-cz/dotnet/api/system.collections.generic.ireadonlylist-1?view=net-8.0)
- [IReadOnlyCollection\<T\>](https://learn.microsoft.com/cs-cz/dotnet/api/system.collections.generic.ireadonlycollection-1?view=net-8.0)
- [System.Func\<T, TResult\>](https://learn.microsoft.com/en-us/dotnet/api/system.func-2?view=net-8.0)
- [Kdy používat IEnumerable, ICollection, IList a List](https://www.claudiobernasconi.ch/2013/07/22/when-to-use-ienumerable-icollection-ilist-and-list/)

## Rozhraní kolekcí

- `IEnumerable` – poskytuje netypové enumerátory (= jen jiné slovo pro iterátory).
- `IEnumerable<T>` – rozšiřuje `IEnumerable`, vrací iterátor přes objekt typu `T`.
- `ICollection<T>` – rozšiřuje `IEnumerable<T>`, tedy jakákoliv kolekce má být iterovatelná (enumerovatelná).
- `IReadOnlyList<T>`

`IsReadOnly` – pozůstatek špatného návrhu pro zpětnou kompatibilitu (každý `List` by měl mít `False`, a `ReadOnlyList` by měl implementovat `IReadOnlyList`).

## Variance
- https://sw-samuraj.cz/2017/05/covariance-contravariance/
- https://learn.microsoft.com/cs-cz/dotnet/standard/generics/covariance-and-contravariance
- **Kovariance** - říká, že mezi komplexními typy není **žádný vztah**
- **Invariance** - umožňuje nahradit komplexní typ jeho **podtypem**
- **Kontravariance**  umožňuje nahradit komplexní typ jeho **nadtypem**

Komplexním typem může být např. generická kolekce nebo funkce.

### Příklad s třídami

```csharp
class Zvire { }
class Pes : Zvire { }
class Kocka : Zvire { }
```

### Invariance
```csharp
List<Zvire> x = new List<Pes>();
x.Add(new Kocka()); // při překladu OK, ale při běhu vznikne chyba
```

### Kovariance
- `<out T>`
```
A : B
ReadOnlyList<A> <: ReadOnlyList<B>
```

### Kontravariance
- `<in T>`
```
A : B, tak z toho plyne, že T<B> je podtypem T<A>
```

```
Func<in T, out TResult>
Func<T, TResult> -> int Funkce(double x) je vlastně Func<double, int>
                 -> parametry funkce jsou kontravariantní
                 -> návratové typy funkce jsou kovariantní

delegát - dvojice (odkaz this a metoda) - resp. není to jen metoda, ale je to metoda, která ví, na jakém objektu se volá
delegát na statickou metodu - dvojice (odkaz null a metoda)

class A {
  int Plus(int x) { }
}

delegate int intfunc (int x);
intfunc p = a.Plus();

Action<T> = procedura, splňuje ho jakákoliv metoda, která je void = void funkce (T parametr)
Action<T1, T2> = void funkce (T1 parametr1, T2 parametr2)

Func<T, TResult> = funkce s návratovou hodnotou

lambda výrazy

To vrátí delegát, který očekává int v parametru a vrací int Func<int, int>

3 různé zápisy:
(int x) => { return x + 1 };
(int x) => x + 1
x => x + 1 
```