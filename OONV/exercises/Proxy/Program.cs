class Program
{
    static void Main()
    {
      Proxy proxy = new(new Service());
      proxy.Operate();
    }
}

interface IService
{
  void Operate();
}
class Service : IService
{
  public void Operate()
  {
    Console.WriteLine("Operating...");
  }
}

class Proxy : IService
{
  private readonly IService _service;

  public Proxy(IService service)
  {
    _service = service;
  }

  public bool CheckAccess() 
  {
    return true; 
  }

  public void Operate() 
  {
    if (!CheckAccess())
    {
      return;
    }

    _service.Operate();
  }
}