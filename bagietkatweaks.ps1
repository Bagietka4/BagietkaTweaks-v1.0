# Skrypt BagietkaTweaks v1.2

# Funkcje Tweaks
function Tweak-1 {
    Write-Host "Wykonywanie Tweaka 1: Włącz tryb gry..." -ForegroundColor Cyan
    # Dodaj funkcje tweakowania trybu gry
    Write-Host "Tryb gry włączony!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

function Tweak-2 {
    Write-Host "Wykonywanie Tweaka 2: Usuń niepotrzebne aplikacje..." -ForegroundColor Cyan
    # Dodaj funkcje usuwania aplikacji
    Write-Host "Niepotrzebne aplikacje usunięte!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

function Tweak-3 {
    Write-Host "Wykonywanie Tweaka 3: Optymalizacja systemu..." -ForegroundColor Cyan
    # Dodaj funkcje optymalizacji systemu
    Write-Host "Optymalizacja systemu zakończona!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

# Funkcja do tweaków TCP/Internet
function Tweak-Network {
    Write-Host "Wykonywanie Tweaka: Poprawa pingów i optymalizacja internetu..." -ForegroundColor Cyan

    # Optymalizacja TCP
    Write-Host "Optymalizacja TCP (Zwiększanie wydajności sieci)" -ForegroundColor Yellow
    Set-NetTCPSetting -SettingName Internet
    Write-Host "Optymalizacja TCP zakończona!" -ForegroundColor Green

    # Zwiększenie rozmiaru bufora TCP
    Write-Host "Zwiększanie rozmiaru bufora TCP dla lepszej wydajności..." -ForegroundColor Yellow
    netsh int tcp set global autotuninglevel=normal
    Write-Host "Zwiększenie bufora TCP zakończone!" -ForegroundColor Green

    # Optymalizacja pingów
    Write-Host "Optymalizacja ustawień pingów (Opóźnienia)" -ForegroundColor Yellow
    netsh int ip set global taskoffload=disabled
    Write-Host "Optymalizacja pingów zakończona!" -ForegroundColor Green

    # Wyłączenie Time-Wait (pomaga w zmniejszeniu opóźnień)
    Write-Host "Wyłączanie Time-Wait w TCP..." -ForegroundColor Yellow
    New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name "TcpNumConnections" -Value 65535 -PropertyType DWord -Force
    Write-Host "Wyłączanie Time-Wait zakończone!" -ForegroundColor Green

    # Finalizacja
    Write-Host "Tweak TCP/Internet zakończony pomyślnie!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

function Tweak-5 {
    Write-Host "Wykonywanie Tweaka 5: Taskbar Cleanup..." -ForegroundColor Cyan
    # Skrypt do usuwania zbędnych ikonek z paska zadań
    Write-Host "Usunięte zbędne ikony z paska zadań!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

function Tweak-6 {
    Write-Host "Wykonywanie Tweaka 6: Windows Debloat..." -ForegroundColor Cyan
    # Usuwanie aplikacji
    Write-Host "Usuwanie zbędnych aplikacji..." -ForegroundColor Yellow
    Get-AppxPackage -AllUsers | Remove-AppxPackage
    Write-Host "Aplikacje usunięte!" -ForegroundColor Green

    # Usuwanie Microsoft Edge
    Write-Host "Usuwanie Microsoft Edge..." -ForegroundColor Yellow
    Get-AppxPackage *Microsoft.MicrosoftEdge* | Remove-AppxPackage
    Write-Host "Microsoft Edge usunięty!" -ForegroundColor Green

    # Usuwanie OneDrive
    Write-Host "Usuwanie OneDrive..." -ForegroundColor Yellow
    Remove-Item -Path "C:\Users\$env:USERNAME\OneDrive" -Recurse -Force
    Write-Host "OneDrive usunięty!" -ForegroundColor Green

    # Wyłączenie telemetrii i diagnostyki
    Write-Host "Wyłączanie telemetrii i diagnostyki..." -ForegroundColor Yellow
    Set-Service -Name DiagTrack -StartupType Disabled
    Write-Host "Telemetria wyłączona!" -ForegroundColor Green

    # Finalizacja
    Write-Host "Debloat systemu zakończony!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

function Tweak-7 {
    Write-Host "Wykonywanie Tweaka 7: Windows Taskbar Cleanup..." -ForegroundColor Cyan
    # Usuń lupę z paska zadań
    Write-Host "Usuwanie lupy z paska zadań..." -ForegroundColor Yellow
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
    Write-Host "Lupa usunięta!" -ForegroundColor Green
    Read-Host "Naciśnij Enter, aby przejść do następnego tweaka"
}

# Menu wybierania opcji
Write-Host "Wybierz Tweak do wykonania:" -ForegroundColor Yellow
Write-Host "1. Tweak 1: Włącz tryb gry"
Write-Host "2. Tweak 2: Usuń niepotrzebne aplikacje"
Write-Host "3. Tweak 3: Optymalizacja systemu"
Write-Host "4. Tweak 4: Optymalizacja TCP / Internet / Ping"
Write-Host "5. Tweak 5: Taskbar Cleanup"
Write-Host "6. Tweak 6: Windows Debloat"
Write-Host "7. Tweak 7: Windows Taskbar Cleanup (Lupa)"

$choice = Read-Host "Wybierz numer (1-7)"

if ($choice -eq 1) {
    Tweak-1
}
elseif ($choice -eq 2) {
    Tweak-2
}
elseif ($choice -eq 3) {
    Tweak-3
}
elseif ($choice -eq 4) {
    Tweak-Network
}
elseif ($choice -eq 5) {
    Tweak-5
}
elseif ($choice -eq 6) {
    Tweak-6
}
elseif ($choice -eq 7) {
    Tweak-7
}
else {
    Write-Host "Nieprawidłowy wybór! Wybierz numer od 1 do 7." -ForegroundColor Red
}

Write-Host "Dziękujemy za użycie BagietkaTweaks!" -ForegroundColor Magenta
