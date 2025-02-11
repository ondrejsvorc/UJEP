using System.Xml.Linq;

class Program
{
    static void Main()
    {
        FileReader fileReader = new CsvReader();
        Console.WriteLine(fileReader.Read("numbers.csv").Sum());

        fileReader = new XmlReader();
        Console.WriteLine(fileReader.Read("numbers.xml").Sum());
    }
}

abstract class FileReader
{
    public IEnumerable<int> Read(string filePath)
    {
        if (string.IsNullOrWhiteSpace(filePath))
        {
            throw new ArgumentException("Invalid file path");
        }

        using StreamReader file = OpenFile(filePath);
        return ParseData(ExtractData(file));
    }

    protected StreamReader OpenFile(string path) => new(path);
    protected string ExtractData(StreamReader reader) => reader.ReadToEnd();
    protected abstract IEnumerable<int> ParseData(string data);
}

class CsvReader : FileReader
{
    protected override IEnumerable<int> ParseData(string data)
    {
        var lines = data.Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries);
        return lines.Skip(1).Select(int.Parse); // Skip header and parse numbers
    }
}

class XmlReader : FileReader
{
    protected override IEnumerable<int> ParseData(string data)
    {
        var xdoc = XDocument.Parse(data);
        return xdoc.Descendants("Number").Select(e => int.Parse(e.Value));
    }
}