class Program
{
    static void Main()
    {
        // Anonymní typ
        var dude = new { Name = "Bob", Age = 23 };
        Console.WriteLine(dude.Name);

        // Využití anonymního typu v LINQ dotazu
        List<int> numbers = [1, 2, 3];
        var result = numbers.Select(x => new { Number = x, BinaryRemainder = x % 2 });
        foreach (var item in result)
        {
            Console.WriteLine(item);
        }

        // N-tice.
        Tuple<int, int, int> t1 = new(1, 2, 3);
        (int, int, int) t2 = (1, 2, 3);

        (string, int) bob = ("Bob", 23);
        Console.WriteLine (bob.Item1); // Bob
        Console.WriteLine (bob.Item2); // 23

        (string, int) person = GetPerson();
        Console.WriteLine (person.Item1); // Bob
        Console.WriteLine (person.Item2); // 23
        (string, int) GetPerson() => ("Bob", 23);

        (string name, int age) tuple = (name: "Bob", age: 23);
        Console.WriteLine (tuple.name); // Bob
        Console.WriteLine (tuple.age); // 23

        (string name, int age, char sex) bob1 = ("Bob", 23, 'M');
        (string age, int sex, char name) bob2 = bob1; // No error!

        ValueTuple<string,int> bob3 = ValueTuple.Create ("Bob", 23);
        (string,int) bob4 = ValueTuple.Create ("Bob", 23);
        (string name, int age) bob5 = ValueTuple.Create ("Bob", 23);

        var bob6 = ("Bob", 23);
        (string name, int age) = bob6; // Deconstruct the bob tuple into separate variables (name and age).
        Console.WriteLine(name);
        Console.WriteLine(age);

        // Records
        Interval interval = new(1.0, 2.0);
        Console.WriteLine(interval);
        Console.WriteLine(interval.Length);
    }
}

record Interval(double Lower, double Upper)
{
    public double Length => Upper - Lower;
}
