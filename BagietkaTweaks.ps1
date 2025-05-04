<#
.SYNOPSIS
  BagietkaTweaks v1.1 – Interaktywne menu do optymalizacji Windows

.DESCRIPTION
  Ten skrypt pozwala na wybór jednej z sześciu kategorii tweaków:
    1. Ping Tweaks
    2. Input Delay Tweaks
    3. Performance Boost
    4. System Clean Tweaks
    5. Net & Update Tweaks
    6. Bezpieczeństwo i porządek
  Część komend stanowią przykłady – w miejscach oznaczonych komentarzem „# TODO” wklej pełne polecenia które chcesz wykonać.

.NOTES
  Uruchom jako administrator w PowerShell z ExecutionPolicy RemoteSigned:
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    .\BagietkaTweaks.ps1
#>

function Pause(){ Read-Host "`nNaciśnij Enter, aby kontynuować..." }

do {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Magenta
    Write-Host "           BagietkaTweaks v1.1           " -ForegroundColor Magenta -BackgroundColor Black
    Write-Host "==========================================" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "1. Ping Tweaks"
    Write-Host "2. Input Delay Tweaks"
    Write-Host "3. Performance Boost"
    Write-Host "4. System Clean Tweaks"
    Write-Host "5. Net & Update Tweaks"
    Write-Host "6. Bezpieczeństwo i porządek"
    Write-Host "7. Wyjście"
    Write-Host ""
    $choice = Read-Host "Wybierz opcję (1-7)"

    switch ($choice) {
        "1" {
            Write-Host "`n>> Ping Tweaks <<" -ForegroundColor Cyan
            # Wyłączenie zbędnych protokołów sieciowych
            Disable-NetAdapterBinding -Name "*" -ComponentID "ms_msclient" -Confirm:$false
            Disable-NetAdapterBinding -Name "*" -ComponentID "ms_server"   -Confirm:$false
            Disable-NetAdapterBinding -Name "*" -ComponentID "ms_lltdio"   -Confirm:$false
            Disable-NetAdapterBinding -Name "*" -ComponentID "mslltdmp"    -Confirm:$false
            # TODO: dodaj komendy wyłączające inne protokoły jak ms_netbios, ms_tcpip6
            # TCP NoDelay
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -PropertyType DWord -Value 1 -Force
            New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay"      -PropertyType DWord -Value 1 -Force
            Write-Host "✔ Ping Tweaks zastosowane." -ForegroundColor Green
            Pause
        }
        "2" {
            Write-Host "`n>> Input Delay Tweaks <<" -ForegroundColor Cyan
            # Optymalizacje rejestru klawiatury i myszy
            Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay"       -Value "0"  -Force
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop"  -Name "LowLevelHooksTimeout" -Value "0"  -Force
            # Wyłączenie Enhance Pointer Precision
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse"    -Name "MouseEnhancePointerPrecision" -Value "0" -Force
            Write-Host "✔ Input Delay Tweaks zastosowane." -ForegroundColor Green
            Pause
        }
        "3" {
            Write-Host "`n>> Performance Boost <<" -ForegroundColor Cyan
            # Game Mode
            New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -PropertyType DWord -Value 1 -Force
            # Wyłączenie animacji
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay"        -Value "0"    -Force
            # Autostart
            Get-CimInstance Win32_StartupCommand | Where-Object { $_.Location -ne "Registry" } | ForEach-Object { Disable-CimInstance $_ }
            # Ultimate Performance Plan
            powercfg -duplicatescheme 8c5e7e7d-14c3-48b1-bd84-120d66bf8a43 | Out-Null
            powercfg -setactive 8c5e7e7d-14c3-48b1-bd84-120d66bf8a43
            # TODO: wgraj tu skrypt Chris Titus Tech Services Tweaks
            Write-Host "✔ Performance Boost zastosowany." -ForegroundColor Green
            Pause
        }
        "4" {
            Write-Host "`n>> System Clean Tweaks <<" -ForegroundColor Cyan
            # Telemetria, historia, grupa domowa, hibernacja
            # TODO: wstaw komendy Disable dla usług DiagTrack, dmwappushsvc, HomeGroup, powercfg -h off
            # Recall, Storage Sense, Consumer Features, GameDVR, WiFi Sense
            # TODO: wpisz odpowiednie reg add / Disable-Service
            Write-Host "✔ System Clean Tweaks zastosowane." -ForegroundColor Green
            Pause
        }
        "5" {
            Write-Host "`n>> Net & Update Tweaks <<" -ForegroundColor Cyan
            # Wyłączenie Windows Update dla driverów
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "DontSearchWindowsUpdate" -PropertyType DWord -Value 1 -Force
            # Delivery Optimization
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0 -Force
            # Error Reporting
            Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsErrorReporting" -Name "Disabled" -Value 1 -Force
            Write-Host "✔ Net & Update Tweaks zastosowane." -ForegroundColor Green
            Pause
        }
        "6" {
            Write-Host "`n>> Bezpieczeństwo i porządek <<" -ForegroundColor Cyan
            # Punkt przywracania
            if (Get-Command Checkpoint-Computer -ErrorAction SilentlyContinue) {
                Checkpoint-Computer -Description "BagietkaTweaks Restore Point" -RestorePointType "MODIFY_SETTINGS"
                Write-Host "✔ Punkt przywracania utworzony." -ForegroundColor Green
            }
            # Thumbnails, Recycle Bin auto-clean
            Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
            # TODO: harmonogram opróżniania kosza lub via schtasks
            Write-Host "✔ Bezpieczeństwo i porządek zastosowane." -ForegroundColor Green
            Pause
        }
        "7" {
            Write-Host "`nZamykanie BagietkaTweaks v1.1..." -ForegroundColor Yellow
        }
        default {
            Write-Host "`nNieprawidłowy wybór. Spróbuj ponownie." -ForegroundColor Red
            Pause
        }
    }
} while ($choice -ne "7")
