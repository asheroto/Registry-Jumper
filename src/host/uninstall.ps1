# ============================================================================ #
# Import functions
# ============================================================================ #

. "$PSScriptRoot\functions.ps1"

# ============================================================================ #
# Unregister host
# ============================================================================ #

$RegistryPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\com.asheroto.regjump"
Remove-Item -Path $RegistryPath -Force -ErrorAction SilentlyContinue

Write-Output "Registry entry deleted successfully."
Write-Output ""

# ============================================================================ #
# Remove the RegJump directory
# ============================================================================ #

$localAppData = $ENV:LOCALAPPDATA
$destinationPath = Join-Path -Path $localAppData -ChildPath "Registry Jumper"

if (Test-Path -Path $destinationPath) {
    Remove-Item -Path $destinationPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Registry Jumper directory deleted successfully."
} else {
    Write-Output "Registry Jumper directory not found."
}
Write-Output ""

# ============================================================================ #
# Wait for 10 seconds or until a key is pressed before closing
# ============================================================================ #

Wait-ForKeyOrTimeout -Timeout 10