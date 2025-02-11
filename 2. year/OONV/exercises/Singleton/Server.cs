namespace Singleton;

internal class Server
{
    private static Server? _instance;
    private Server() { }

    public static Server GetInstance()
    {
        return _instance ??= new Server();
    }
}