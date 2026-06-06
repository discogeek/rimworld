using RimWorld;
using Verse;

namespace GalacticRim
{
    public static class GR_PlantBiomeUtility
    {
        public static bool AllowedInBiome(ThingDef plantDef, BiomeDef biome)
        {
            if (plantDef == null || biome == null)
            {
                return true;
            }

            var ext = plantDef.GetModExtension<GR_PlantBiomeExtension>();
            if (ext == null)
            {
                return true;
            }

            if (!ext.allowedBiomeDefNames.NullOrEmpty())
            {
                return ext.allowedBiomeDefNames.Contains(biome.defName);
            }

            if (!ext.disallowedBiomeDefNames.NullOrEmpty() && ext.disallowedBiomeDefNames.Contains(biome.defName))
            {
                return false;
            }

            return true;
        }

        public static bool AllowedInCurrentBiome(ThingDef plantDef, Map map)
        {
            if (map == null)
            {
                return true;
            }

            return AllowedInBiome(plantDef, map.Biome);
        }
    }
}
