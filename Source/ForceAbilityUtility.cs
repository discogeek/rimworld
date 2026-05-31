using RimWorld;
using Verse;

namespace GalacticRim
{
    public static class ForceAbilityUtility
    {
        public static void TryGrantForcePush(Pawn pawn)
        {
            if (pawn == null || !pawn.RaceProps.Humanlike)
            {
                return;
            }

            if (GR_DefOf.GR_ForceSensitive == null || GR_DefOf.GR_ForcePush == null)
            {
                return;
            }

            if (!pawn.story?.traits?.HasTrait(GR_DefOf.GR_ForceSensitive) ?? true)
            {
                return;
            }

            if (pawn.abilities == null)
            {
                return;
            }

            if (!pawn.abilities.abilities.Exists(a => a.def == GR_DefOf.GR_ForcePush))
            {
                pawn.abilities.GainAbility(GR_DefOf.GR_ForcePush);
            }
        }
    }
}
