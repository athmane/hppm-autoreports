# hppm-autoreports


## SYNOPSIS  
Automatic reports PowerShell script for HP Performance Manager

## DESCRIPTION  
A script to automatically generate reports from HP Performance 
Manager and send them via email (blat) 
**Use at your own risks**

## EXAMPLE
### Manual usage:
    hppm-autoreports.ps1 -BatchPath "E:\Program Files\HP\HP BTO Software\www\webapps\OVPM\datafiles\batch\" -ArchivePath "E:\Report_Archive\" -NodePath "E:\ProgramData\HP\HP BTO Software\shared\server\conf\perf\OVPMSystems.xml" -ContactPath "E:\contacts.xml" -DefaultContact "MyEmail@MyDomain.com"

### As Windows Scheduled Task:
    powershell -Command "& X:\PATH\hppm-autoreports.ps1 -BatchPath 'E:\Program Files\HP\HP BTO Software\www\webapps\OVPM\datafiles\batch\' -ArchivePath 'E:\Report_Archive\' -NodePath 'E:\ProgramData\HP\HP BTO Software\shared\server\conf\perf\OVPMSystems.xml' -ContactPath 'E:\ProgramData\contacts.xml' -DefaultContact 'EMAIL@DOMAIN.COM'"

## NOTES  
    File Name  : hppm-autoreports.ps1  
    Author     : Athmane Madjoudj
    Copyright  : 2016
    Version    : 0.1
    License    : GPLv3+
    Dependencies: blat  ( https://sourceforge.net/projects/blat/ ) 
