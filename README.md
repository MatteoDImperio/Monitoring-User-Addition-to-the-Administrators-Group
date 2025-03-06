# Monitoring-User-Addition-to-the-Administrators-Group

Description

This PowerShell script monitors in real-time when users are added to the "Administrators" group on a Windows system. If an unauthorized user is added, the script performs the following actions:

Logs the event to a file.

Displays an on-screen alert.

Captures a photo using the webcam and saves it.

Deletes the user from the system.

(Optional) Shuts down the computer.

How It Works

The script uses Get-WinEvent to monitor Windows security events (ID 4732), which indicate when a user is added to a local group. If the group is "Administrators" and the user is not a system user (e.g., Builtin, SYSTEM, Administrator), the security procedure is triggered.

Requirements

Windows with PowerShell.

Administrator privileges to run the script.

FFMPEG installed for capturing webcam images.

The script must be executed with elevated privileges.

Configuration

Modify the Paths

The script logs events in C:\Users\pino\Desktop\utentinonautorizzati.txt.

Photos are saved in C:\Users\pino\Desktop\foto degli scemi.

Customize these paths in the script if necessary.

Install FFMPEG (if not already installed)

Download FFMPEG from https://ffmpeg.org/download.html

Extract it and add the bin folder path to the system's PATH environment variable.

Manual Execution

Open PowerShell as Administrator.

Run the command:

Set-ExecutionPolicy Bypass -Scope Process -Force
.\controllo4732.ps1

Automatic Startup with Task Scheduler

The script can be configured to run automatically at system startup using Windows Task Scheduler.

Procedure:

Open Task Scheduler

Press Win + R, type taskschd.msc, and press Enter.

Create a New Task

In the right panel, click "Create Task".

Configure the General Tab

Name: Admin User Monitoring

Check "Run with highest privileges".

Configure for: "Windows 10" (or the current OS version).

Configure the Triggers Tab

Click "New...".

Select "At startup".

Confirm with OK.

Configure the Actions Tab

Click "New...".

Action: "Start a program".

Program/script: powershell.exe

Add arguments:

-ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\pino\Desktop\controllo4732.ps1"

Confirm with OK.

Save and Enable the Task

Click OK and enter the administrator password if prompted.

Test the task by running it manually.

Security Considerations

The script requires elevated privileges to access security events.

Ensure it is protected from unauthorized modifications.

Always test the script in a safe environment before deploying it in production.

Notes

The option to shut down the PC is currently commented out to prevent accidental shutdowns.

If no events are detected, verify that Windows security event logging is enabled (gpedit.msc -> Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> Audit Policy).

Contributions

If you have suggestions or improvements, feel free to open an issue or a pull request on GitHub!

