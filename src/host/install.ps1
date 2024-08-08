[CmdletBinding()]
param()

# Preferences
$ProgressPreference = 'SilentlyContinue' # Suppress progress bar (makes downloading super fast)
$ConfirmPreference = 'None' # Suppress confirmation prompts

# ============================================================================ #
# Functions
# ============================================================================ #

Function Download-RegJump {
    param (
        [string]$DestinationPath
    )

    $url = "https://live.sysinternals.com/regjump.exe"
    $regJumpFolder = Join-Path -Path $DestinationPath -ChildPath "regjump"
    $regJumpPath = Join-Path -Path $regJumpFolder -ChildPath "regjump.exe"

    # Create the destination folder if it doesn't exist
    if (-not (Test-Path -Path $regJumpFolder)) {
        Write-Debug "Creating regjump folder"
        New-Item -ItemType Directory -Path $regJumpFolder -Force | Out-Null
    }

    # Check if the file exists and delete it
    if (Test-Path -Path $regJumpPath) {
        Write-Debug "Deleting existing regjump.exe"
        Remove-Item -Path $regJumpPath -Force
    }

    # Download the file
    Write-Debug "Downloading regjump.exe from $url to $regJumpPath"
    Invoke-WebRequest -Uri $url -OutFile $regJumpPath

    Write-Output "regjump.exe has been downloaded"
    Write-Debug "regjump.exe location: $regJumpFolder"
}

Function Copy-HostFolder {
    param (
        [string]$SourcePath,
        [string]$DestinationPath
    )

    # Ensure the destination path exists
    if (-not (Test-Path -Path $DestinationPath)) {
        Write-Debug "Creating destination folder: $DestinationPath"
        New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    }

    # Verify source path exists and contains files
    if (-not (Test-Path -Path $SourcePath)) {
        Write-Error "Source path $SourcePath does not exist. Cannot copy host folder."
        return
    }

    $files = Get-ChildItem -Path $SourcePath
    if ($files.Count -eq 0) {
        Write-Error "Source path $SourcePath is empty. Nothing to copy."
        return
    }

    # Copy the entire host folder
    Write-Debug "Copying host folder from $SourcePath to $DestinationPath"
    Copy-Item -Path $SourcePath\* -Destination $DestinationPath -Recurse -Force

    Write-Output "Host folder has been copied to $DestinationPath"
}

Function Register-NativeMessagingHost {
    param (
        [string]$HostName,
        [string]$ManifestPath
    )

    $RegistryPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\$HostName"

    New-Item -Path $RegistryPath -Force -ErrorAction SilentlyContinue | Out-Null
    Set-ItemProperty -Path $RegistryPath -Name "(default)" -Value $ManifestPath -Force
}

# ============================================================================ #
# Import functions
# ============================================================================ #

. "$PSScriptRoot\functions.ps1"

# ============================================================================ #
# RegJump
# ============================================================================ #

# Get the current directory
$currentPath = Get-Location

Write-Output "Downloading Sysinternals RegJump..."
Download-RegJump -DestinationPath $currentPath.Path
Write-Output ""

# ============================================================================ #
# Copy Host Folder
# ============================================================================ #

Write-Output "Copying host folder..."

# Correctly set the source path to the `host` folder in the script directory
$SourceHostFolder = $PSScriptRoot
$ExtensionRootFolder = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName
$DestinationHostFolder = Join-Path -Path $ExtensionRootFolder -ChildPath "host"

# Debug output for paths
Write-Debug "Source Host Folder: $SourceHostFolder"
Write-Debug "Destination Host Folder: $DestinationHostFolder"

# Copy the host folder to the extension root directory
Copy-HostFolder -SourcePath $SourceHostFolder -DestinationPath $DestinationHostFolder
Write-Output ""

# ============================================================================ #
# Register host
# ============================================================================ #

Write-Output "Registering host..."

$ManifestPath = Join-Path -Path $DestinationHostFolder -ChildPath "nativehost.json"

# Debug output for troubleshooting
Write-Debug "Manifest Path: $ManifestPath"

# Register the native messaging host
Register-NativeMessagingHost -HostName "com.asheroto.regjump" -ManifestPath $ManifestPath

Write-Output "Native messaging host registered successfully."
Write-Output ""

# ============================================================================ #
# Complete
# ============================================================================ #

Write-Output "Installation complete"
Write-Output "You can now click the Verify button in the extension options to check if the host is registered correctly."
Write-Output "If it works, you're good to go!"
Write-Output ""

# ============================================================================ #
# Wait for 10 seconds or until a key is pressed before closing
# ============================================================================ #

Wait-ForKeyOrTimeout -Timeout 10