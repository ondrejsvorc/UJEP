using System.Collections.Concurrent;

class Program
{
    static async Task Main()
    {
        TreeNode<string> root = new("Root");
        TreeNode<string> child1 = new("Child1");
        TreeNode<string> child2 = new("Child2");
        TreeNode<string> grandChild1 = new("GrandChild1");
        TreeNode<string> grandChild2 = new("GrandChild2");

        root.AddChild(child1);
        root.AddChild(child2);
        child1.AddChild(grandChild1);
        child2.AddChild(grandChild2);

        TreeCollection<string> tree = new(root);

        Task depthFirstTask = Task.Run(async () =>
        {
            IIterator<string> depthFirstIterator = tree.CreateDepthFirstIterator();
            while (depthFirstIterator.HasMore())
            {
                await Task.Delay(250);
                string current = depthFirstIterator.GetNext();
                Console.WriteLine($"[Thread: {Environment.CurrentManagedThreadId,-3}] Depth-First  : {current}");
            }
        });

        Task breadthFirstTask = Task.Run(async () =>
        {
            IIterator<string> breadthFirstIterator = tree.CreateBreadthFirstIterator();
            while (breadthFirstIterator.HasMore())
            {
                await Task.Delay(250);
                string current = breadthFirstIterator.GetNext();
                Console.WriteLine($"[Thread: {Environment.CurrentManagedThreadId,-3}] Breadth-First: {current}");
            }
        });

        await Task.WhenAll(depthFirstTask, breadthFirstTask);
        Console.WriteLine("Traversal complete.");
    }
}

public class TreeNode<T>(T value) where T : class
{
    public T Value { get; } = value;
    public List<TreeNode<T>> Children { get; } = [];

    public void AddChild(TreeNode<T> child)
    {
        Children.Add(child);
    }
}

public interface IIterator<T> where T : class
{
    T GetNext();
    bool HasMore();
}

public interface IIterableCollection<T> where T : class
{
    IIterator<T> CreateDepthFirstIterator();
    IIterator<T> CreateBreadthFirstIterator();
}

public class TreeCollection<T>(TreeNode<T> root) : IIterableCollection<T> where T : class
{
    private readonly TreeNode<T> _root = root;

    public IIterator<T> CreateDepthFirstIterator()
    {
        return new DepthFirstIterator<T>(_root);
    }

    public IIterator<T> CreateBreadthFirstIterator()
    {
        return new BreadthFirstIterator<T>(_root);
    }
}

public class DepthFirstIterator<T> : IIterator<T> where T : class
{
    // LIFO (věž, několik knih na sobě - přidáváme nahoru, bereme seshora)
    private readonly ConcurrentStack<TreeNode<T>> _stack = new(); 

    public DepthFirstIterator(TreeNode<T> root)
    {
        _stack.Push(root);
    }

    public T GetNext()
    {
        if (!HasMore())
        {
            throw new InvalidOperationException("No more elements.");
        }

        if (!_stack.TryPop(out TreeNode<T>? currentNode))
        {
            throw new InvalidOperationException("Stack is empty.");
        }

        foreach (TreeNode<T> child in currentNode.Children)
        {
            _stack.Push(child);
        }

        return currentNode.Value;
    }

    public bool HasMore()
    {
        return !_stack.IsEmpty;
    }
}

public class BreadthFirstIterator<T> : IIterator<T> where T : class
{
    // FIFO (fronta lidí - přidáváme na konec, bereme zepředu)
    private readonly ConcurrentQueue<TreeNode<T>> _queue = new();

    public BreadthFirstIterator(TreeNode<T> root)
    {
        _queue.Enqueue(root);
    }

    public T GetNext()
    {
        if (!HasMore())
        {
            throw new InvalidOperationException("No more elements.");
        }

        if (!_queue.TryDequeue(out TreeNode<T>? currentNode))
        {
            throw new InvalidOperationException("Queue is empty.");
        }

        foreach (TreeNode<T> child in currentNode.Children)
        {
            _queue.Enqueue(child);
        }

        return currentNode.Value;
    }

    public bool HasMore()
    {
        return !_queue.IsEmpty;
    }
}