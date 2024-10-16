interface IType { }
class HouseType : IType
{
  private HouseType(int id) { }
  public static readonly HouseType Simple = new HouseType(0);
  public static readonly HouseType Complicated = new HouseType(1);
}
class FlatType : IType
{
  private FlatType(int id) { }
  public static readonly FlatType Ugly = new FlatType(0);
  public static readonly FlatType Beautiful = new FlatType(1);
}

class Product { }
class UstiProduct : Product { }
class OstravaProduct : Product { }

interface IDirector
{
  public void ChangeBuilder(IBuilder builder);
  public Product Make(IType type);
}
class Director : IDirector
{
  private IBuilder _builder;
  public Director(IBuilder builder)
  {
    _builder = builder;
  }

  public void ChangeBuilder(IBuilder builder)
  {
    _builder = builder;
  }

  public Product Make(IType type)
  {
    _builder.Reset();

    if (type is HouseType)
    {
      _builder.BuildStepA();
      _builder.BuildStepB();
    }
    else if (type is FlatType)
    {
      _builder.BuildStepA();
      _builder.BuildStepZ();
    }

    return _builder.GetResult();
  }
}

interface IBuilder
{
  public void Reset();
  public void BuildStepA();
  public void BuildStepB();
  public void BuildStepZ();
  public Product GetResult();
}

class OstravaBuilder : IBuilder
{
  private OstravaProduct _product = new OstravaProduct();

  public void Reset()
  {
    Console.WriteLine("OstravaBuilder - Reset");
    _product = new OstravaProduct();
  }

  public void BuildStepA()
  {
    Console.WriteLine("OstravaBuilder - StepA");
  }

  public void BuildStepB()
  {
    Console.WriteLine("OstravaBuilder - StepB");
  }

  public void BuildStepZ()
  {
    Console.WriteLine("OstravaBuilder - StepC");
  }

  public Product GetResult() 
  {
    return _product;
  }
}

class UstiBuilder : IBuilder
{
  private UstiProduct _product = new UstiProduct();

  public void Reset()
  {
    Console.WriteLine("UstiBuilder - Reset");
    _product = new UstiProduct();
  }

  public void BuildStepA()
  {
    Console.WriteLine("UstiBuilder - StepA");
  }

  public void BuildStepB()
  {
    Console.WriteLine("UstiBuilder - StepB");
  }

  public void BuildStepZ()
  {
    Console.WriteLine("UstiBuilder - StepC");
  }

  public Product GetResult() 
  {
    return _product;
  }
}

class Program
{
    static void Main(string[] args)
    {
      UstiBuilder tomas = new UstiBuilder();
      IDirector director = new Director(tomas);
      director.Make(HouseType.Complicated);

      OstravaBuilder pepa = new OstravaBuilder();
      director.ChangeBuilder(pepa);
      director.Make(FlatType.Beautiful);
    }
}