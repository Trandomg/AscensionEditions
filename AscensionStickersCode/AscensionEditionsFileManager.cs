using System.Text;
using Godot;
using MegaCrit.Sts2.Core.Saves;

namespace AscensionStickers.AscensionStickersCode;

public static class AscensionEditionsFileManager
{
    private static Dictionary<string, int>? CardData;
    public static Dictionary<string , int> LoadData()
    {
          
        CardData = new Dictionary<string , int>();
        const Int32 BufferSize = 128;
        using (var fileStream = File.OpenRead("mods\\AscensionEditions\\" + SaveManager.Instance.CurrentProfileId + "\\card.data"))
        using (var streamReader = new StreamReader(fileStream, Encoding.UTF8, true, BufferSize)) {
            string? line;
            while ((line = streamReader.ReadLine()) != null)
            {
                string[] data = line.Split(',');
                string card = data[0];
                int ascension = data[1].ToInt();
                CardData.Add(card,ascension);
            }
        }
        return CardData;
    }

    public static Dictionary<string, int> GetCardData()
    {
        if (CardData == null)
        {
            return LoadData();
        }
        else
        {
            return CardData;
        }
    }
}