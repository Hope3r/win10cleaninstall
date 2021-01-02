$ErrorActionPreference = "Inquire"
Clear-Host

write-host -ForegroundColor DarkGreen "Installing Chocolatey"

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $title = "Session is not running as Administator"
    $question = "Relaunch with Administator privileges ?"
    $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
    $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
    $answer = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($answer -eq 0) {
        Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit
    }
    else {
        Write-Host -ForegroundColor Magenta "You chose 'NO'.`nExiting.."
        Start-Sleep 2
        Exit
    }
}

# Installation of Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install chocolatey-core.extension

$apps = "steam",
"origin", 
"uplay",
"epicgameslauncher",
"discord", 
"7zip", 
"notepadplusplus", 
"vscode",
"vscode-powershell",
"teamspeak",
"qBittorrent",
"pswindowsupdate", # Allowing Windows Updates using powershell
"microsoft-edge", # Chromium based Edge or "firefox", or "chrome"
# "nvidia-display-driver", # Replaced by NVCleanstall
# "disable-nvidia-telemetry", # Not Working in latest drivers
"ddu", # Display Driver Uninstaller
"XnView", # Image viewer
"mpv", # Better Media Player or "mpc-be" # Media Player Classic Black Edition, or "vlc"
"everything"

foreach ($app in $apps) {
    $i = $i + 1
    write-host -ForegroundColor DarkGreen --`nInstalling $app
    choco install $app  -y
}

# NVCleanstall
$title = "NVIDIA Drivers Installation"
$question = "Do you want to run NVCleanstall?"
$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
$answer = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($answer -eq 0) {
    $NVCleanstall = "https://de1-dl.techpowerup.com/files/NVCleanstall_1.7.0.exe"
    Write-host -ForegroundColor Cyan "Launching NVCleanstall"
    Start-BitsTransfer -Source $NVCleanstall -Destination $Env:Temp/NVCleanstall.exe
    Start-Process -FilePath "$Env:Temp\NVCleanstall.exe" -NoNewWindow -Wait
    Write-host "Cleaning up"
    Remove-Item -Path "$Env:Temp\NVCleanstall.exe"
}
else {
    Write-Host "You chose 'NO'.`nSkipping NVCleanstall installation.."
}
###############

Write-Host -ForegroundColor Cyan "`n---`nDone Installing $i chocolatey packages :"
foreach ($app in $apps) {
    write-host "`t- $app"
}
Start-Sleep 3
Write-Host -ForegroundColor DarkGreen "All Done."
write-host "Press any key to exit..."
[void][System.Console]::ReadKey($true)