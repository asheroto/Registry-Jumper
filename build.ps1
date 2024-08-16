# Define vars
$googleUpdateUrl = "https://clients2.google.com/service/update2/crx"
$edgeUpdateUrl = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"
$chromeExtensionID = "oeclndhlgfilojjhmciifnjopekeieei"
$edgeExtensionID = "mhaojmcnomblooljdnembgmajlmoecin"

# Define the source folder path and output zip file names
$srcFolderPath = "src"
$manifestPath = [System.IO.Path]::Combine($srcFolderPath, "manifest.json")
$nativeHostPath = [System.IO.Path]::Combine($srcFolderPath, "host", "nativehost.json")
$optionsFilePath = [System.IO.Path]::Combine($srcFolderPath, "options.js")
$backgroundFilePath = [System.IO.Path]::Combine($srcFolderPath, "background.js")
$destFolderPath = "dist"
$chromeZip = [System.IO.Path]::Combine($destFolderPath, "chrome.zip")
$edgeZip = [System.IO.Path]::Combine($destFolderPath, "edge.zip")

# Update nativehost.json with the correct extension ID and format it properly
Write-Output "Updating and formatting extension ID in nativehost.json..."
try {
    # Check if nativeHostPath is null or empty
    if (-not $nativeHostPath) {
        throw "The path to nativehost.json is not defined or is null."
    }

    # Read the content of the nativehost.json as a string
    $nativeHostContent = Get-Content -Raw -Path $nativeHostPath

    # Define the properly formatted allowed_origins string
    $formattedAllowedOrigins = @"
"allowed_origins": [
        `"chrome-extension://${chromeExtensionID}/`",
        `"chrome-extension://${edgeExtensionID}/`"
    ]
"@

    # Regex pattern to match the "allowed_origins": [ ] section
    $pattern = '(?ms)"allowed_origins":\s*\[.*?\]'

    # Replace the matched content with the correctly formatted string
    $nativeHostContent = [regex]::Replace($nativeHostContent, $pattern, $formattedAllowedOrigins)

    # Write the updated content back to the nativehost.json file
    Set-Content -Path $nativeHostPath -Value $nativeHostContent -Force -NoNewLine
    Write-Output "nativehost.json formatted and written successfully."
} catch {
    Write-Error "Error writing nativehost.json: $_"
    exit
}

# Function to check if a specific string exists in a file and prompt the user to change it if needed
function Check-DebugString {
    param (
        [string]$filePath,
        [string]$searchString = "const DEBUG = false;"
    )

    try {
        $fileContent = Get-Content -Path $filePath -Raw
        if ($fileContent -notmatch [regex]::Escape($searchString)) {
            Write-Output ""
            Write-Warning "'$searchString' not found in $filePath."
            $userResponse = Read-Host "`tWould you like to set DEBUG to false in ${filePath}? (y/n)"
            if ($userResponse -eq "y") {
                $updatedContent = $fileContent -replace "const DEBUG = true;", "const DEBUG = false;"
                $updatedContent | Set-Content -Path $filePath
                Write-Output "`t$searchString has been set in ${filePath}."
                Write-Output ""
            } else {
                Write-Warning "`tDEBUG not set to false. Continuing..."
                Write-Output ""
            }
        }
    } catch {
        Write-Error "Error processing ${filePath}: $_"
        exit 1
    }
}

# Function to create folder if it doesn't exist and clear it if it does
function Ensure-Folder {
    param (
        [string]$folderPath
    )

    try {
        if (-not (Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath | Out-Null
            Write-Output "Folder created: ${folderPath}"
        } else {
            Remove-Item -Path (Join-Path $folderPath '*') -Recurse -Force
            Write-Output "Folder cleared: ${folderPath}"
        }
    } catch {
        Write-Error "Error ensuring folder ${folderPath}: $_"
        exit 1
    }
}

# Function to create a zip file with contents directly at the root
function Create-ZipFile {
    param (
        [string]$sourceFolder,
        [string]$zipFileName
    )

    try {
        # Compress the contents of the source folder directly into the zip file
        Compress-Archive -Path (Join-Path $sourceFolder '*') -DestinationPath $zipFileName -Force
        Write-Output "Zip file created: ${zipFileName}"
    } catch {
        Write-Error "Error creating zip file ${zipFileName}: $_"
        exit 1
    }
}

# Function to update the manifest and create a zip file
function Update-ManifestAndZip {
    param (
        [string]$updateUrl,
        [string]$zipFileName
    )

    try {
        # Update the update_url in the manifest
        $manifest.update_url = $updateUrl

        # Write the updated manifest back to the file, prettified
        $manifest | ConvertTo-Json -Depth 4 | Set-Content -Path $manifestPath

        # Create the zip file directly from the source folder
        Create-ZipFile -sourceFolder $srcFolderPath -zipFileName $zipFileName
    } catch {
        Write-Error "Error updating manifest and creating zip file ${zipFileName}: $_"
        exit 1
    }
}

# Ensure dist folder exists and is empty
Write-Output "Creating necessary folders and clearing existing content..."
Ensure-Folder -folderPath $destFolderPath

# Check DEBUG setting in scripts
Check-DebugString -filePath $optionsFilePath -searchString "const DEBUG = false;"
Check-DebugString -filePath $backgroundFilePath -searchString "const DEBUG = false;"

# Read the original manifest (read it here so it can be modified multiple times)
try {
    $manifest = Get-Content -Raw -Path $manifestPath | ConvertFrom-Json
} catch {
    Write-Error "Error reading manifest.json: $_"
    exit 1
}

# Update and zip for Chrome
Update-ManifestAndZip -updateUrl $googleUpdateUrl -zipFileName $chromeZip

# Update and zip for Edge
Update-ManifestAndZip -updateUrl $edgeUpdateUrl -zipFileName $edgeZip

# Restore the original manifest
try {
    $manifest.update_url = $googleUpdateUrl
    $manifest | ConvertTo-Json -Depth 4 | Set-Content -Path $manifestPath
    Write-Output "Manifest restored to original update URL."
} catch {
    Write-Error "Error restoring manifest.json to original state: $_"
    exit 1
}

Write-Output ""
Write-Output "Test extension by reloading extension in the browser."