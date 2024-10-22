using System.Collections;
using System.Linq;

static class Program
{
    public static void Print<T>(this IEnumerable<T> source)
    {
      Console.WriteLine(string.Join(", ", source));
    }

    static void Main()
    {
      IList<int> list = new LimitedList<int>(3);
      list.Add(4);
      list.Add(2);

      foreach (int item in list)
      {
        Console.WriteLine(item); 
      }

      try
      {
        list.Add(5);
      }
      catch (Exception e)
      {
        Console.WriteLine($"Something went wrong: {e.Message}");
      }

      list.Print();

      // Ve skutečnosti se nyní nevykonal žádný kód
      // jen se vrátil iterátor.
      // Jakmile z toho udělám seznam, tak se kód vykoná
      // enumerator je lazy
      IEnumerable<int> newList = list
        .Where(x => x % 2 == 0)
        .Select(x => x + 1);

      // .AsParallel() - pomocí .OrderBy paralizaci zpomalíme, pro .GroupBy dobré, ...

      newList.Print();
    }
}

class LimitedList<T>(int maxLength) : IList<T>
{
    private readonly List<T> _data = new(Math.Min(maxLength, 1024));

    public T this[int index] { get => _data[index]; set => _data[index] = value; }
    public int Count => _data.Count;
    public bool IsReadOnly => false;

    public IEnumerator<T> GetEnumerator() => _data.GetEnumerator();
    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    public void Add(T item)
    {
      if (_data.Count == maxLength)
      {
        throw new Exception("List is full");
      }

      _data.Add(item);
    }

    public void Clear() => _data.Clear();
    public bool Contains(T item) => _data.Contains(item);
    public void CopyTo(T[] array, int arrayIndex) => _data.CopyTo(array, arrayIndex); 
    public int IndexOf(T item) => _data.IndexOf(item);
    public void Insert(int index, T item) => _data.Insert(index, item);
    public bool Remove(T item) => _data.Remove(item);
    public void RemoveAt(int index) => _data.RemoveAt(index);
}