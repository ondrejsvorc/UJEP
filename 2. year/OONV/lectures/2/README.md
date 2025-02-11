# Polymorfismus
- statický (v dobì pøekladu)
- dynamický

# Statický polymorfismus

## Pøetypování
- implicitní (klíèové slovo implicit)
- explicitní (klíèové slovo explicit)
- https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/user-defined-conversion-operators
- pokud se pøi pøetypování ztrácí informace (tak dìlat explicitnì)
- z int na double je implicitní, ale z double na int už explicitnì (protože se ztrácí informace, a to desetinná èást)

### Problém è. 1
Máme tøídu Digit a chceme zaøídit konverzi na typ int. Jsou 3 zpùsoby, jak to øešit:
1. int(Digit) - pøetypovací konstruktor (nelze u int, protože je to vestavìný typ)
2. instanèní metoda na tøídì Digit (.ToInt)
3. pøetypovací operátor
 
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

# Pøetìžování
- metod/operátorù
- schopnost mít metodu se stejným jménem, ale s jiným poètem parametrù anebo se stejným, ale s parametry s jinými datovými typy
- tìžko pøepsatelné do jazykù, které pøetìžování nepodporují (napø. Python)

```C#
double Sin(double x);
double Sin(int x);
```

```C#
public class Zlomek
{
    // Zastupuje konstruktor bez parametrù, s jedním parametrem a se dvìma parametry
    public Zlomek(int citatel = 0, int jmenovatel = 1) { }
}
```

# Generické typy (Generics)
- zpùsob jak tøídy a metody parametrizovat pomocí typù

```C#
List<T> = generický typ, který má jeden typový parametr a jmenuje se List

Tuple<T1>
Tuple<T1, T2>
Tuple<T1, T2, T3>

// Specializace = dosazení za typové parametry, tak dostaneme tzv. konkrétní typ, což je typicky tøída (napø. )
List<int>
Tuple<int, int>
```

```
C# generika = specializace za pøekladu

List<T>, Add(T item) - když udìlám List<int>, tak pøekladaè vygeneruje metody s T parametrem se zvoleným typovým parametrem (tedy int)
```

### Fáze pøekladu
1. Vlastní pøeklad - kontrola generických typù
1. Pøeklad pøed bìhem - bytecode
1. Pøeklad bytecode do strojového kódu (JIT, AOT)
   - JIT (Just in Time) = každou funkci pøi prvním volání pøeloží, a pak už ji nepøekládá
   - AOT (Ahead of Time) = pøeloží vše dopøedu
1. Specializace generických typù (generika zmizí, jsou nahrazeny a pøeloženy pro konkrétní kód, proto generika nejsou pomalejší než negenerické metody)
1. Bìh (runtime)

# Dynamický polymorfismus
- dìdiènost

## Dìdiènost
- mechanismus pozdní vazby
- pøedefinování (override = chci, aby metoda byla jinou verzí metody, kterou jsem zdìdil)
- shadowing (zastínìní, pøekrytí metody rodièe)
- abstract metoda (oèekáváme, že bude implementována potomkem, nemá tìlo)
- virtual metoda (má defaultní tìlo)
- když u nìjaké metody/property v bázové tøídì nevyspecifikuju abstract/virtual, tak je to implicitnì virtual
- zastínìní neexistuje v Pythonu
- jednoduchá dìdiènost - grafem/relace dìdiènosti je strom - lze dìdit z jedné tøídy (hiearchický pohled na svìt)

```C#
public override string Hlas() { } // pøedefinování
public new string Hlas() { } // zastínìní (mìli bychom se mu vyhýbat, jen v pøípadì kolize)
```

```C#
tøída A: metody x, y
tøída B dìdí z A: dìdí metody x, y a pøidává z
tøída A: pøidá metodu z
```

```
public abstract class Zvire
{
    public abstract string Hlas();

    public virtual string Jmeno() // dovolujeme pøedefinování, kdybychom vynechali, tak to pøedefinovat potomkem nelze
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
z.Hlas();  // zavolá se metoda Hlas ze tøídy Pes
z.Jmeno(); // zavolá se metoda Jmeno ze tøídy Zvire
```

## Interface
- v základu mùže mít jen hlavièky metod, dnes i další možnosti
- schopnost nìco dìlat, schopnost mít nìjaké metody
- nepoužíváme v nìm identifikátory pøístupu (public, )

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
- bìžnì se nepoužívá
- kontrola existence metod až pøi vykonání (za bìhu)