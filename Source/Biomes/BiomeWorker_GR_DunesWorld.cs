using RimWorld;
using RimWorld.Planet;
using Verse;

namespace GalacticRim
{
    /// <summary>
    /// Twin-sun dune world — hot, extremely dry, appears on arid world tiles.
    /// </summary>
    public class BiomeWorker_GR_DunesWorld : BiomeWorker
    {
        public override float GetScore(BiomeDef biome, Tile tile, PlanetTile planetTile)
        {
            if (tile.WaterCovered)
            {
                return -100f;
            }

            if (tile.hilliness == Hilliness.Impassable)
            {
                return 0f;
            }

            // Arid belt: very low rainfall, warm to scorching.
            if (tile.rainfall >= 280f)
            {
                return 0f;
            }

            if (tile.temperature < -5f)
            {
                return 0f;
            }

            if (tile.rainfall < 140f)
            {
                return tile.temperature > 18f ? 92f : 70f;
            }

            if (tile.rainfall < 220f)
            {
                return tile.temperature > 12f ? 72f : 45f;
            }

            return tile.temperature > 20f ? 40f : 0f;
        }
    }
}
