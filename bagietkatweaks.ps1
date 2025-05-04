# BagietkaTweaks v1.1 - GUI Console Script
# Autor: Bagietka4 & ChatGPT

function Show-Menu {
    Clear-Host
    $Host.UI.RawUI.BackgroundColor = "Black"
    $Host.UI.RawUI.ForegroundColor = "Magenta"
    Clear-Host

    $width = $Host.UI.RawUI.WindowSize.Width
    $title = "BagietkaTweaks v1.1"
    $centeredTitle = $title.PadLeft(($width + $title.Length) / 2)

    Write-Host ""
    Write-Host $centeredTitle
    Write-Host ("=" * $width)
    Write-Host ""
    Write-Host "1. Ping Tweaks"
    Write-Host "2. Input Delay Tweaks"
    Write-Host "3. Performance Boost"
    Write-Host "4. System Clean Tweaks"
    Write-Host "5. Net & Update Tweaks"
    Write-Host "6. Bezpieczeństwo i porządek"
    Write-Host "7. Taskbar Cleanup"
    Write-Host "8. WindowsDebloat"
    Write-Host "9. Utwórz punkt przywracania"
    Write-Host "10. Zamknij PowerShell"
    Write-Host ""
}

function Apply-PingTweaks {
    Write-Host "`n[+] Wdrażanie Ping Tweaks..."
    netsh int tcp set global ecncapability=disabled
    netsh int tcp set global autotuninglevel=disabled
    netsh int tcp set global timestamps=disabled
    Start-Sleep 1
}

function Apply-InputDelayTweaks {
    Write-Host "`n[+] Wdrażanie Input Delay Tweaks..."
    powercfg -h off
    bcdedit /set disabledynamictick yes
    bcdedit /set useplatformtick yes
    Start-Sleep 1
}

function Apply-PerformanceBoost {
    Write-Host "`n[+] Wdrażanie Performance Boost..."
    powercfg /setactive SCHEME_MAX
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
    Start-Sleep 1
}

function Apply-SystemCleanTweaks {
    Write-Host "`n[+] Wdrażanie System Clean Tweaks..."
    Cleanmgr /sagerun:1
    Start-Sleep 1
}

function Apply-NetUpdateTweaks {
    Write-Host "`n[+] Wdrażanie Net & Update Tweaks..."
    sc config wuauserv start= disabled
    sc stop wuauserv
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
    Start-Sleep 1
}

function Apply-SecurityTweaks {
    Write-Host "`n[+] Wdrażanie tweaków bezpieczeństwa..."
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
    Start-Sleep 1
}

function Apply-TaskbarCleanup {
    Write-Host "`n[+] Usuwanie wyszukiwarki i ikony lupy..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
    Stop-Process -Name explorer -Force
    Start explorer
    Start-Sleep 1
}

function Apply-WindowsDebloat {
    Write-Host "`n[+] Wykonywanie Windows Debloat..."
    
    # 1. Usuń UWP apps
    Get-AppxPackage *onenote* | Remove-AppxPackage
    Get-AppxPackage *xbox* | Remove-AppxPackage
    Get-AppxPackage *people* | Remove-AppxPackage
    Get-AppxPackage *news* | Remove-AppxPackage
    Get-AppxPackage *mail* | Remove-AppxPackage

    # 2. Usuń Edge
    try {
        Start-Process "cmd.exe" "/c taskkill /f /im msedge.exe & rmdir /s /q %ProgramFiles(x86)%\Microsoft\Edge" -Verb RunAs
    } catch {}

    # 3. Usuń OneDrive
    taskkill /f /im OneDrive.exe
    Start-Process "$env:SystemRoot\System32\OneDriveSetup.exe" "/uninstall" -Verb RunAs

    # 4. Wyłącz telemetrię
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

    # 5. Zablokuj aktualizacje
    sc config wuauserv start= disabled
    sc stop wuauserv

    # 6. Usuń sugestie i powiadomienia
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

    # 7. Wyłącz usługi w tle
    Get-Service "DiagTrack","dmwappushservice" | Set-Service -StartupType Disabled

    Start-Sleep 1
}

function Create-RestorePoint {
    Write-Host "`n[+] Tworzenie punktu przywracania systemu..."
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "BagietkaTweaks Restore Point" -RestorePointType "MODIFY_SETTINGS"
    Start-Sleep 2
}

do {
    Show-Menu
    $option = Read-Host "Wybierz opcję (1-10)"

    switch ($option) {
        "1" { Apply-PingTweaks }
        "2" { Apply-InputDelayTweaks }
        "3" { Apply-PerformanceBoost }
        "4" { Apply-SystemCleanTweaks }
        "5" { Apply-NetUpdateTweaks }
        "6" { Apply-SecurityTweaks }
        "7" { Apply-TaskbarCleanup }
        "8" { Apply-WindowsDebloat }
        "9" { Create-RestorePoint }
        "10" { exit }
        default { Write-Host "`nNieprawidłowa opcja!" }
    }

    if ($option -ne "10") {
        Write-Host "`nNaciśnij Enter, aby powrócić do menu..."
        Read-Host
    }

} while ($option -ne "10")
