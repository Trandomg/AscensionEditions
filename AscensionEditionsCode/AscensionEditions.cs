using Godot;
using HarmonyLib;
using MegaCrit.Sts2.Core.Logging;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Nodes.Cards;
using MegaCrit.Sts2.Core.Platform;
using MegaCrit.Sts2.Core.Runs;
using MegaCrit.Sts2.Core.Saves;
using MegaCrit.Sts2.Core.Saves.Managers;
using MegaCrit.Sts2.Core.Saves.Runs;

namespace AscensionStickers.AscensionStickersCode;

public class AscensionEditions
{
     [HarmonyPatch("UpdateWithRunData")]
     [HarmonyPatch(typeof(ProgressSaveManager))]
     internal class UpdateAscensionEditions
     {
          private static void Postfix(ProgressSaveManager __instance, SerializableRun serializableRun, bool victory)
          {
               bool flag1 = serializableRun.Players.Count == 1;
               bool flag2 = serializableRun.GameMode == GameMode.Daily;
               bool flag3 = serializableRun.GameMode == GameMode.Custom;
               SerializablePlayer? serializablePlayer;
               if (flag1)
               {
                    serializablePlayer = serializableRun.Players.First<SerializablePlayer>();
               }
               else
               {
                    ulong playerId = PlatformUtil.GetLocalPlayerId(serializableRun.PlatformType);
                    serializablePlayer = serializableRun.Players.FirstOrDefault<SerializablePlayer>((Func<SerializablePlayer, bool>) (p => (long) p.NetId == (long) playerId));
                    if (serializablePlayer == null)
                    {
                         Log.Warn($"Local player with net id {playerId} not found in run! Progress will not be updated");
                         return;
                    }
               }
               
               
               
               
               Dictionary<string,int> cardData = AscensionEditionsFileManager.LoadData();
               if (!flag2 && !flag3)
               {
                    string data = "";
                    foreach (ModelId hash in serializablePlayer.Deck
                                  .Select<SerializableCard, ModelId>((Func<SerializableCard, ModelId>)(c => c.Id))
                                  .ToHashSet<ModelId>())
                    {
                         //CardStats cardStats = __instance.Progress.GetOrCreateCardStats(hash);

                         if (victory)
                         {
                              if (cardData.ContainsKey(hash.ToString()))
                              {
                                   data += hash + "," + int.Max(serializableRun.Ascension, cardData[hash.ToString()]) + "\n";
                                   cardData.Remove(hash.ToString());
                              }
                              else
                              {
                                   data += hash + "," + serializableRun.Ascension + "\n";
                              }
                         }
                    }

                    foreach (string key in cardData.Keys)
                    {
                         data += key + "," + cardData[key] + '\n';
                    }
                    File.WriteAllText("mods\\AscensionEditions\\" + SaveManager.Instance.CurrentProfileId + "\\card.data", data);
                    AscensionEditionsFileManager.LoadData();
               }
          }
     }

     [HarmonyPatch("Reload")]
     [HarmonyPatch(typeof(NCard))]
     internal class ModelAscensionStickers
     {
          private static void Postfix(NCard __instance)
          {
               
               Dictionary<string, int>? cardData = AscensionEditionsFileManager.GetCardData();
               string? cardName = __instance.Model?.ToString().Split(' ')[0];
               if (cardName != null && cardData.ContainsKey(cardName))
               {
                    if (cardData[cardName] == 10)
                    {
                         ApplyShader(__instance, "_portrait");
                         ApplyShader(__instance, "_portraitBorder");
                         ApplyShader(__instance, "_ancientPortrait");
                    }
               }
          }

          private static void ApplyShader(NCard __instance, string fieldName)
          {
               var textRect = Traverse.Create(__instance).Field(fieldName).GetValue<TextureRect>();
               if (textRect == null)
               {
                    return;
               }
               Shader shaderHolo = GD.Load<Shader>("scenes/balatro_holo.gdshader");
               ShaderMaterial shaderMaterial = new ShaderMaterial();
               shaderMaterial.Shader = shaderHolo;
        
               ShaderMaterial material = new() { Shader = shaderHolo };
               textRect.Material = material;

          }
     }
}