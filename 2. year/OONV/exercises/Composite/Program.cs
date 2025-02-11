class Program
{
    static void Main()
    {
      Composite composite = new();
      composite.Add(new Leaf());
      composite.Add(new Leaf());
      composite.Add(new Leaf());

      Composite composite2 = new();
      composite2.Add(new Leaf());
      composite2.Add(new Leaf());

      composite.Add(composite2);

      composite.Execute();
    }
}

interface IComponent
{
    public void Execute();
}

class Leaf : IComponent
{
    public void Execute()
    {
        Console.WriteLine("- Doing leaf logic...");
    }
}

class Composite : IComponent
{
    public List<IComponent> Children { get; private set; } = [];

    public void Add(IComponent component)
    {
        Children.Add(component);
    }

    public void Remove(IComponent component)
    {
        Children.Remove(component);
    }

    public void Execute()
    {
        Console.WriteLine($"Expanding composite...");
        foreach (IComponent child in Children)
        {
            child.Execute();
        }
    }
}
