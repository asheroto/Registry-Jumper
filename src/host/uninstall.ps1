# ============================================================================ #
# Import functions
# ============================================================================ #

. "$PSScriptRoot\functions.ps1"

# ============================================================================ #
# Unregister host
# ============================================================================ #

$RegistryPath = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\com.asheroto.chrome.regjump"
Remove-Item -Path $RegistryPath -Force -ErrorAction SilentlyContinue

# ============================================================================ #
# Complete
# ============================================================================ #

Write-Output "Registry entry deleted successfully."
Write-Output ""

# ============================================================================ #
# Wait for 10 seconds or until a key is pressed before closing
# ============================================================================ #

Wait-ForKeyOrTimeout -Timeout 10