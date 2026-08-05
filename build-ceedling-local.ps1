# ============================================================

# Script: build-ceedling-local.ps1

# Description: Build Ceedling Docker image locally on Windows

# Usage: .\build-ceedling-local.ps1

# .\build-ceedling-local.ps1 -CeedlingVersion "1.1.1" -RubyVersion "3.4.10" -AlpineVersion "3.24"

# ============================================================

param(
[string]$CeedlingVersion = "1.1.1",
[string]$RubyVersion = "3.4.10",
[string]$AlpineVersion = "3.24"
)

# Configuration

$IMAGE_NAME = "safdariali/ceedling"
$FULL_TAG = "${CeedlingVersion}-ruby-${RubyVersion}-alpine-${AlpineVersion}"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Ceedling Docker Image Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker

Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
$dockerVersion = docker --version 2>&1
if ($LASTEXITCODE -ne 0) {
throw "Docker not found"
}
Write-Host "Docker found: $dockerVersion" -ForegroundColor Green
} catch {
Write-Host "Docker is not installed or not in PATH!" -ForegroundColor Red
exit 1
}

# Build info

Write-Host ""
Write-Host "Build Configuration:" -ForegroundColor Yellow
Write-Host "  Ceedling Version: $CeedlingVersion" -ForegroundColor White
Write-Host "  Ruby Version: $RubyVersion" -ForegroundColor White
Write-Host "  Alpine Version: $AlpineVersion" -ForegroundColor White
Write-Host "  Full Tag: $FULL_TAG" -ForegroundColor White
Write-Host ""

# Check Dockerfile

Write-Host "Checking Dockerfile..." -ForegroundColor Yellow
if (!(Test-Path "Dockerfile")) {
Write-Host "Dockerfile not found!" -ForegroundColor Red
exit 1
}
Write-Host "Dockerfile found" -ForegroundColor Green

# Build

Write-Host ""
Write-Host "Building Docker image..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""

docker build `
    --build-arg "CEEDLING_VERSION=$CeedlingVersion" `
    --build-arg "RUBY_VERSION=$RubyVersion" `
    --build-arg "ALPINE_VERSION=$AlpineVersion" `
    -t "${IMAGE_NAME}:$FULL_TAG" `
    -t "${IMAGE_NAME}:latest" `
    .

if ($LASTEXITCODE -eq 0) {
Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green

# Test
Write-Host ""
Write-Host "Testing the image..." -ForegroundColor Yellow

Write-Host "  Testing Ceedling..." -ForegroundColor Yellow
docker run --rm ${IMAGE_NAME}:"$FULL_TAG" ceedling --version

if ($LASTEXITCODE -eq 0) {
    Write-Host "  Ceedling test passed" -ForegroundColor Green
} else {
    Write-Host "  Ceedling test failed" -ForegroundColor Red
}

# Final info
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Image built successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Tags:" -ForegroundColor Yellow
Write-Host "  $IMAGE_NAME`:$FULL_TAG" -ForegroundColor White
Write-Host "  $IMAGE_NAME`:latest" -ForegroundColor White
Write-Host ""
Write-Host "To run:" -ForegroundColor Yellow
Write-Host "  docker run --rm $IMAGE_NAME`:latest ceedling --version" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan


} else {
Write-Host ""
Write-Host "Build failed!" -ForegroundColor Red
exit 1
}
