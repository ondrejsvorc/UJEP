class Program
{
    static void Main()
    {
        SortContext sortContext = new();

        List<int> numbers = [5, 3, 8, 4, 2, 1, 7, 6];
        IEnumerable<int> bubbleSorted = sortContext.Sort(numbers);
        Console.WriteLine(string.Join(", ", bubbleSorted));

        List<int> numbersLonger = [5, 3, 8, 4, 2, 1, 7, 6, 10, 11, 12, 13, 15, 16, 18, 20, 21, 22, 23, 24, 30];
        IEnumerable<int> quickSorted = sortContext.Sort(numbersLonger);
        Console.WriteLine(string.Join(", ", quickSorted));
    }
}

interface ISorter
{
    public IEnumerable<int> Sort (IEnumerable<int> collection);
}

class SortContext : ISorter
{
    private readonly Dictionary<Func<int, bool>, ISorter> _sorters = new()
    {
        { collectionCount => collectionCount <= 20, new BubbleSorter() },
        { collectionCount => collectionCount > 20, new QuickSorter() }
    };

    public IEnumerable<int> Sort(IEnumerable<int> collection)
    {
        int count = collection.Count();

        ISorter sorter = _sorters
            .SingleOrDefault(x => x.Key(count))
            .Value;

        return sorter.Sort(collection);
    }
}

class BubbleSorter : ISorter
{
    public IEnumerable<int> Sort(IEnumerable<int> collection)
    {
        Console.WriteLine("Using bubble sort...");
        return BubbleSort(collection);
    }

    private IEnumerable<int> BubbleSort(IEnumerable<int> collection)
    {
        List<int> list = collection.ToList();
        bool swapped;

        do
        {
            swapped = false;
            for (int i = 0; i < list.Count - 1; i++)
            {
                if (Comparer<int>.Default.Compare(list[i], list[i + 1]) > 0)
                {
                    (list[i + 1], list[i]) = (list[i], list[i + 1]);
                    swapped = true;
                }
            }
        } while (swapped);

        return list;
    }
}

class QuickSorter : ISorter
{
    public IEnumerable<int> Sort(IEnumerable<int> collection)
    {
        Console.WriteLine("Using quick sort...");
        return QuickSort(collection.ToList());
    }

    private IEnumerable<int> QuickSort(List<int> collection)
    {
        if (collection.Count <= 1)
        {
            return collection;
        }

        int pivot = collection[0];
        List<int> less = [];
        List<int> greater = [];

        foreach (var item in collection.Skip(1))
        {
            if (Comparer<int>.Default.Compare(item, pivot) < 0)
            {
                less.Add(item);
            }
            else
            {
                greater.Add(item);
            }
        }

        IEnumerable<int> sortedLess = QuickSort(less);
        IEnumerable<int> sortedGreater = QuickSort(greater);

        return sortedLess.Concat([pivot]).Concat(sortedGreater);
    }
}