# BagietkaTweaks v1.0
# Written by ChatGPT
# This script allows users to apply system optimizations by selecting various options.
# After running the script, you will be presented with a menu to choose which tweaks to apply.

Function Show-Menu {
    Clear-Host
    Write-Host "===================================================="
    Write-Host "            Welcome to BagietkaTweaks v1.0"
    Write-Host "===================================================="
    Write-Host "1. Ping Optimizations"
    Write-Host "2. Delay Optimizations (Keyboard and Mouse)"
    Write-Host "3. Performance Optimizations"
    Write-Host "4. Internet Optimizations"
    Write-Host "5. Disable Unnecessary Processes"
    Write-Host "6. Restore Point"
    Write-Host "Q. Quit"
    Write-Host "===================================================="
}

Function Ping-Optimizations {
    Write-Host "Applying Ping Optimizations..."
    # Disable unnecessary network protocols to reduce ping
    Disable-NetAdapterBinding -Name "Ethernet" -ComponentID "ms_netbios" -Confirm:$false
    Disable-NetAdapterBinding -Name "Wi-Fi" -ComponentID "ms_netbios" -Confirm:$false
    # More optimizations can be added here
    Write-Host "Ping Optimizations applied!"
}

Function Delay-Optimizations {
    Write-Host "Applying Delay Optimizations..."
    # Registry tweaks for improving input lag
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MouseSpeed" -Value 1
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MouseThreshold1" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MouseThreshold2" -Value 0
    Write-Host "Delay Optimizations applied!"
}

Function Performance-Optimizations {
    Write-Host "Applying Performance Optimizations..."
    # Enable Ultimate Performance Plan
    powercfg -duplicatescheme 8c5e7e7d-14c3-48b1-bd84-120d66bf8a43
    # Disable unnecessary animations in Windows
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value 90
    # Disable Cortana and search
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 0
    Write-Host "Performance Optimizations applied!"
}

Function Internet-Optimizations {
    Write-Host "Applying Internet Optimizations..."
    # Disable unnecessary network protocols to optimize internet speed
    Disable-NetAdapterBinding -Name "Wi-Fi" -ComponentID "ms_tcpip6" -Confirm:$false
    Disable-NetAdapterBinding -Name "Ethernet" -ComponentID "ms_tcpip6" -Confirm:$false
    Write-Host "Internet Optimizations applied!"
}

Function Disable-Unnecessary-Processes {
    Write-Host "Disabling unnecessary processes..."
    # Disable Xbox processes
    Stop-Process -Name "XboxApp" -Force
    Stop-Process -Name "XboxSpeechToText" -Force
    Stop-Process -Name "GamingServices" -Force
    Stop-Process -Name "Microsoft.Store" -Force
    # Disable OneDrive
    Stop-Process -Name "OneDrive" -Force
    # Disable other unnecessary processes (add more if needed)
    Stop-Process -Name "SearchIndexer" -Force
    Stop-Process -Name "Cortana" -Force
    Write-Host "Unnecessary processes disabled!"
}

Function Create-RestorePoint {
    Write-Host "Creating restore point..."
    # Create a restore point
    Checkpoint-Computer -Description "BagietkaTweaks Restore Point" -RestorePointType "MODIFY_SETTINGS"
    Write-Host "Restore Point created!"
}

# Main loop to show menu and select options
Do {
    Show-Menu
    $selection = Read-Host "Please select an option"

    Switch ($selection) {
        '1' { Ping-Optimizations }
        '2' { Delay-Optimizations }
        '3' { Performance-Optimizations }
        '4' { Internet-Optimizations }
        '5' { Disable-Unnecessary-Processes }
        '6' { Create-RestorePoint }
        'Q' { Write-Host "Exiting BagietkaTweaks..." }
        Default { Write-Host "Invalid selection, please choose again." }
    }
    Pause
} While ($selection -ne 'Q')
