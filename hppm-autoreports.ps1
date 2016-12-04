<#  
.SYNOPSIS  
    Automatic reports for HP Performance Manager
.DESCRIPTION  
    A script to automatically generate reports from HP Performance 
    Manager and send them via email (blat) 
    Use at your own risks
.EXAMPLE
    Manual:
    hppm-autoreports.ps1 -BatchPath "E:\Program Files\HP\HP BTO Software\www\webapps\OVPM\datafiles\batch\" -ArchivePath "E:\Report_Archive\" -NodePath "E:\ProgramData\HP\HP BTO Software\shared\server\conf\perf\OVPMSystems.xml" -ContactPath "E:\contacts.xml" -DefaultContact "MyEmail@MyDomain.com"

    Scheduled Task:
    powershell -Command "& X:\PATH\hppm-autoreports.ps1 -BatchPath 'E:\Program Files\HP\HP BTO Software\www\webapps\OVPM\datafiles\batch\' -ArchivePath 'E:\Report_Archive\' -NodePath 'E:\ProgramData\HP\HP BTO Software\shared\server\conf\perf\OVPMSystems.xml' -ContactPath 'E:\ProgramData\contacts.xml' -DefaultContact 'EMAIL@DOMAIN.COM'"
.NOTES  
    File Name  : hppm-autoreports.ps1  
    Author     : Athmane Madjoudj
    Copyright  : 2016
    Version    : 0.1
    License    : GPLv3+

#>


Param(
  [string]$BatchPath,
  [string]$ArchivePath,
  [string]$NodePath,
  [string]$ContactPath,
  [string]$DefaultContact
)

[xml]$ovpmsystems = Get-Content $NodePath
[xml]$contacts = Get-Content $ContactPath
$date = $(date -format 'yyyy-MM-dd')

foreach ($group in $ovpmsystems.LISTOF_GROUPS.GROUP) {
    if ($group.DisplayName -ne 'All') {
        $group_name = $group.DisplayName
        $report_contact = $($contacts.CONTACTS.GROUP | ?{ $_.DisplayName -eq $group.DisplayName }).CONTACT.value
        $report_contact = $DefaultContact + ',' + $report_contact
        foreach ($metric in @('CPU','Memory','Disk','Network')) {
            # Cleanup
            rm -force $BatchPath/*.*
            cd $BatchPath
            
            foreach ($node in $group.SYSTEM) {
                ovpmbatch CUSTOMER=rouser PASSWORD=rouser GRAPHTEMPLATE=VPI_GraphsInfraSPI.txt GRAPH="$metric Summary" SYSTEMNAME="$($node.value)"
                #echo $node.value
            }
            echo "<h1>HP Performance manager reports for $metric - $group_name</h1>" > reports.html
            foreach ($f in ls *.png)  {
                $f2 = $f.basename
                echo "<img src='cid:$f2.png'><br/><br/>" >> reports.html
            }
            blat reports.html -embed  *.png -s "HP Performance manager reports - $metric - $group_name" -f "hp-perf-mgr@$env:computername.$env:userdnsdomain" -to "$report_contact"
            ## Archive 
            mkdir -force $ArchivePath\$date\$group_name\$metric
            copy *.png $ArchivePath\$date\$group_name\$metric
        }
    }
}
