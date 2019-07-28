﻿@" 
=============================================================================== 
Title: Export-VMInfo.ps1 
Description: Exports VM Information from vCenter into a .CSV file for importing into anything 
Usage: .\Export-VMInfo.ps1 
Date: 04/03/2010 
=============================================================================== 
"@

<#
Get-VM "AnyVM" | Get-Member Get-VM "AnyVM"| Get-View | Get-Member


filter Get-FolderPath { 
    $_ | Get-View | % { 
        $row = "" | select Name, Path 
        $row.Name = $_.Name 
    $current = Get-View $_.Parent 
    # $path = $_.Name # Uncomment out this line if you do want the VM Name to appear at the end of the path 
    $path = "" 
    do { 
        $parent = $current 
        if($parent.Name -ne "vm"){$path = $parent.Name + "\" + $path} 
        $current = Get-View $current.Parent 
    } while ($current.Parent -ne $null) 
    $row.Path = $path 
    $row 
    } 
}
#>
 
#$VCServerName = "vCenter.local" 
#$VC = Connect-VIServer $VCServerName 
$VMDC = "New York Datacenter" 
$ExportFilePath = "C:\powershell\Export-VMInfo.csv" 

$Report = @() 
$VMs = Get-DataCenter $VMDC | Get-VM 
$Datastores = Get-Datastore | select Name, Id 
$VMHosts = Get-VMHost | select Name, Parent 
ForEach ($VM in $VMs) { 
$VMView = $VM | Get-View 
$VMInfo = {} | Select VMName,Powerstate,OS,Folder,IPAddress,ToolsStatus,Host,Cluster,Datastore,NumCPU,MemMb,DiskGb, DiskFree, DiskUsed 
$VMInfo.VMName = $vm.name 
$VMInfo.Powerstate = $vm.Powerstate 
$VMInfo.OS = $vm.Guest.OSFullName 
$VMInfo.IPAddress = $vm.Guest.IPAddress[0] 
$VMInfo.ToolsStatus = $VMView.Guest.ToolsStatus 
$VMInfo.Host = $vm.host.name 
$VMInfo.Cluster = $vm.host.Parent.Name 
$VMInfo.Datastore = ($Datastores | where {$_.ID -match (($vmview.Datastore | Select -First 1) | Select Value).Value} | Select Name).Name 
$VMInfo.NumCPU = $vm.NumCPU 
$VMInfo.MemMb = [Math]::Round(($vm.MemoryMB),2) 
$VMInfo.DiskGb = [Math]::Round((($vm.HardDisks | Measure-Object -Property CapacityKB -Sum).Sum * 1KB / 1GB),2) 
$VMInfo.DiskFree = [Math]::Round((($vm.Guest.Disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB),2) 
$VMInfo.DiskUsed = $VMInfo.DiskGb - $VMInfo.DiskFree 
$Report += $VMInfo 
}

$Report = $Report | Sort-Object VMName 
IF ($Report -ne "") { $report | Export-Csv $ExportFilePath -NoTypeInformation
} #$VC = Disconnect-VIServer -Confirm:$False

#>

#$VMInfo.Folder = ($vm | Get-Folderpath).Path 