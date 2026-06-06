# Galactic Rim

An unofficial Star Wars-inspired RimWorld 1.6 mod. Adds galactic weapons, two factions, a Force push ability, a utility droid pawn kind, and a cold-biome pack beast.

**Repository:** https://github.com/discogeek/rimworld  
**Not affiliated with or endorsed by Lucasfilm Ltd.**

## Requirements

- RimWorld **1.6**
- [Harmony](https://steamcommunity.com/sharedfiles/filedetails/?id=2009463077) (Workshop mod — required dependency)
- .NET SDK or Visual Studio 2022 (to build the C# assembly)
- RimWorld install path (default Steam): `C:\Program Files (x86)\Steam\steamapps\common\RimWorld`

## Install (players)

1. Subscribe to **Harmony** on the Steam Workshop.
2. Copy or symlink the `GalacticRim` folder into your RimWorld Mods directory:
   - Steam: `...\Steam\steamapps\common\RimWorld\Mods\`
   - Or: `%USERPROFILE%\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Mods\`
3. Enable **Harmony** and **Galactic Rim** in the mod list (Harmony must load first).
4. Start a new game or load a save.

## Build (developers)

```powershell
# From repo root — textures + C# (required before first play test)
.\scripts\build.bat

# Or step by step:
powershell -ExecutionPolicy Bypass -File scripts/generate_textures.ps1
dotnet build Source/GalacticRim.csproj

# Custom RimWorld install path:
dotnet build Source/GalacticRim.csproj -p:RimWorldDir="D:\Games\RimWorld"
```

The build script decodes placeholder PNGs from `scripts/textures.json`, optionally copies art from `assets/`, generates any missing sprites, and emits `GalacticRim/Assemblies/GalacticRim.dll`.

### Symlink mod into RimWorld (optional)

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Mods\GalacticRim" -Target "C:\Users\tim\Projects\rimworld\GalacticRim"
```

## Compatibility (Vanilla Expanded, Dubs, etc.)

Galactic Rim only **adds** content (`GR_*` defs). It does not retheme Empire, Rebels, or VE factions.

- See **[docs/COMPATIBILITY.md](docs/COMPATIBILITY.md)** for load order and what we avoid patching.
- Put **Galactic Rim near the bottom** of your mod list, below VE Framework and Dubs mods.
- Biome animal spawns use **additive** patches only.

## v0.1 content

| Category | Content |
|---|---|
| Research | Basic Galactic Arms |
| Weapons | Holdout Blaster, Pulse Rifle |
| Apparel | Force attuned robe, Authority trooper cuirass |
| Factions | Galactic Authority (raids), Free Systems Alliance (traders + raids) |
| Force | Force-sensitive trait + Force Push ability (60s cooldown) |
| Creatures | Pack beast (Tundra / Boreal Forest / Ice Sheet) |
| NPCs | Utility droid pawn kind (dev spawn / future trader hook) |

## Test plan

1. Enable only **Harmony** + **Galactic Rim**; confirm no red errors on startup.
2. Dev mode → spawn **Holdout Blaster** / **Pulse Rifle**; fire at a target.
3. Complete **Basic Galactic Arms** research; craft weapons and apparel at a machining bench / tailor bench.
4. Dev mode → spawn raid from **Galactic Authority**; confirm troopers wear cuirasses and carry pulse rifles.
5. Wait for or spawn **Free Systems Alliance** caravan; confirm trader and goods.
6. Dev mode → add **force-sensitive** trait to a colonist; verify **Force push** gizmo appears and staggers/pushes enemies.
7. Dev mode → spawn **pack beast**; start on a cold biome map and confirm wild spawns over time.
8. Dev mode → spawn **utility droid** pawn kind; confirm it generates.
9. Save and reload; confirm no missing-def pink squares.

## Repository layout

```text
GalacticRim/          # RimWorld mod folder (deploy this)
Source/               # C# project
scripts/              # texture generator
```

## Publish to GitHub

```powershell
cd C:\Users\tim\Projects\rimworld
git init
git remote add origin https://github.com/discogeek/rimworld.git
git add -A
git commit -m "Initial Galactic Rim v0.1 proof-of-concept"
git branch -M main
git push -u origin main
```

## License

Fan-inspired mod project. Replace placeholder art before any public Workshop release.
