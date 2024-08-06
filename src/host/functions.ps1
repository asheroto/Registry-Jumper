Function Wait-ForKeyOrTimeout {
    param (
        [int]$Timeout = 10
    )

    for ($i = $Timeout; $i -ge 0; $i--) {
        Write-Host -NoNewline "`rPress any key to close... (Closing in $i seconds) "

        if ([System.Console]::KeyAvailable) {
            [void][System.Console]::ReadKey($true)
            Write-Host "`rKey pressed, exiting countdown...                     " # Clear line with spaces
            return
        }

        Start-Sleep -Seconds 1
    }
    Write-Host "`rPress any key to close... (Closing in 0 seconds)                     " # Clear the last countdown
}