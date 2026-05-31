$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = Join-Path $PSScriptRoot '..\GalacticRim\Common\Textures'
$manifestPath = Join-Path $PSScriptRoot 'textures.json'

if (Test-Path $manifestPath) {
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
    $pngBytes = [Convert]::FromBase64String($manifest.fallbackPngBase64)
    foreach ($rel in $manifest.paths) {
        $fullPath = Join-Path $root $rel
        $dir = Split-Path $fullPath -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        if (-not (Test-Path $fullPath)) {
            [IO.File]::WriteAllBytes($fullPath, $pngBytes)
            Write-Output "Decoded fallback $rel"
        }
    }
}

$assetSources = @(
    (Join-Path $PSScriptRoot '..\assets'),
    (Join-Path $env:USERPROFILE '.cursor\projects\empty-window\assets')
)

$copyMap = @{
    'GR_HoldoutBlaster.png' = 'Things/Item/Equipment/WeaponRanged/GR_HoldoutBlaster.png'
    'GR_PulseRifle.png' = 'Things/Item/Equipment/WeaponRanged/GR_PulseRifle.png'
    'GR_JediInspiredRobe.png' = 'Things/Apparel/GR_JediInspiredRobe.png'
    'GR_AuthorityTrooperCuirass.png' = 'Things/Apparel/GR_AuthorityTrooperCuirass.png'
    'GR_ForcePush.png' = 'UI/Abilities/GR_ForcePush.png'
    'GR_PackBeast_south.png' = 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_south.png'
}

foreach ($assetDir in $assetSources) {
    if (-not (Test-Path $assetDir)) { continue }
    foreach ($entry in $copyMap.GetEnumerator()) {
        $source = Join-Path $assetDir $entry.Key
        if (-not (Test-Path $source)) { continue }
        $dest = Join-Path $root $entry.Value
        $destDir = Split-Path $dest -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item $source $dest -Force
        Write-Output "Copied $($entry.Key)"
    }
    $packSouth = Join-Path $root 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_south.png'
    if (Test-Path $packSouth) {
        foreach ($dir in @('north', 'east', 'west')) {
            Copy-Item $packSouth (Join-Path $root "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_$dir.png") -Force
        }
    }
}

$textures = @(
    @{ Path = 'Things/Item/Equipment/WeaponRanged/GR_HoldoutBlaster.png'; W = 64; H = 64; Color = [System.Drawing.Color]::FromArgb(255, 90, 110, 140) },
    @{ Path = 'Things/Item/Equipment/WeaponRanged/GR_PulseRifle.png'; W = 96; H = 64; Color = [System.Drawing.Color]::FromArgb(255, 70, 90, 120) },
    @{ Path = 'Things/Apparel/GR_JediInspiredRobe.png'; W = 64; H = 64; Color = [System.Drawing.Color]::FromArgb(255, 180, 160, 90) },
    @{ Path = 'Things/Apparel/GR_AuthorityTrooperCuirass.png'; W = 64; H = 64; Color = [System.Drawing.Color]::FromArgb(255, 120, 125, 135) },
    @{ Path = 'Things/Projectile/GR_BlasterBolt.png'; W = 16; H = 16; Color = [System.Drawing.Color]::FromArgb(255, 120, 220, 255) },
    @{ Path = 'Things/Projectile/GR_PulseBolt.png'; W = 16; H = 16; Color = [System.Drawing.Color]::FromArgb(255, 255, 160, 80) },
    @{ Path = 'UI/Abilities/GR_ForcePush.png'; W = 64; H = 64; Color = [System.Drawing.Color]::FromArgb(255, 100, 180, 255) },
    @{ Path = 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_north.png'; W = 128; H = 128; Color = [System.Drawing.Color]::FromArgb(255, 160, 150, 130) },
    @{ Path = 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_south.png'; W = 128; H = 128; Color = [System.Drawing.Color]::FromArgb(255, 150, 140, 120) },
    @{ Path = 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_east.png'; W = 128; H = 128; Color = [System.Drawing.Color]::FromArgb(255, 155, 145, 125) },
    @{ Path = 'Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_west.png'; W = 128; H = 128; Color = [System.Drawing.Color]::FromArgb(255, 155, 145, 125) }
)

foreach ($tex in $textures) {
    $fullPath = Join-Path $root $tex.Path
    $dir = Split-Path $fullPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    if (Test-Path $fullPath) {
        Write-Output "Skipped existing $fullPath"
        continue
    }

    $bmp = New-Object System.Drawing.Bitmap $tex.W, $tex.H
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.Clear($tex.Color)
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White, 2)
    $graphics.DrawRectangle($pen, 2, 2, ($tex.W - 4), ($tex.H - 4))
    $bmp.Save($fullPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bmp.Dispose()
    Write-Output "Wrote $fullPath"
}
