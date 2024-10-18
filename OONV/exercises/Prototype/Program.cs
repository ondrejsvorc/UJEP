class Program
{
    static void Main(string[] args)
    {
      Person person = new("Jmeno", "Prijmeni", 18, new Address("Country", "City", "Street"));
      Person personClone = (Person)person.Clone();

      Console.WriteLine(person == personClone); // False
    }
}

interface IPrototype
{
  public IPrototype Clone();
}

class Person : IPrototype
{
    public string Name { get; init; }
    public string Surname { get; init; }
    public int Age { get; init; }
    public Address Address { get; init; }

    public Person(string name, string surname, int age, Address address)
    {
      Name = name;
      Surname = surname;
      Age = age;
      Address = address;
    }

    public Person(Person person)
    {
      Name = person.Name;
      Surname = person.Surname;
      Age = person.Age;
      Address = (Address)person.Address.Clone();
    }

    public IPrototype Clone()
    {
      return new Person(this);
    }
}

class Address : IPrototype
{
  public string Country { get; init; }
  public string City { get; init; }
  public string Street { get; init; }

  public Address(string country, string city, string street)
  {
    Country = country;
    City = city;
    Street = street;
  }

  public Address(Address address)
  {
    Country = address.Country;
    City = address.City;
    Street = address.Street;
  }

  public IPrototype Clone()
  {
      return new Address(this);
  }
}