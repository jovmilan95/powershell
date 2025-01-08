param (
    [string] $pwshVersion = "7.4.6",
    [string] $composeFile = (Resolve-Path "./build.yml").ToString(),
    [string] $dockerRegistry = "jovmilan95/powershell",
    [switch] $updateAdditionalTags
)

$baseImages = @(
    @{ OS = "debian"; Tags = @("12", "12-slim", "latest") },
    @{ OS = "ubuntu"; Tags = @("22.04", "24.04", "latest") }
)

$ErrorActionPreference = "Stop"

foreach ($image in $baseImages) {
    $os = $image.OS
    foreach ($tag in $image.Tags) {
        $env:DOCKER_REGISTRY = $dockerRegistry
        $env:BASE_OS = $os
        $env:BASE_IMAGE_TAG = $tag
        $env:PWSH_VERSION = $pwshVersion
        $env:IMAGE_TAG = "$os-$tag-$pwshVersion"
        Write-Host "Building and pushing image: $env:DOCKER_REGISTRY:$env:IMAGE_TAG" -ForegroundColor Cyan

        docker compose -f $composeFile build --pull --push
        if ($LASTEXITCODE -ne 0) { throw "Build failed for $env:DOCKER_REGISTRY:$env:IMAGE_TAG" }
    }
}

if ($updateAdditionalTags) {
    foreach ($image in $baseImages) {
        $os = $image.OS
        foreach ($tag in $image.Tags) {
            $env:DOCKER_REGISTRY = $dockerRegistry
            $env:BASE_OS = $os
            $env:BASE_IMAGE_TAG = $tag
            $env:PWSH_VERSION = $pwshVersion
            $env:IMAGE_TAG = "$os-$tag"
            Write-Host "Building and pushing image: $env:DOCKER_REGISTRY:$env:IMAGE_TAG" -ForegroundColor Cyan

            docker compose -f $composeFile build --pull --push
            if ($LASTEXITCODE -ne 0) { throw "Build failed for $env:DOCKER_REGISTRY:$env:IMAGE_TAG" }
        }
    }
}

Write-Host "All builds and pushes are complete." -ForegroundColor Green