<#
.SYNOPSIS
Enables WinRM for remote administration.

.DESCRIPTION
This script enables PowerShell remoting and configures WinRM basics.
It is intended for controlled IT environments where remote administration is required.

.NOTES
Author: Juan Sucre
Use case: Remote administration preparation
Run as Administrator.
#>

Write-Host "Configuring WinRM..." -ForegroundColor Cyan

try {
    Enable-PSRemoting -Force

    Set-Service -Name WinRM -StartupType Automatic
    Start-Service -Name WinRM

    winrm quickconfig -quiet

    Write-Host "WinRM has been enabled successfully." -ForegroundColor Green

    Write-Host "`nCurrent WinRM listeners:" -ForegroundColor Cyan
    winrm enumerate winrm/config/listener
}
catch {
    Write-Host "Error configuring WinRM." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "Make sure you are running PowerShell as Administrator." -ForegroundColor Yellow
}
