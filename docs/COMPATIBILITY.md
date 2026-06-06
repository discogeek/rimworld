# Galactic Rim — Mod Compatibility

Galactic Rim is designed to **add** content, not replace vanilla or popular mod systems. This document explains how we avoid conflicts and how to load the mod alongside **Vanilla Expanded (VE)** and **Dubs** mods.

## Design principles

| Principle | What we do |
|---|---|
| Unique IDs | All defs use the `GR_` prefix (`GR_PulseRifle`, `GR_GalacticAuthority`, …) |
| Additive patches | Biome changes use `PatchOperationAdd` only — never replace another mod’s lists |
| Separate factions | **Galactic Authority** / **Free Systems Alliance** are new factions; we do **not** retheme the Empire, Rebels, or VFE factions |
| Minimal Harmony | Three small **postfix** patches for Force Push only; no transpilers, no broad rewrites |
| Optional DLC | Biotech droid content uses `MayRequire="Ludeon.RimWorld.Biotech"` |
| Load order | We load **after** Harmony, core DLC, VE Framework, and common Dubs mods when present |

## Recommended mod load order

```
Harmony
Core + DLC (Royalty, Ideology, Biotech, Anomaly, Odyssey)
Vanilla Expanded Framework (+ any VE modules you use)
Dubs mods (Bad Hygiene, Rimatomics, etc.)
… other content mods …
Galactic Rim   ← near the bottom, not at the top
```

In the RimWorld mod list, drag **Galactic Rim** below VE and Dubs. Our `About/About.xml` already declares `loadAfter` for common package IDs so Steam gets this mostly right automatically.

## Vanilla Expanded (VE)

**Expected compatibility: good**

- We do not patch VFE Empire, VFE Mechanoids, or VE weapon defs.
- Our factions use their own `categoryTag` values and do not override vanilla `Empire` / `Outlander` behavior.
- Research **Basic galactic arms** is a new node; it does not remove or move vanilla research.
- If you use **VFE Empire**, you will have both the vanilla-style Empire **and** Galactic Authority in the world — that is intentional for now. A future optional patch could reduce overlap (see roadmap).

**If something breaks with VE:** note which VE modules are enabled and share the log. Most issues are load-order or a specific cross-reference, not a fundamental clash.

## Dubs mods

**Expected compatibility: good**

- Galactic Rim does not modify power, plumbing, hygiene, or temperature systems.
- Dubs Bad Hygiene, Rimatomics, Mint Menus, Performance Analyzer, etc. should coexist without changes.
- Our mechanoid utility droid uses standard Biotech work types (`Hauling`, `Cleaning`, …) that Dubs does not override.
- Galactic Rim **does not ship** `0Harmony.dll`; use the **Harmony** Workshop mod (avoids version conflicts with VE/Dubs stacks).

## What can still overlap (by design)

These are gameplay overlaps, not hard errors:

- **Extra raids** — Galactic Authority adds another raiding faction alongside pirates, insects, and VE raids.
- **Cold biome animals** — pack beasts share spawn tables with muffalo and other mod animals; weights are low (0.04–0.07).
- **Trader variety** — Alliance caravans are an additional trader type.

## Testing checklist (with your full mod list)

1. Enable your usual stack + Galactic Rim; confirm **no red errors** on startup.
2. Start a **new colony** (or dev test map) and verify research tab shows **Basic galactic arms**.
3. Confirm **VFE / Dubs features** you rely on still work (e.g. hygiene, power, VE buildings).
4. Dev spawn **GR_UtilityDroid** — should be a **mechanoid** (requires Biotech).
5. Save / reload — no pink missing-def squares.

## Reporting conflicts

Please include:

- Full mod list (or screenshot of mod order)
- Player.log excerpt (red errors only)
- Whether the issue happens on **new game** vs **existing save**

Repository: https://github.com/discogeek/rimworld
