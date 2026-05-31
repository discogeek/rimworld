using HarmonyLib;
using RimWorld;
using Verse;

namespace GalacticRim
{
    [HarmonyPatch(typeof(PawnGenerator), nameof(PawnGenerator.GeneratePawn), typeof(PawnGenerationRequest))]
    public static class PawnGenerator_GeneratePawn_Patch
    {
        public static void Postfix(Pawn __result)
        {
            ForceAbilityUtility.TryGrantForcePush(__result);
        }
    }

    [HarmonyPatch(typeof(Pawn), nameof(Pawn.SpawnSetup))]
    public static class Pawn_SpawnSetup_Patch
    {
        public static void Postfix(Pawn __instance)
        {
            ForceAbilityUtility.TryGrantForcePush(__instance);
        }
    }

    [HarmonyPatch(typeof(TraitSet), nameof(TraitSet.GainTrait))]
    public static class TraitSet_GainTrait_Patch
    {
        public static void Postfix(TraitSet __instance, Trait trait)
        {
            if (trait?.def == GR_DefOf.GR_ForceSensitive)
            {
                ForceAbilityUtility.TryGrantForcePush(__instance.pawn);
            }
        }
    }
}
