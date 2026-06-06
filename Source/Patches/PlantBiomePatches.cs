using System.Reflection;
using HarmonyLib;
using RimWorld;
using Verse;

namespace GalacticRim
{
    [HarmonyPatch]
    public static class PlantUtility_CanEverPlantAt_Bool_Patch
    {
        private static MethodBase TargetMethod()
        {
            return AccessTools.Method(
                typeof(PlantUtility),
                nameof(PlantUtility.CanEverPlantAt),
                new[] { typeof(ThingDef), typeof(IntVec3), typeof(Map), typeof(bool), typeof(bool) });
        }

        [HarmonyPostfix]
        public static void Postfix(ref bool __result, ThingDef plantDef, Map map)
        {
            if (!__result || plantDef?.plant == null || map == null)
            {
                return;
            }

            if (!GR_PlantBiomeUtility.AllowedInCurrentBiome(plantDef, map))
            {
                __result = false;
            }
        }
    }

    [HarmonyPatch]
    public static class PlantUtility_CanEverPlantAt_AcceptanceReport_Patch
    {
        private static MethodBase TargetMethod()
        {
            return AccessTools.Method(
                typeof(PlantUtility),
                nameof(PlantUtility.CanEverPlantAt),
                new[]
                {
                    typeof(ThingDef),
                    typeof(IntVec3),
                    typeof(Map),
                    typeof(Thing).MakeByRefType(),
                    typeof(bool),
                    typeof(bool),
                    typeof(bool)
                });
        }

        [HarmonyPostfix]
        public static void Postfix(ref AcceptanceReport __result, ThingDef plantDef, Map map)
        {
            if (!__result.Accepted || plantDef?.plant == null || map == null)
            {
                return;
            }

            if (!GR_PlantBiomeUtility.AllowedInCurrentBiome(plantDef, map))
            {
                __result = "Cannot grow in this biome.";
            }
        }
    }
}
