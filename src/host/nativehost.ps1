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

$regJump = [System.IO.Path]::Combine($PSScriptRoot, "regjump", "regjump.exe")

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
        $message = @"
Unable to locate 'regjump.exe' in '$([System.IO.Path]::GetDirectoryName($regJump))'

Please run install.ps1 in this folder: '$PSScriptRoot'

Would you like to run the install.ps1 script now? This will download 'regjump.exe' from the Sysinternals website and register the native messaging host.
"@
        $result = [System.Windows.Forms.MessageBox]::Show($message, "Registry Jumper", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Write-Host "User chose to run install.ps1"
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoLogo -NoProfile -File `"$PSScriptRoot\install.ps1`""
        } else {
            Write-Host "User chose not to run install.ps1"
        }
        return
    }

    $si = [System.Diagnostics.ProcessStartInfo]::new($regJump)
    $si.Arguments = $obj.Text
    $si.Verb = "runas"

    [System.Diagnostics.Process]::Start($si)
} finally {
    $reader.Dispose()
}