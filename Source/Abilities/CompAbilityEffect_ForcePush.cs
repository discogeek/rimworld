using System;
using RimWorld;
using UnityEngine;
using Verse;

namespace GalacticRim
{
    public class CompProperties_AbilityForcePush : CompProperties_AbilityEffect
    {
        public int pushDistance = 2;
        public int stunTicks = 120;

        public CompProperties_AbilityForcePush()
        {
            compClass = typeof(CompAbilityEffect_ForcePush);
        }
    }

    public class CompAbilityEffect_ForcePush : CompAbilityEffect
    {
        public new CompProperties_AbilityForcePush Props => (CompProperties_AbilityForcePush)props;

        public override void Apply(LocalTargetInfo target, LocalTargetInfo dest)
        {
            base.Apply(target, dest);

            if (!target.IsValid || target.Pawn == null || parent.pawn == null)
            {
                return;
            }

            Pawn caster = parent.pawn;
            Pawn victim = target.Pawn;
            Map map = victim.MapHeld ?? caster.MapHeld;
            if (map == null)
            {
                return;
            }

            victim.stances?.stunner?.StunFor(Props.stunTicks, caster, addBattleLog: true);

            IntVec3 pushDir = GetPushDirection(caster.Position, victim.Position);
            if (pushDir == IntVec3.Zero)
            {
                pushDir = caster.Rotation.FacingCell;
            }

            IntVec3 destination = victim.Position;
            for (var i = 0; i < Props.pushDistance; i++)
            {
                IntVec3 candidate = destination + pushDir;
                if (!candidate.InBounds(map) || !candidate.Walkable(map))
                {
                    break;
                }

                destination = candidate;
            }

            if (destination != victim.Position)
            {
                victim.Position = destination;
            }

            MoteMaker.ThrowText(victim.DrawPos, map, "Force push!", Color.cyan);
        }

        private static IntVec3 GetPushDirection(IntVec3 from, IntVec3 to)
        {
            IntVec3 delta = to - from;
            if (delta.x == 0 && delta.z == 0)
            {
                return IntVec3.Zero;
            }

            return new IntVec3(Math.Sign(delta.x), 0, Math.Sign(delta.z));
        }

        public override bool Valid(LocalTargetInfo target, bool throwMessages = false)
        {
            if (!target.IsValid || target.Pawn == null)
            {
                return false;
            }

            if (target.Pawn == parent.pawn)
            {
                return false;
            }

            return base.Valid(target, throwMessages);
        }
    }
}
