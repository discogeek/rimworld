param(
    [switch]$ForceItems
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function New-TransparentBitmap([int]$Width, [int]$Height) {
    $bmp = New-Object System.Drawing.Bitmap $Width, $Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    return @{ Bitmap = $bmp; Graphics = $graphics }
}

function Save-IconPlaceholder {
    param(
        [string]$FullPath,
        [int]$W,
        [int]$H,
        [System.Drawing.Color]$Fill,
        [System.Drawing.Color]$Border
    )

    $dir = Split-Path $FullPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $ctx = New-TransparentBitmap $W $H
    $margin = [Math]::Max(2, [Math]::Min($W, $H) / 8)
    $brush = New-Object System.Drawing.SolidBrush $Fill
    $pen = New-Object System.Drawing.Pen $Border, 2
    $ctx.Graphics.FillRectangle($brush, $margin, $margin, ($W - (2 * $margin)), ($H - (2 * $margin)))
    $ctx.Graphics.DrawRectangle($pen, $margin, $margin, ($W - (2 * $margin)), ($H - (2 * $margin)))
    $ctx.Bitmap.Save($FullPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $pen.Dispose()
    $brush.Dispose()
    $ctx.Graphics.Dispose()
    $ctx.Bitmap.Dispose()
    Write-Output "Wrote transparent icon $FullPath"
}

$root = Join-Path $PSScriptRoot '..\GalacticRim\Common\Textures'

$itemIcons = @(
    @{ Path = 'Things/Item/Equipment/WeaponRanged/GR_HoldoutBlaster.png'; W = 128; H = 128; Fill = [System.Drawing.Color]::FromArgb(255, 90, 110, 140); Border = [System.Drawing.Color]::FromArgb(255, 180, 210, 255) },
    @{ Path = 'Things/Item/Equipment/WeaponRanged/GR_PulseRifle.png'; W = 128; H = 128; Fill = [System.Drawing.Color]::FromArgb(255, 70, 90, 120); Border = [System.Drawing.Color]::FromArgb(255, 160, 200, 255) },
    @{ Path = 'Things/Apparel/GR_JediInspiredRobe.png'; W = 128; H = 128; Fill = [System.Drawing.Color]::FromArgb(255, 180, 160, 90); Border = [System.Drawing.Color]::FromArgb(255, 240, 220, 140) },
    @{ Path = 'Things/Apparel/GR_AuthorityTrooperCuirass.png'; W = 128; H = 128; Fill = [System.Drawing.Color]::FromArgb(255, 120, 125, 135); Border = [System.Drawing.Color]::FromArgb(255, 210, 215, 225) },
    @{ Path = 'Things/Projectile/GR_BlasterBolt.png'; W = 32; H = 32; Fill = [System.Drawing.Color]::FromArgb(255, 120, 220, 255); Border = [System.Drawing.Color]::FromArgb(255, 220, 250, 255) },
    @{ Path = 'Things/Projectile/GR_PulseBolt.png'; W = 32; H = 32; Fill = [System.Drawing.Color]::FromArgb(255, 255, 160, 80); Border = [System.Drawing.Color]::FromArgb(255, 255, 220, 180) },
    @{ Path = 'UI/Abilities/GR_ForcePush.png'; W = 128; H = 128; Fill = [System.Drawing.Color]::FromArgb(255, 100, 180, 255); Border = [System.Drawing.Color]::FromArgb(255, 210, 240, 255) }
)

foreach ($tex in $itemIcons) {
    $fullPath = Join-Path $root $tex.Path
    if ($ForceItems -or -not (Test-Path $fullPath)) {
        Save-IconPlaceholder -FullPath $fullPath -W $tex.W -H $tex.H -Fill $tex.Fill -Border $tex.Border
    }
}

# Droid placeholder sprites (uses mechanoid multi format)
$droidDirs = @('north', 'south', 'east', 'west')
foreach ($dir in $droidDirs) {
    $fullPath = Join-Path $root "Things/Pawn/Mechanoid/GR_UtilityDroid/GR_UtilityDroid_$dir.png"
    if ($ForceItems -or -not (Test-Path $fullPath)) {
        Save-IconPlaceholder -FullPath $fullPath -W 128 -H 128 -Fill ([System.Drawing.Color]::FromArgb(255, 130, 140, 150)) -Border ([System.Drawing.Color]::FromArgb(255, 220, 230, 240))
    }
}

# Pack beast placeholders if missing
$beastColors = @(
    @{ Name = 'north'; Fill = [System.Drawing.Color]::FromArgb(255, 160, 150, 130) },
    @{ Name = 'south'; Fill = [System.Drawing.Color]::FromArgb(255, 150, 140, 120) },
    @{ Name = 'east'; Fill = [System.Drawing.Color]::FromArgb(255, 155, 145, 125) },
    @{ Name = 'west'; Fill = [System.Drawing.Color]::FromArgb(255, 155, 145, 125) }
)
foreach ($beast in $beastColors) {
    $fullPath = Join-Path $root "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_$($beast.Name).png"
    if (-not (Test-Path $fullPath)) {
        Save-IconPlaceholder -FullPath $fullPath -W 128 -H 128 -Fill $beast.Fill -Border ([System.Drawing.Color]::FromArgb(255, 230, 220, 200))
    }
}
