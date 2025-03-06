# Monitoring-User-Addition-to-the-Administrators-Group

Description
This PowerShell script monitors, in real time, the addition of users to the "Administrators" group on a Windows system. If an unauthorized user is added, the script performs the following actions:

Logs the event in a file.
Displays an on-screen warning.
Captures a photo using the webcam and saves it.
Completely removes the user from the system.
(Optional) Shuts down the computer.


How It Works
The script uses Get-WinEvent to monitor Windows security events (ID 4732), which indicate when a user is added to a local group. If the group is "Administrators" and the user is not a system account (e.g., Builtin, SYSTEM, Administrator), the security procedure is triggered.

Requirements
Windows with PowerShell installed.
Administrator privileges to execute the script.
FFMPEG installed to capture images from the webcam.
The script must be run with elevated privileges.


Configuration
1. Modify the Paths
The script saves logs in C:\Users\pino\Desktop\unauthorized_users.txt.
Photos are saved in C:\Users\pino\Desktop\scammer_photos.
Customize these paths in the script if needed.
2. Install FFMPEG (if not already installed)
Download FFMPEG from https://ffmpeg.org/download.html.
Extract it and add the bin folder path to the Windows PATH environment variable.
3. Manual Execution
Open PowerShell as Administrator.
Run the following command:
Set-ExecutionPolicy Bypass -Scope Process -Force
   ./namescript.ps1


Automatic Startup with Task Scheduler
This script can be configured to run automatically at system startup using Windows Task Scheduler.

Steps:
Open Task Scheduler

Press Win + R, type taskschd.msc, and hit Enter.
Create a New Task

In the right panel, click "Create Task".
Configure the General Tab

Name: Admin User Monitoring
Check "Run with highest privileges".
Configure for: "Windows 10" (or your OS version).
Configure the Triggers Tab

Click "New...".
Select "At startup".
Confirm with OK.
Configure the Actions Tab

Click "New...".
Action: "Start a program".
Program/script: powershell.exe
Add the following arguments:
-ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Users\pino\Desktop\controllo4732.ps1"
Confirm with OK.
Save and Enable the Task

Click OK and enter the administrator password if prompted.
Test the task by running it manually.
Security Considerations
The script must run with elevated privileges to access security event logs.
Ensure the script is protected from unauthorized modifications.
Always test the script in a safe environment before deploying it.
Notes
The shutdown option is currently commented out to prevent accidental shutdowns.
If no events are detected, verify that Windows security logging is enabled (gpedit.msc -> Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> Audit Policy).
Contributions

If you have suggestions or improvements, feel free to open an issue or submit a pull request on GitHub!

