class Program
{
    static void Main()
    {
        Handler first = new FirstHandler();
        Handler second = new SecondHandler();
        Handler third = new ThirdHandler();

        first.SetNextHandler(second);
        second.SetNextHandler(third);

        first.Handle(new Request(RequestType.Third));  // OK
        first.Handle(new Request(RequestType.Fourth)); // Exception
    }
}

public abstract class Handler
{
    private Handler _next { get; set; } = new DefaultHandler();

    public void SetNextHandler(Handler handler)
    {
        _next = handler ?? new DefaultHandler();
    }

    public void Handle(Request request)
    {
        if (CanHandleRequest(request))
        {
            HandleRequest(request);
        }

        _next.Handle(request);
    }

    protected abstract void HandleRequest(Request request);
    protected abstract bool CanHandleRequest(Request request);
}

public class FirstHandler : Handler
{
    protected override void HandleRequest(Request request)
    {
        Console.WriteLine("Handling as first handler...");
    }

    protected override bool CanHandleRequest(Request request)
    {
        return request.Type is RequestType.First;
    }
}

public class SecondHandler : Handler
{
    protected override void HandleRequest(Request request)
    {
        Console.WriteLine("Handling as second handler...");
    }

    protected override bool CanHandleRequest(Request request)
    {
        return request.Type is RequestType.Second;
    }
}

public class ThirdHandler : Handler
{
    protected override void HandleRequest(Request request)
    {
        Console.WriteLine("Handling as third handler...");    
    }

    protected override bool CanHandleRequest(Request request)
    {
        return request.Type is RequestType.Third;
    }
}

public class DefaultHandler : Handler
{
    protected override void HandleRequest(Request request)
    {
        Console.WriteLine($"No handler available for request type: {request.Type}");
    }
        
    protected override bool CanHandleRequest(Request request)
    {
        return true;
    }
}

public enum RequestType
{
    First,
    Second,
    Third,
    Fourth
}

public class Request(RequestType type)
{
    public RequestType Type { get; } = type;
}