class Program
{
    static void Main()
    {
      IComponent kavovar = new Kavovar();
      kavovar.Execute();
      Console.WriteLine("");

      IComponent mlekoKavovar = new Mlekovar(kavovar);
      mlekoKavovar.Execute();
      Console.WriteLine("");

      IComponent mlekoCukroKavovar = new Cukrovar(mlekoKavovar);
      mlekoCukroKavovar.Execute();
    }
}

public interface IComponent
{
  public void Execute();
}
public class Kavovar : IComponent
{
  public void Execute()
  {
    Console.WriteLine("Kafe");
  }
}

public abstract class Prislusenstvi : IComponent
{
  private readonly IComponent _wrappee;

  public Prislusenstvi(IComponent wrappee)
  {
    _wrappee = wrappee;
  }

  public virtual void Execute()
  {
    _wrappee.Execute();
  }

  protected abstract void Extra();
}

public class Mlekovar : Prislusenstvi
{
    public Mlekovar(IComponent wrappee) : base(wrappee)
    {
    }

    public override void Execute()
    {
        base.Execute();
        Extra();
    }

    protected override void Extra()
    {
      Console.WriteLine("Přidal jsem mléko.");
    }
}

public class Cukrovar : Prislusenstvi
{
    public Cukrovar(IComponent wrappee) : base(wrappee)
    {
    }

    public override void Execute()
    {
      base.Execute();
      Extra();
    }

    protected override void Extra()
    {
      Console.WriteLine("Přidal jsem cukr.");
    }
}