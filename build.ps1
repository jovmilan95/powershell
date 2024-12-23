param (
    [string]$pwshVersion = "7.4.6",
    [string]$composeFile = (Resolve-Path "./build.yml").ToString(),
    [string]$dockerRegistry = "jovmilan95/powershell"
)

$ErrorActionPreference = "Stop"

$baseImages = @(
    @{ OS = "debian"; Tags = @("12", "12-slim", "latest") },
    @{ OS = "ubuntu"; Tags = @("22.04", "24", "latest") }
)

function BuildAndPush-DockerImages {
    param (
        [string]$dockerRegistry,
        [string]$os,
        [string]$tag,
        [string]$pwshVersion,
        [string]$composeFile
    )
    $env:DOCKER_REGISTRY = $dockerRegistry
    $env:BASE_OS = $os
    $env:BASE_IMAGE_TAG = $tag
    $env:PWSH_VERSION = $pwshVersion
    $fullTag = "$os-$tag-$pwshVersion"
    $baseTag = "$os-$tag"
    Write-Host "Building and pushing image: ${dockerRegistry}:${fullTag}" -ForegroundColor Cyan

    # Build and push the image
    $env:IMAGE_TAG = $fullTag
    docker compose -f $composeFile build --pull --push
    Write-Host "Creating additional tags..." -ForegroundColor Cyan
    $additionalTags = @($baseTag, "$os-latest")
    foreach ($tagToAdd in $additionalTags) {
        Write-Host "Tagging ${dockerRegistry}:${fullTag} with ${dockerRegistry}:${tagToAdd}" -ForegroundColor Green
        docker tag "${dockerRegistry}:${fullTag}" "${dockerRegistry}:${tagToAdd}"
        Write-Host "Pushing ${dockerRegistry}:${tagToAdd}" -ForegroundColor Green
        docker push "${dockerRegistry}:${tagToAdd}"
    }
}

foreach ($image in $baseImages) {
    $os = $image.OS
    foreach ($tag in $image.Tags) {
        BuildAndPush-DockerImages -dockerRegistry $dockerRegistry -os $os -tag $tag -pwshVersion $pwshVersion -composeFile $composeFile
    }
}

Write-Host "All builds and pushes are complete." -ForegroundColor Green