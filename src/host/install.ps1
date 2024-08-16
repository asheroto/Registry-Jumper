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
        [string]$regJumpFolder
    )

    $url = "https://live.sysinternals.com/regjump.exe"
    $regJumpPath = Join-Path -Path $regJumpFolder -ChildPath "regjump.exe"

    try {
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

        Write-Output "regjump.exe successfully downloaded."
        Write-Debug "regjump.exe is located at: $regJumpFolder"
    } catch {
        Write-Error "Failed to download regjump.exe: $_"
        exit 1
    }
}

Function Copy-HostFolder {
    param (
        [string]$SourcePath,
        [string]$DestinationPath
    )

    try {
        # Ensure the destination path exists
        if (-not (Test-Path -Path $DestinationPath)) {
            Write-Debug "Creating destination folder: $DestinationPath"
            New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
        }

        # Copy the contents of the host folder to the destination path
        Write-Debug "Copying host folder contents from $SourcePath to $DestinationPath"
        Copy-Item -Path (Join-Path $SourcePath "*") -Destination $DestinationPath -Recurse -Force

        Write-Output "Host folder successfully configured."
        Write-Debug "Host folder path: $DestinationPath"
    } catch {
        Write-Error "Failed to copy host folder: $_"
        exit 1
    }
}

Function Register-NativeMessagingHost {
    param (
        [string]$HostName,
        [string]$ManifestPath
    )

    try {
        $RegistryPath = Join-Path "HKCU:\Software\Google\Chrome\NativeMessagingHosts" $HostName

        New-Item -Path $RegistryPath -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path $RegistryPath -Name "(default)" -Value $ManifestPath -Force

        Write-Output "Native messaging host registered successfully."
    } catch {
        Write-Error "Failed to register native messaging host: $_"
        exit 1
    }
}

# ============================================================================ #
# Import functions
# ============================================================================ #

. "$PSScriptRoot\functions.ps1"

# ============================================================================ #
# Set up the paths
# ============================================================================ #

# Set the base destination path to %LOCALAPPDATA%\Registry Jumper
$localAppData = $ENV:LOCALAPPDATA
$baseDestinationPath = Join-Path -Path $localAppData -ChildPath "Registry Jumper"

# Define paths for regjump and host folders
$regJumpFolder = Join-Path -Path $baseDestinationPath -ChildPath "regjump"
$hostFolder = Join-Path -Path $baseDestinationPath -ChildPath "host"

# ============================================================================ #
# RegJump
# ============================================================================ #

Write-Output "Downloading Sysinternals RegJump..."
Download-RegJump -regJumpFolder $regJumpFolder
Write-Output ""

# ============================================================================ #
# Copy Host Folder
# ============================================================================ #

Write-Output "Copying host folder..."

# Copy the contents of the host folder to the destination directory
Copy-HostFolder -SourcePath $PSScriptRoot -DestinationPath $hostFolder
Write-Output ""

# ============================================================================ #
# Register host
# ============================================================================ #

Write-Output "Registering host..."

$ManifestPath = Join-Path -Path $hostFolder -ChildPath "nativehost.json"

# Debug output for troubleshooting
Write-Debug "Manifest Path: $ManifestPath"

# Register the native messaging host with the correct path
Register-NativeMessagingHost -HostName "com.asheroto.regjump" -ManifestPath $ManifestPath
Write-Output ""

# ============================================================================ #
# Complete
# ============================================================================ #

Write-Output "Installation complete"
Write-Output "You can now click the Verify button in the extension options to confirm that the host is registered correctly."
Write-Output "If it works, you're good to go!"
Write-Output ""

# ============================================================================ #
# Wait for 10 seconds or until a key is pressed before closing
# ============================================================================ #

Wait-ForKeyOrTimeout -Timeout 10