Add-Type -AssemblyName System.Windows.Forms

function Respond {
    param (
        [Parameter(Mandatory = $true)]
        [PSObject]$response
    )

    $msg = $response | ConvertTo-Json

    try {
        $writer = [System.IO.BinaryWriter]::new([System.Console]::OpenStandardOutput())
        $writer.Write([int]$msg.Length)
        $buf = [System.Text.Encoding]::UTF8.GetBytes($msg)
        $writer.Write($buf)
    } finally {
        $writer.Dispose()
    }
}

# Adjust path to point to the regjump.exe in the host directory located in %LOCALAPPDATA%\Registry Jumper
$localAppData = $ENV:LOCALAPPDATA
$regJump = [System.IO.Path]::Combine($localAppData, "Registry Jumper", "regjump", "regjump.exe")
Write-Debug "RegJump Path: $regJump"

try {
    $reader = [System.IO.BinaryReader]::new([System.Console]::OpenStandardInput())
    $len = $reader.ReadInt32()
    $buf = $reader.ReadBytes($len)
    $msg = [System.Text.Encoding]::UTF8.GetString($buf)
    $obj = $msg | ConvertFrom-Json

    if ($obj.Status -eq "validate") {
        if (-not (Test-Path $regJump)) {
            Respond @{message = "regjump"; regJumpPath = [System.IO.Path]::GetDirectoryName($regJump) }
            return
        }
        Respond @{message = "ok" }
        return
    }

    if (-not (Test-Path $regJump)) {
        # Show a message box prompting the user to open the Options page and run the install script again
        $message = @"
regjump.exe could not be found in the expected location: $regJump

Please open the extension's Options page and run the install script again to correct the issue.
"@
        [System.Windows.Forms.MessageBox]::Show($message, "Registry Jumper", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $si = [System.Diagnostics.ProcessStartInfo]::new($regJump)
    $si.Arguments = $obj.Text
    $si.Verb = "runas"

    [System.Diagnostics.Process]::Start($si)
} finally {
    $reader.Dispose()
}