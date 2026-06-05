# Usage Guide

This document explains how to run the scripts included in this repository.

## Requirements

- Windows 10, Windows 11, or Windows Server
- PowerShell 5.1 or later
- Administrator permissions for some scripts

## Running a Script

Open PowerShell and run:

```powershell
cd C:\Path\To\it-automation-scripts\powershell
.\get-device-info.ps1

If script execution is blocked, run PowerShell as Administrator and use:

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
