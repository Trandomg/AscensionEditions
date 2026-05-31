using Godot;
using HarmonyLib;
using MegaCrit.Sts2.Core.Modding;
using MegaCrit.Sts2.Core.Nodes.Cards;

namespace AscensionStickers;

[ModInitializer(nameof(Initialize))]
public partial class MainFile : Node
{
    public const string
        ModId = "AscensionEditions";

    public static MegaCrit.Sts2.Core.Logging.Logger Logger { get; } =
        new(ModId, MegaCrit.Sts2.Core.Logging.LogType.Generic);

    public static void Initialize()
    {
        Harmony harmony = new(ModId);
        harmony.PatchAll();

        for (int i = 1; i < 4; i++)
        {
            string customSave = "mods\\AscensionEditions\\" + i;
            if (!Directory.Exists(customSave))
            {
                try
                {
                    Directory.CreateDirectory(customSave);
                    
                }
                catch (UnauthorizedAccessException e)
                {
                    GD.PushError("AscensionEditions could not created card data folders with exception " + e);
                }
            }

            if (!File.Exists(customSave+"\\card.data"))
            {
                try
                {
                    File.Create(customSave + "\\card.data").Close();
                }
                catch (FileNotFoundException e)
                {
                    GD.PushError("AscensionEditions could not created card data file with exception " + e);
                }
            }
        }
        
    }
}   