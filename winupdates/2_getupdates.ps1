$updates = 'http://download.windowsupdate.com/c/msdownload/update/software/secu/2020/12/windows10.0-kb4593175-x64_49d6fbe1ad4b01b53daee97fd2cbf8652bc313bc.msu',
'http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/12/windows10.0-kb4592438-x64_b6914251264f8f973c3f82f99b894935f33c38e6.msu'

$MSUsFolder = "./MSUs/"
$CABsFolder = "./CABs/"

if ( !(Test-Path -Path $MSUsFolder -PathType Container) ) {
    New-Item -Path $MSUsFolder -ItemType "directory" | Out-Null
} else {
        Write-Host $MSUsFolder already exists
}

if ( !(Test-Path -Path $CABsFolder -PathType Container) ) {
    New-Item -Path $CABsFolder -ItemType "directory" | Out-Null
} else {
        Write-Host $CABsFolder already exists
}

Clear-Host
Write-Host Downloading Updates..

$updates | foreach-object { Start-BitsTransfer -DisplayName "Downloading Updates" -Description "File : $_" -Source $_ $MSUsFolder }

# Clear-Host
# Write-Host Extracting CAB files..
# Get-ChildItem $MSUsFolder | foreach-object { expand -F:* $_ $CABsFolder | Out-Null }
# Write-Host -------------`nExtracted CAB files :`n`t(Get-Item -Path "$CABsFolder*x64.cab" | foreach-object {Write-Output - $_.Name`n`t})

Write-Host `nInstalling Updates..`n-------------

foreach ($update in $(Get-ChildItem $MSUsFolder)) {
    $KB = $update.Name.split("-")[1]
    if (-not(Get-Hotfix -Id $KB)) {
        Write-Host Start-Process -FilePath "wusa.exe" -ArgumentList "$SourceFolder$KB.msu /quiet /norestart" -Wait
    }
    else {
        Write-Host Update $KB is already installed.
    }
}

# dism /online /add-package /packagepath=$lastcab


Start-Sleep 3
# Write-Host Cleaning up folders..
# Remove-Item -Path "$CABsFolder*","$MSUsFolder*" -Force

Start-Sleep 3
Write-Host -ForegroundColor DarkGreen "All Done."
write-host "Press any key to exit..."
[void][System.Console]::ReadKey($true)