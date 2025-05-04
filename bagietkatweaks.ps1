# Skrypt: BagietkaTweaks v1.1
# Zawiera różne optymalizacje systemu Windows, takie jak debloat, taskbar cleanup, etc.

$ErrorActionPreference = "Stop"

# Funkcja zmiany koloru tła i tekstu PowerShella
function Set-PSColor {
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "Magenta"
    Clear-Host
}

# Funkcja usuwająca aplikacje UWP i niepotrzebne elementy
function WindowsDebloat {
    Set-PSColor
    Write-Host "Usuwanie aplikacji UWP..."
    # Usuwanie aplikacji UWP (OneDrive, Edge, itp.)
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -notlike "Microsoft.WindowsStore"} | Remove-AppxPackage
    Write-Host "Usunięto aplikacje UWP."
    
    Write-Host "Wyłączanie usług systemowych..."
    # Wyłączanie usług w tle
    Stop-Service -Name "wuauserv" -Force
    Set-Service -Name "wuauserv" -StartupType Disabled
    Stop-Service -Name "OneDrive" -Force
    Set-Service -Name "OneDrive" -StartupType Disabled
    Write-Host "Usługi zostały wyłączone."

    Write-Host "Usuwanie OneDrive, Edge i innych..."
    Remove-Item -Recurse -Force "C:\Program Files\WindowsApps\"
    Write-Host "Usunięto OneDrive i inne aplikacje."
    
    Write-Host "Zakończono debloat systemu Windows."
}

# Funkcja czyszczenia paska zadań
function TaskbarCleanup {
    Set-PSColor
    Write-Host "Usuwanie ikonek z paska zadań..."
    # Usuwanie ikon z paska zadań
    $Shell = New-Object -ComObject Shell.Application
    $Taskbar = $Shell.Namespace('shell:::{00c1e7a0-1f3c-4a8a-bf29-d58c50660199}')
    $Taskbar.Items() | foreach { $_.InvokeVerb('Unpin from taskbar') }
    Write-Host "Usunięto wszystkie ikony z paska zadań."
}

# Funkcja czyszczenia paska zadań z wyszukiwarki i lupy
function TaskbarSearchCleanup {
    Set-PSColor
    Write-Host "Czyszczenie paska zadań..."
    # Usuwanie wyszukiwarki z paska zadań
    $Key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
    Set-ItemProperty -Path $Key -Name "SearchboxTaskbarMode" -Value 0
    Write-Host "Usunięto wyszukiwarkę z paska zadań."
}

# Funkcja wyłączająca niepotrzebne usługi i funkcje
function DisableUnnecessaryServices {
    Set-PSColor
    Write-Host "Wyłączanie niepotrzebnych usług..."
    # Wyłączanie niepotrzebnych usług
    Stop-Service -Name "XblGameSave" -Force
    Set-Service -Name "XblGameSave" -StartupType Disabled
    Write-Host "Wyłączono niepotrzebne usługi."
}

# Funkcja optymalizacji wydajności systemu
function PerformanceBoost {
    Set-PSColor
    Write-Host "Optymalizowanie wydajności systemu..."
    # Włączenie trybu gry
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "GameMode" -Value 1
    # Wyłączenie zbędnych animacji
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value 1
    Write-Host "Optymalizacja wydajności zakończona."
}

# Funkcja naprawiająca opóźnienia wejściowe
function InputDelayFix {
    Set-PSColor
    Write-Host "Optymalizowanie opóźnienia wejściowego..."
    # Optymalizacja ustawień myszki i klawiatury
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 1
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0
    Write-Host "Optymalizacja opóźnienia zakończona."
}

# Funkcja zmieniająca ustawienia paska zadań
function TaskbarCustomization {
    Set-PSColor
    Write-Host "Personalizowanie paska zadań..."
    # Ustawienie trybu klasycznego
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1
    Write-Host "Pasek zadań został dostosowany."
}

# Menu do wyboru opcji
function ShowMenu {
    Set-PSColor
    Write-Host "Witaj w BagietkaTweaks v1.1!"
    Write-Host "1. Windows Debloat"
    Write-Host "2. Taskbar Cleanup"
    Write-Host "3. Taskbar Search Cleanup"
    Write-Host "4. Disable Unnecessary Services"
    Write-Host "5. Performance Boost"
    Write-Host "6. Input Delay Fix"
    Write-Host "7. Taskbar Customization"
    Write-Host "8. Exit"
    $Choice = Read-Host "Wybierz opcję (1-8)"

    switch ($Choice) {
        1 { WindowsDebloat }
        2 { TaskbarCleanup }
        3 { TaskbarSearchCleanup }
        4 { DisableUnnecessaryServices }
        5 { PerformanceBoost }
        6 { InputDelayFix }
        7 { TaskbarCustomization }
        8 { exit }
        default { Write-Host "Niepoprawny wybór!" }
    }
}

# Uruchomienie menu
ShowMenu
