Clear-Host

$apps = "steam", 
        "origin", 
        "uplay",
        "epicgameslauncher",
        "discord", 
        "7-zip", 
        "notepadplusplus", 
        "vscode",
        "vscode-powershell",
        "teamspeak",
        "qBittorrent",
        "pswindowsupdate",
        "microsoft-edge",
        "mpc-be"
        # or "vlc"

foreach ($app in $apps) {
    write-host -ForegroundColor Yellow --`nInstalling $app
    choco install $app  -y 
}

write-host -ForegroundColor Green "Done."