<#
function Prompt
{
"MCCM1  PS > " + (Get-Location|Get-Item)
}
#>

function prompt {
  $p = Split-Path -leaf -path (Get-Location)
  "$p MCCM1 PS> "
}

function CheckDiskSpace ([string[]]$computerName = ".") {
    $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $computerName -Filter "DriveType=3" |
    Select-Object DeviceID,FreeSpace,Size,@{N="FreeSpaceGB"; E= {[math]::Round($_.FreeSpace/1GB,2)}},@{N="SizeGB"; E= {[math]::Round($_.Size/1GB,2)}},@{N="%Free";E={($_.FreeSpace/$_.Size).ToString("P")}}
    $disk | ft
}

#wrote it today, uses WMI to query the disk space of a remote server
#Example CheckDiskSpace wfwlosccm02



# Add-PSSnapin VMware.VimAutomation.Core
# Add-PSSnapin VMware.VumAutomation
# Add-PSSNapin -Name Microsoft.Exchange.Management.PowerShell.E2010
# Import-Module DataONTAP

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://wfwdc1exch03.wfw.com/powershell/" -Authentication Kerberos

Import-PSSession $Session

cd c:\powershell


