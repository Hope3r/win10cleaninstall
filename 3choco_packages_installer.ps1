#Requires -RunAsAdministrator

$NVCleanstall = "https://de1-dl.techpowerup.com/files/NVCleanstall_1.7.0.exe"

Clear-Host

Write-Host "Installing Chocolatey"
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
        "pswindowsupdate",
        "microsoft-edge", # Chromium based Edge
        # "nvidia-display-driver", # Replaced by NVCleanstall
        # "disable-nvidia-telemetry", # Not Working in latest drivers
        "ddu", # Display Driver Uninstaller
        "irfanview", # Image viewer
        "mpc-be" # Media Player Classic Black Edition
        # or "vlc"

foreach ($app in $apps) {
    write-host -ForegroundColor Yellow --`nInstalling $app
    choco install $app  -y 
}

write-host -ForegroundColor Green "Done."

write-host -ForegroundColor Yellow "Launching NVCleanstall"
Start-BitsTransfer -Source $NVCleanstall -Destination $Env:Temp/NVCleanstall.exe
    Start-Process -FilePath "$Env:Temp\NVCleanstall.exe"-NoNewWindow -Wait
