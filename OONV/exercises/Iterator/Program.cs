class Program
{
    static void Main()
    {
        PeopleCollection collection = new();
        collection.AddPerson(new Person("Honza"));
        collection.AddPerson(new Person("Petr"));
        collection.AddPerson(new Person("Jirka"));

        IIterator<Person> iterator = collection.CreateIterator();

        while (iterator.HasMore())
        {
            Person person = iterator.GetNext();
            Console.WriteLine(person);
        }
    }
}

public record Person(string Name);

interface IIterator<T> where T : class
{
    public T GetNext();
    public bool HasMore();
}

interface IIterableCollection<T> where T : class
{
    public IIterator<T> CreateIterator();
}

class PeopleCollection : IIterableCollection<Person>
{
    private readonly List<Person> _people = [];

    public void AddPerson(Person person)
    {
        _people.Add(person);
    }

    public List<Person> GetPeople()
    {
        return _people;
    }

    public IIterator<Person> CreateIterator()
    {
        return new PeopleIterator(this);
    }
}

class PeopleIterator(PeopleCollection collection) : IIterator<Person>
{
    private readonly PeopleCollection _collection = collection;
    private int _currentIndex = 0;

    public Person GetNext()
    {
        if (!HasMore())
        {
            throw new InvalidOperationException("No more people in the collection.");
        }

        return _collection.GetPeople()[_currentIndex++];
    }

    public bool HasMore()
    {
        return _currentIndex < _collection.GetPeople().Count;
    }
}