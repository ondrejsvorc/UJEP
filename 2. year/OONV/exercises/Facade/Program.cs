class Program
{
    static void Main()
    {
        VideoConverter converter = new();
        FileInfo mp4File = converter.Convert("funny-cats-video.ogg", "mp4");
    }
}

class VideoConverter
{
    public FileInfo Convert(string filename, string format)
    {
        VideoFile file = new(filename);
        object sourceCodec = new CodecFactory().Extract(file);

        object destinationCodec = format == "mp4" 
            ? new MPEG4CompressionCodec() 
            : new OggCompressionCodec();

        byte[] buffer = BitrateReader.Read(filename, sourceCodec);

        // ...

        string outputFilename = Path.ChangeExtension(filename, format);
        return new FileInfo(outputFilename);
    }
}

class VideoFile(string filename)
{
    public string Filename { get; init; } = filename;
}

class OggCompressionCodec { }
class MPEG4CompressionCodec { }

class CodecFactory
{
    public object Extract(VideoFile file)
    {
        Console.WriteLine($"Extracting codec from {file.Filename}");
        return new object();
    }
}

class BitrateReader
{
    public static byte[] Read(string filename, object sourceCodec)
    {
        Console.WriteLine($"Reading file: {filename} with codec: {sourceCodec}");
        return [];
    }

    public static byte[] Convert(byte[] buffer, object destinationCodec)
    {
        Console.WriteLine($"Converting bitrate with codec: {destinationCodec}");
        return buffer;
    }
}

class AudioMixer
{
    public byte[] Fix(byte[] result)
    {
        Console.WriteLine("Adjusting audio in the result");
        return result;
    }
}