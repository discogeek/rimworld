@echo off
setlocal
powershell -ExecutionPolicy Bypass -File "%~dp0generate_textures.ps1" -ForceItems
dotnet build "%~dp0..\Source\GalacticRim.csproj" %*
if errorlevel 1 exit /b 1
echo Build complete: GalacticRim\Assemblies\GalacticRim.dll
