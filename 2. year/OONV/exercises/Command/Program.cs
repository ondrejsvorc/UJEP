class Program
{
    static void Main()
    {
        VsCodeEditor pythonEditor = new();

        Invoker copyInvoker = new(new CopyCommand(pythonEditor));
        Invoker pasteInvoker = new(new PasteCommand(pythonEditor));

        pythonEditor.SetText("Text ke zkopírování");
        copyInvoker.ExecuteCommand();
        pythonEditor.SetText("Text před vložením textu");
        pasteInvoker.ExecuteCommand();
    }
}

// Receiver
class VsCodeEditor
{
    public string Text { get; private set; } = string.Empty;
    private static string Clipboard { get; set; } = string.Empty;

    public void SetText(string newText)
    {
        Text = newText;
        Console.WriteLine($"Text: \"{Text}\"");
    }

    public void Copy()
    {
        Clipboard = Text;
        Console.WriteLine($"Copy: \"{Clipboard}\"");
    }

    public void Paste()
    {
        if (!string.IsNullOrEmpty(Clipboard))
        {
            Text += Clipboard;
            Console.WriteLine($"Paste: \"{Text}\"");
        }
        else
        {
            Console.WriteLine("Clipboard is empty, nothing to paste.");
        }
    }
}

class Invoker(Command command)
{
    private readonly Command _command = command;

    public void ExecuteCommand()
    {
        _command.Execute();
    }
}

abstract class Command(VsCodeEditor receiver, string parameters = "")
{
    protected readonly VsCodeEditor Receiver = receiver;
    protected readonly string Parameters = parameters;

    public abstract void Execute();
}

class CopyCommand(VsCodeEditor receiver, string parameters = "") : Command(receiver, parameters)
{
    public override void Execute()
    {
        Receiver.Copy();
    }
}

class PasteCommand(VsCodeEditor receiver, string parameters = "") : Command(receiver, parameters)
{
    public override void Execute()
    {
        Receiver.Paste();
    }
}
