class Program
{
    static void Main(string[] args)
    {
      Application app = new(new WinFactory());
      app.CreateUi();
      app.Paint();
    }
}

class Application
{
  private readonly IGuiFactory _factory;
  private readonly List<Button> _buttons = [];
  private readonly List<Checkbox> _checkboxes = [];

  public Application(IGuiFactory factory)
  {
    _factory = factory;
  }

  public void CreateUi()
  {
    _buttons.Add(_factory.CreateButton());
    _checkboxes.Add(_factory.CreateCheckbox());
    _buttons.Add(_factory.CreateButton());
  }

  public void Paint()
  {
    Console.WriteLine("Rendering...");
  }
}

interface IGuiFactory
{
  public Button CreateButton();
  public Checkbox CreateCheckbox();
}
class WinFactory : IGuiFactory
{
    public Button CreateButton()
    {
      Console.WriteLine("Creating Windows button...");
      return new WinButton();
    }

    public Checkbox CreateCheckbox()
    {
      Console.WriteLine("Creating Windows checkbox...");
      return new WinCheckbox();
    }
}
class MacFactory : IGuiFactory
{
    public Button CreateButton()
    {
      Console.WriteLine("Creating MAC button...");
      return new MacButton();
    }

    public Checkbox CreateCheckbox()
    {
      Console.WriteLine("Creating MAC checkbox...");
      return new MacCheckbox();
    }
}

abstract class Button { }
class WinButton : Button { }
class MacButton : Button { }

abstract class Checkbox { }
class WinCheckbox : Checkbox { }
class MacCheckbox : Checkbox { }