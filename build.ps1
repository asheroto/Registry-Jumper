# Define vars
$googleUpdateUrl = "https://clients2.google.com/service/update2/crx"
$edgeUpdateUrl = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"
$chromeExtensionID = "oeclndhlgfilojjhmciifnjopekeieei"
$edgeExtensionID = "mhaojmcnomblooljdnembgmajlmoecin"

# Define the source folder path and output zip file names
$srcFolderPath = "src"
$manifestPath = [System.IO.Path]::Combine($srcFolderPath, "manifest.json")
$nativeHostPath = [System.IO.Path]::Combine($srcFolderPath, "host", "nativehost.json")
$destFolderPath = "dist"
$chromeZip = [System.IO.Path]::Combine($destFolderPath, "chrome.zip")
$edgeZip = [System.IO.Path]::Combine($destFolderPath, "edge.zip")

# Function to create folder if it doesn't exist and clear it if it does
function Ensure-Folder {
    param (
        [string]$folderPath
    )

    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        Write-Output "Folder created: $folderPath"
    } else {
        Remove-Item -Path (Join-Path $folderPath '*') -Recurse -Force
        Write-Output "Folder cleared: $folderPath"
    }
}

# Function to create a zip file with contents directly at the root
function Create-ZipFile {
    param (
        [string]$sourceFolder,
        [string]$zipFileName
    )

    # Compress the contents of the source folder directly into the zip file
    Compress-Archive -Path (Join-Path $sourceFolder '*') -DestinationPath $zipFileName -Force

    Write-Output "Zip file created: $zipFileName"
}

# Ensure dist folder exists and is empty
Write-Output "Creating necessary folders and clearing existing content..."
Ensure-Folder -folderPath $destFolderPath

# Update nativehost.json with the correct extension ID
Write-Output "Updating extension ID in nativehost.json..."
$nativeHost = Get-Content -Raw -Path $nativeHostPath | ConvertFrom-Json
$nativeHost.allowed_origins = @("chrome-extension://$chromeExtensionID/", "chrome-extension://$edgeExtensionID/")
$nativeHost | ConvertTo-Json -Depth 4 | Set-Content -Path $nativeHostPath

# Read the original manifest
$manifest = Get-Content -Raw -Path $manifestPath | ConvertFrom-Json

# Function to update the manifest and create a zip file
function Update-ManifestAndZip {
    param (
        [string]$updateUrl,
        [string]$zipFileName
    )

    # Update the update_url in the manifest
    $manifest.update_url = $updateUrl

    # Write the updated manifest back to the file, prettified
    $manifest | ConvertTo-Json -Depth 4 | Set-Content -Path $manifestPath

    # Create the zip file directly from the source folder
    Create-ZipFile -sourceFolder $srcFolderPath -zipFileName $zipFileName
}

# Update and zip for Chrome
Update-ManifestAndZip -updateUrl $googleUpdateUrl -zipFileName $chromeZip

# Update and zip for Edge
Update-ManifestAndZip -updateUrl $edgeUpdateUrl -zipFileName $edgeZip

# Restore the original manifest
$manifest.update_url = $googleUpdateUrl
$manifest | ConvertTo-Json -Depth 4 | Set-Content -Path $manifestPath

Write-Output "Manifest restored to original update URL."
Write-Output ""
Write-Output "Test extension by reloading extension in browser."