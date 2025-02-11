using System.Text;
using System.Xml;

class Program
{
    static void Main()
    {
        ConverterHtmlToCsv converter = new();
        string html = @"
            <table>
                <tr>
                    <th>Company</th>
                    <th>Contact</th>
                    <th>Country</th>
                </tr>
                <tr>
                    <td>BMW</td>
                    <td>Maria Anders</td>
                    <td>Germany</td>
                </tr>
                <tr>
                    <td>Volkswagen</td>
                    <td>Francisco Chang</td>
                    <td>Germany</td>
                </tr>
            </table>
        ";
        string csv = converter.Convert(html);
        Console.WriteLine(csv);
    }
}

class ConverterHtmlToCsv
{
    public string Convert(string html)
    {
        StringBuilder csvBuilder = new();
        XmlDocument xmlDoc = new();

        xmlDoc.LoadXml(html);
        XmlNodeList? rows = xmlDoc.SelectNodes("//tr");
        if (rows is null)
        {
            return string.Empty;
        }

        List<string> rowValues = [];
        foreach (XmlNode row in rows)
        {
            XmlNodeList cells = row.ChildNodes;
            foreach (XmlNode cell in cells)
            {
                rowValues.Add(cell.InnerText.Trim());
            }

            csvBuilder.AppendLine(string.Join(";", rowValues));
            rowValues.Clear();
        }

        return csvBuilder.ToString();
    }
}


class Html
{
    private readonly string _content;
    public Html(string content)
    {
        _content = content;
    }
}

class Csv
{
    private readonly string _content;
    public Csv(string content)
    {
        _content = content;
    }
}

class CsvRenderer
{
    public void RenderGraph(Csv data)
    {
        Console.WriteLine("Rendering CSV...");
    }
}

interface IClient
{
    void RenderGraph(Html data);
}

class Adapter : IClient
{
    private readonly CsvRenderer _renderer;
    public Adapter(CsvRenderer renderer)
    {
        _renderer = renderer;
    }

    public void RenderGraph(Html data)
    {
        Csv convertedData = ConvertHtmlToCsv(data);
        _renderer.RenderGraph(convertedData);
    }

    private Csv ConvertHtmlToCsv(Html html)
    {
        return new Csv("");
    }
}