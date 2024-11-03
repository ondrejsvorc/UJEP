using System.Drawing;
using System.Numerics;

class Program
{
    static void Main()
    {
    }
}

class Canvas { }
class Particle
{
  public string Color { get; init; }
  public string Sprite { get; init; }

  public Particle(string color, string sprite)
  {
    Color = color;
    Sprite = sprite;
  }

  public void Move(Point coords, Vector3 vector, double speed) 
  {
    Console.WriteLine("Moving...");
  }

  public void Draw(Point coords, Canvas canvas) 
  { 
    Console.WriteLine("Drawing...");
  }
}

class MovingParticle
{
  private Particle _particle;
  private Point _coords;
  private Vector3 _vector;
  private double _speed;

  public MovingParticle(Particle particle, Point coords, Vector3 vector, double speed)
  {
    _particle = particle;
    _coords = coords;
    _vector = vector;
    _speed = speed;
  }

  public void Move() 
  {
    _particle.Move(_coords, _vector, _speed);
  }

  public void Draw(Canvas canvas) 
  {
    _particle.Draw(_coords, canvas);
  }
}