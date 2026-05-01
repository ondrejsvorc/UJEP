# Polymorfismus
- statický (v době překladu)
- dynamický

# Statický polymorfismus

## Přetypování
- implicitní (klíčové slovo implicit)
- explicitní (klíčové slovo explicit)
- https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/user-defined-conversion-operators
- pokud se při přetypování ztrácí informace (tak dělat explicitně)
- z int na double je implicitní, ale z double na int už explicitně (protože se ztrácí informace, a to desetinná část)

### Problém č. 1
Máme třídu Digit a chceme zařídit konverzi na typ int. Jsou 3 způsoby, jak to řešit:
1. int(Digit) - přetypovací konstruktor (nelze u int, protože je to vestavěný typ)
2. instanční metoda na třídě Digit (.ToInt)
3. přetypovací operátor
 
```C#
public readonly struct Digit
{
    private readonly byte digit;

    public Digit(byte digit)
    {
        if (digit > 9)
        {
            throw new ArgumentOutOfRangeException(nameof(digit), "Digit cannot be greater than nine.");
        }
        this.digit = digit;
    }

    public static implicit operator byte(Digit d) => d.digit;
    public static explicit operator Digit(byte b) => new Digit(b);

    public override string ToString() => $"{digit}";
}
```

# Přetěžování
- metod/operátorů
- schopnost mít metodu se stejným jménem, ale s jiným počtem parametrů anebo se stejným, ale s parametry s jinými datovými typy
- těžko přepsatelné do jazyků, které přetěžování nepodporují (např. Python)

```C#
double Sin(double x);
double Sin(int x);
```

```C#
public class Zlomek
{
    // Zastupuje konstruktor bez parametrů, s jedním parametrem a se dvěma parametry
    public Zlomek(int citatel = 0, int jmenovatel = 1) { }
}
```

# Generické typy (Generics)
- způsob jak třídy a metody parametrizovat pomocí typů

```C#
List<T> = generický typ, který má jeden typový parametr a jmenuje se List

Tuple<T1>
Tuple<T1, T2>
Tuple<T1, T2, T3>

// Specializace = dosazení za typové parametry, tak dostaneme tzv. konkrétní typ, což je typicky třída (např. )
List<int>
Tuple<int, int>
```

```
C# generika = specializace za překladu

List<T>, Add(T item) - když udělám List<int>, tak překladač vygeneruje metody s T parametrem se zvoleným typovým parametrem (tedy int)
```

### Fáze překladu
1. Vlastní překlad - kontrola generických typů
1. Překlad před během - bytecode
1. Překlad bytecode do strojového kódu (JIT, AOT)
   - JIT (Just in Time) = každou funkci při prvním volání přeloží, a pak už ji nepřekládá
   - AOT (Ahead of Time) = přeloží vše dopředu
1. Specializace generických typů (generika zmizí, jsou nahrazeny a přeloženy pro konkrétní kód, proto generika nejsou pomalejší než negenerické metody)
1. Běh (runtime)

# Dynamický polymorfismus
- dědičnost

## Dědičnost
- mechanismus pozdní vazby
- předefinování (override = chci, aby metoda byla jinou verzí metody, kterou jsem zdědil)
- shadowing (zastínění, překrytí metody rodiče)
- abstract metoda (očekáváme, že bude implementována potomkem, nemá tělo)
- virtual metoda (má defaultní tělo)
- když u nějaké metody/property v bázové třídě nevyspecifikuju abstract/virtual, tak je to implicitně virtual
- zastínění neexistuje v Pythonu
- jednoduchá dědičnost - grafem/relace dědičnosti je strom - lze dědit z jedné třídy (hiearchický pohled na svět)

```C#
public override string Hlas() { } // předefinování
public new string Hlas() { } // zastínění (měli bychom se mu vyhýbat, jen v případě kolize)
```

```C#
třída A: metody x, y
třída B dědí z A: dědí metody x, y a přidává z
třída A: přidá metodu z
```

```
public abstract class Zvire
{
    public abstract string Hlas();

    public virtual string Jmeno() // dovolujeme předefinování, kdybychom vynechali, tak to předefinovat potomkem nelze
    {
        return "";
    }
}

public class Pes : Zvire
{
    public override string Hlas()
    {
        return "Haf";
    }
}

Zvire z = new Pes();
z.Hlas();  // zavolá se metoda Hlas ze třídy Pes
z.Jmeno(); // zavolá se metoda Jmeno ze třídy Zvire
```

## Interface
- v základu může mít jen hlavičky metod, dnes i další možnosti
- schopnost něco dělat, schopnost mít nějaké metody
- nepoužíváme v něm identifikátory přístupu (public, )

```C#
public interface IFlyable
{
    void TakeOff();
    void Land();
    int Altitude { get; }
}
```

# Duck polymorfismus
- dynamic i;
- běžně se nepoužívá
- kontrola existence metod až při vykonání (za běhu)