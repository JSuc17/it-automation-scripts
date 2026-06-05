<#
.SYNOPSIS
Checks BitLocker status on local volumes.

.DESCRIPTION
This script displays BitLocker protection status, encryption percentage,
volume type, and key protector information for local drives.

.NOTES
Author: Juan Sucre
Use case: Endpoint security and compliance validation
#>

Write-Host "Checking BitLocker status..." -ForegroundColor Cyan

try {
    $volumes = Get-BitLockerVolume

    if (-not $volumes) {
        Write-Host "No BitLocker volumes found." -ForegroundColor Yellow
        exit
    }

    $volumes | Select-Object MountPoint, VolumeType, ProtectionStatus, LockStatus,
    EncryptionMethod, VolumeStatus, EncryptionPercentage,
    @{
        Name = "KeyProtectors"
        Expression = { ($_.KeyProtector.KeyProtectorType -join ", ") }
    } | Format-Table -AutoSize
}
catch {
    Write-Host "Error checking BitLocker status." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Try running PowerShell as Administrator." -ForegroundColor Yellow
}
