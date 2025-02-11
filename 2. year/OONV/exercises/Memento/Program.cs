using System.Text;

class Program
{
    static void Main()
    {
        Editor editor = new();
        EditorCaretaker caretaker = new(editor);

        editor.AddWords("First");
        Console.WriteLine($"Current text: {editor.Text}");
        caretaker.Save();

        editor.AddWords(" Second");
        Console.WriteLine($"Modified text: {editor.Text}");

        caretaker.Undo();
        Console.WriteLine($"After undo: {editor.Text}");

        caretaker.Undo();
        Console.WriteLine($"After another undo: {editor.Text}");
    }
}

class Editor
{
    private readonly StringBuilder _textBuilder = new();
    public string Text => _textBuilder.ToString();

    public void AddWords(string words)
    {
        _textBuilder.Append(words);
    }

    public EditorMemento Save()
    {
        return new EditorMemento(Text);
    }

    public void Restore(EditorMemento memento)
    {
        _textBuilder.Clear();
        _textBuilder.Append(memento.Text);
    }

    public record EditorMemento(string Text);
}

class EditorCaretaker(Editor editor)
{
    private readonly Editor _editor = editor;
    private readonly Stack<Editor.EditorMemento> _history = new();

    public void Save()
    {
        Editor.EditorMemento memento = _editor.Save();
        _history.Push(memento);
    }

    public void Undo()
    {
        if (!_history.TryPop(out Editor.EditorMemento? memento))
        {
            return;
        }

        _editor.Restore(memento);
    }
}
