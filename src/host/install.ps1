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
# Register host
# ============================================================================ #

Write-Output "Registering host..."

$ManifestPath = (Join-Path -Path $PSScriptRoot -ChildPath "nativehost.json")
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