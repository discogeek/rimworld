using HarmonyLib;
using Verse;

namespace GalacticRim
{
    [StaticConstructorOnStartup]
    public static class GalacticRimMod
    {
        static GalacticRimMod()
        {
            var harmony = new Harmony("discogeek.galacticrim");
            harmony.PatchAll();
            Log.Message("[Galactic Rim] Loaded.");
        }
    }
}
