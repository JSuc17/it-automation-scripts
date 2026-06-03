<#
.SYNOPSIS
Collects basic device information from a Windows computer.

.DESCRIPTION
This script gathers useful information for IT support and infrastructure tasks,
including operating system, hardware, BIOS, memory, disk, and network details.

.NOTES
Author: Juan Sucre
Use case: Endpoint inventory and troubleshooting
#>

Write-Host "Collecting device information..." -ForegroundColor Cyan

$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$operatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem
$bios = Get-CimInstance -ClassName Win32_BIOS
$processor = Get-CimInstance -ClassName Win32_Processor
$disks = Get-CimInstance -ClassName Win32_DiskDrive
$networkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object {
    $_.IPEnabled -eq $true
}

$deviceInfo = [PSCustomObject]@{
    ComputerName     = $env:COMPUTERNAME
    Manufacturer     = $computerSystem.Manufacturer
    Model            = $computerSystem.Model
    SerialNumber     = $bios.SerialNumber
    OS               = $operatingSystem.Caption
    OSVersion        = $operatingSystem.Version
    BuildNumber      = $operatingSystem.BuildNumber
    CPU              = $processor.Name
    RAM_GB           = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    LastBootTime     = $operatingSystem.LastBootUpTime
    LoggedUser       = $computerSystem.UserName
}

Write-Host "`n=== DEVICE INFORMATION ===" -ForegroundColor Green
$deviceInfo | Format-List

Write-Host "`n=== DISK INFORMATION ===" -ForegroundColor Green
$disks | Select-Object Model, InterfaceType, MediaType, SerialNumber,
@{
    Name = "Size_GB"
    Expression = { [math]::Round($_.Size / 1GB, 2) }
} | Format-Table -AutoSize

Write-Host "`n=== NETWORK INFORMATION ===" -ForegroundColor Green
$networkAdapters | Select-Object Description, MACAddress,
@{
    Name = "IPAddress"
    Expression = { $_.IPAddress -join ", " }
},
@{
    Name = "DefaultGateway"
    Expression = { $_.DefaultIPGateway -join ", " }
},
DHCPEnabled | Format-Table -AutoSize
