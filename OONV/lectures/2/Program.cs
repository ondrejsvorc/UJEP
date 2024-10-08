namespace _2;

internal class Program
{
    static void Main(string[] args)
    {
        Zvire z = new Pes();
        z.Hlas();
        z.Jmeno();
    }
}

public class Zlomek
{
    // Zastupuje konstruktor bez parametrů, s jedním parametrem a se dvěma parametry
    public Zlomek(int citatel = 0, int jmenovatel = 1) { }
}

public abstract class Zvire
{
    public abstract string Hlas();

    public virtual string Jmeno()
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

public interface IFlyable
{
    int Altitude { get; }
    void TakeOff();
    void Land();
}

public class Dragon : IFlyable
{
    public void TakeOff()
    {
    }

    public void Land()
    {
    }

    public int Altitude => 0;
}