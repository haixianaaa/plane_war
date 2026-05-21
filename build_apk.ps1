#Requires -Version 5.1

<#
.SYNOPSIS
    Plane War Build Script

.DESCRIPTION
    Build Flutter Plane War game APK.
    Supports custom APK name and build mode.

.PARAMETER AppName
    Custom APK file name (without extension), default "PlaneWar"

.PARAMETER BuildMode
    Build mode: release, debug, profile, default release

.PARAMETER Clean
    Whether to run flutter clean before build, default true

.EXAMPLE
    .\build_apk.ps1
    Build APK with default settings

.EXAMPLE
    .\build_apk.ps1 -AppName "MyPlaneWar"
    Build and name "MyPlaneWar.apk"
#>

param(
    [Parameter(HelpMessage="Custom APK file name")]
    [string]$AppName = "PlaneWar",

    [Parameter(HelpMessage="Build mode: release, debug, profile")]
    [ValidateSet("release", "debug", "profile")]
    [string]$BuildMode = "release",

    [Parameter(HelpMessage="Whether to clean before build")]
    [switch]$Clean = $true
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Plane War - Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Build Config:" -ForegroundColor Yellow
Write-Host "   App Name: $AppName" -ForegroundColor White
Write-Host "   Build Mode: $BuildMode" -ForegroundColor White
Write-Host "   Clean: $Clean" -ForegroundColor White
Write-Host ""

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectDir

Write-Host "Project Dir: $projectDir" -ForegroundColor Gray
Write-Host ""

if ($Clean) {
    Write-Host "Cleaning project..." -ForegroundColor Yellow
    flutter clean
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Clean failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Clean done" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "Get dependencies failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Dependencies ready" -ForegroundColor Green
Write-Host ""

Write-Host "Building APK ($BuildMode)..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
Write-Host ""

$buildCmd = "flutter build apk --$BuildMode"
Invoke-Expression $buildCmd

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Build FAILED!" -ForegroundColor Red
    Write-Host "Please check error messages and fix" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "APK build SUCCESS!" -ForegroundColor Green

$sourceApk = Join-Path $projectDir "build\app\outputs\flutter-apk\app-$BuildMode.apk"

if (-not (Test-Path $sourceApk)) {
    $sourceApk = Join-Path $projectDir "build\app\outputs\flutter-apk\app.apk"
}

if (Test-Path $sourceApk) {
    $outputDir = Join-Path $projectDir "output"
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir | Out-Null
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputApk = Join-Path $outputDir "${AppName}_${timestamp}.apk"

    Copy-Item -Path $sourceApk -Destination $outputApk -Force

    $fileSize = (Get-Item $outputApk).Length / 1MB
    $fileSizeStr = "{0:N2}" -f $fileSize

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "    BUILD COMPLETE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Info:" -ForegroundColor Yellow
    Write-Host "   File: $(Split-Path -Leaf $outputApk)" -ForegroundColor White
    Write-Host "   Size: ${fileSizeStr} MB" -ForegroundColor White
    Write-Host "   Path: $outputApk" -ForegroundColor White
    Write-Host ""
    Write-Host "Transfer the APK to your Android phone to install" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "Build output not found, check build directory" -ForegroundColor Yellow
    Write-Host "Expected: $sourceApk" -ForegroundColor Gray
}
