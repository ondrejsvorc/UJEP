class Program
{
    static void Main()
    {
      IDevice tv = new Television();
      IRemote remote = new Remote(tv);
      remote.TogglePower();
    }
}

public interface IRemote
{
  public void TogglePower();
  public void VolumeDown();
  public void VolumeUp();
  public void ChannelDown();
  public void ChannelUp();
}
public class Remote : IRemote
{
  private readonly IDevice _device;

  public Remote(IDevice device)
  {
    _device = device;
  }

  public void ChannelDown()
  {
  }

  public void ChannelUp()
  {
  }

  public void TogglePower()
  {
    if (_device.IsEnabled())
    {
      Console.WriteLine("Turning on device.");
      _device.Enable();
    }
    else
    {
      _device.Disable();
    }
  }

  public void VolumeDown()
  {
  }

  public void VolumeUp()
  {
  }
}

public class Channel { }

public interface IDevice
{
  public bool IsEnabled();
  public void Enable();
  public void Disable();
  public int GetVolume();
  public void SetVolume(int percent);
  public Channel GetChannel();
  public void SetChannel(Channel channel);
}
public class Television : IDevice
{
  public Television()
  {
  }

  public void Disable()
  {
  }

  public void Enable()
  {
  }

  public Channel GetChannel()
  {
    return new Channel();
  }

  public int GetVolume()
  {
    return 0;
  }

  public bool IsEnabled()
  {
    return true;
  }

  public void SetChannel(Channel channel)
  {
  }

  public void SetVolume(int percent)
  {
  }
}