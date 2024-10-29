class Program
{
    static void Main()
    {
      IDialog dialog = new WindowsDialog();
      dialog.CreateButton();
      dialog.Render();
    }
}

public interface IButton
{
  public void Render();
  public void OnClick();
}

public interface IDialog
{
  public void Render();
  public IButton CreateButton();
}
public class WindowsDialog : IDialog
{
  public void Render()
  {
    IButton button = CreateButton();
    button.Render();
    Console.WriteLine("Rendering Windows dialog...");
  }

  public IButton CreateButton()
  {
    return new WindowsButton();
  }
}
public class WebDialog : IDialog
{
  public void Render()
  {
    IButton button = CreateButton();
    button.Render();
    Console.WriteLine("Rendering web dialog...");
  }

  public IButton CreateButton()
  {
    return new HtmlButton();
  }
}

public class WindowsButton : IButton
{
    public void OnClick()
    {
      Console.WriteLine("Clicked Windows button...");
    }

    public void Render()
    {
      Console.WriteLine("Rendering Windows button...");
    }
}
public class HtmlButton : IButton
{
    public void OnClick()
    {
      Console.WriteLine("Clicked HTML button...");
    }

    public void Render()
    {
      Console.WriteLine("Rendering HTML button...");
    }
}