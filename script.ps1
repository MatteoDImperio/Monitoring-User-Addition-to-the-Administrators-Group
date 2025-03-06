$logFile = "C:\Users\pino\Desktop\unauthorized_users.txt"
$photoFolder = "C:\Users\pino\Desktop\scammer_photos"

# Create the folder if it does not exist
if (!(Test-Path $photoFolder)) {
    New-Item -ItemType Directory -Path $photoFolder | Out-Null
}

Write-Host "[INFO] Monitoring active. Waiting for events..." -ForegroundColor Cyan

$lastEvent = ""

while ($true) {
    # Look for event 4732 (user added to a group)
    $events = Get-WinEvent -LogName Security | Where-Object { $_.Id -eq 4732 }

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()

        # Retrieve the group name and the added user
        $groupName = $xml.Event.EventData.Data[1].'#text'   # Group name
        $addedUser = $xml.Event.EventData.Data[0].'#text'   # User name

        if ($groupName -match "Administrators") {
            # Filter out system users
            if ($addedUser -match "^(Builtin|NT AUTHORITY|SYSTEM|Administrator)$") {
                continue  # Ignore these default users
            }

            # Avoid processing the same event multiple times
            if ($lastEvent -ne "$addedUser-$event.TimeCreated") {
                $lastEvent = "$addedUser-$event.TimeCreated"

                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $message = "$timestamp - WARNING: User $addedUser added to the Administrators group!"
                
                # Save the log to file
                $message | Out-File -Append -FilePath $logFile
                Write-Host "[ALERT] $message" -ForegroundColor Red

                # Show a popup alert
                Add-Type -AssemblyName "System.Windows.Forms"
                [System.Windows.Forms.MessageBox]::Show("You have been caught by the system administrator (scammer)", "Warning", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

                # Take a photo and save it
                $imagePath = "$photoFolder\photo_$($timestamp -replace '[: ]', '_').jpg"
                C:\ffmpeg\bin\ffmpeg.exe -f dshow -i video="USB2.0 HD UVC WebCam" -vframes 1 -q:v 2 $imagePath

                # Open the captured photo
                Start-Process $imagePath
                Start-Sleep -Seconds 5

                # Completely remove the user from the system
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c net user $addedUser /delete" -Verb RunAs -WindowStyle Hidden
                "$timestamp - User $addedUser removed from the system." | Out-File -Append -FilePath $logFile

                # Shut down the computer (currently commented out for testing)
                # Stop-Computer -Force
            }
        }
    }

    # Wait 5 seconds before checking again
    Start-Sleep -Seconds 5
}
