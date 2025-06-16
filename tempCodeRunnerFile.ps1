# Check basic audit policy
Write-Host "`n--- Basic Audit Policy ---"
auditpol /get /category:*

# Check advanced audit policy
Write-Host "`n--- Advanced Audit Policy (Subcategories) ---"
auditpol /get /subcategory:* /r

# Check PowerShell logging
Write-Host "`n--- PowerShell Logging ---"
$psLogSettings = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
if (Test-Path $psLogSettings) {
    Get-ItemProperty -Path $psLogSettings
} else {
    Write-Host "Script Block Logging not configured."
}

$moduleLogSettings = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging'
if (Test-Path $moduleLogSettings) {
    Get-ItemProperty -Path $moduleLogSettings
} else {
    Write-Host "Module Logging not configured."
}

# Check if Sysmon is installed and running
Write-Host "`n--- Sysmon Status ---"
if (Get-Service -Name sysmon -ErrorAction SilentlyContinue) {
    Get-Service -Name sysmon
} else {
    Write-Host "Sysmon not installed."
}

# Check Defender logging settings
Write-Host "`n--- Windows Defender Logging ---"
Get-MpPreference | Select-Object *log*

# Check AppLocker or WDAC presence
Write-Host "`n--- AppLocker / WDAC Policies ---"
$polPath = "C:\Windows\System32\AppLocker\"
if (Test-Path $polPath) {
    Get-AppLockerPolicy -Effective | Select-Object -ExpandProperty RuleCollections
} else {
    Write-Host "AppLocker not in use."
}

# Check Event Forwarding status
Write-Host "`n--- Event Forwarding ---"
wecutil es

# Check BitLocker status
Write-Host "`n--- BitLocker Status ---"
Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, ProtectionStatus

# Check Security log settings
Write-Host "`n--- Security Event Log Configuration ---"
Get-EventLog -LogName Security -List | Select-Object Log, MaximumKilobytes, RetentionDays, OverflowAction

Write-Host "`n--- Logging check complete. ---"
