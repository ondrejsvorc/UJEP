class Program
{
    static void Main()
    {
      
    }
}

interface IShape
{
    void Draw(int x, int y);
}

interface IPath
{
    void DrawPath(params BezierSegment[] segments);
}

class BezierSegment(Point start, Point end, Point control)
{
    private readonly Point _start = start;
    private readonly Point _end = end;
    private readonly Point _control = control;
}

record struct Point
{
    int x, y;
}

// Využít Bridge (tyto tvary by měly být knihovnou)
// TODO: Rectangle, Line, Circle
// TODO: WinForms, Avalonia, Bitmap, (PDF), (WPF)
// 4 projekty (1. WinForms, 2. Avalonia, 3. Bitmap, 4. PDF)
// Nakreslit sněhuláka
// Např. pro čtverec předáme 4 bezier segmenty