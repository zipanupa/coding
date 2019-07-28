#Get Cluster Datastore Details.
Get-Cluster "DC3 Cluster" | Get-Datastore | Foreach-Object {
    $ds = $_.Name
    $_ | Get-VM | Select-Object Name,powerstate,numcpu,memorygb,@{n='DataStore';e={$ds}} 
} | Export-Csv -NoTypeInformation 'C:\Powershell\Get-VMDiskUsageDC3.csv'

Get-Cluster "DC1 VDI Cluster" | Get-Datastore | where Name -notlike '*_DC1_TINTRI_*' | Foreach-Object {
    $ds = $_.Name
    $_ | Get-VM | Select-Object Name,powerstate,numcpu,memorygb,@{n='DataStore';e={$ds}}
} | Export-Csv -NoTypeInformation 'C:\Powershell\Get-VMDiskUsageDC3VDI.csv'

#Get Datacenter Network Adapter Details.
Get-DataCenter DataCenterName | Get-VM | Get-NetworkAdapter | Select-Object @{N="VM";E={$_.Parent.Name}},@{N="NIC";E={$_.Name}},@{N="Network";E={$_.NetworkName}} | Export-csv C:\Powershell\VMPortGroups.csv

#Get networks a VM is using.
$variable = Get-Cluster "DC1 VDI Cluster" | Get-VM | Sort Name | Foreach-Object {
    $vm = $_.Name
    $_ | Get-NetworkAdapter | Select-Object @{n='Name';e={$vm}},NetworkName
} 

#Create new datastore on a host.
New-Datastore -Nfs -VMHost wfwdc2vm03.wfw.com -Name "NFS_DC2_TINTRI_01_VMS" -path "/tintri/VMs" -NfsHost 10.102.5.102

#Set maximum number of NFS stores available to host
Get-AdvancedSetting -Entity wfwdc2vm09.wfw.com -Name NFS.Maxvolumes | Set-AdvancedSetting -Value 9

#Switch on/off SSH/ESXi Shell
#SSH on
Get-VMHostService -VMHost wfwdc3vm03.wfw.com | Where-Object {$_.Key -eq "TSM-SSH"} | Start-VMHostService -confirm:$false
#ESXi Shell on
Get-VMHostService -VMHost wfwdc3vm03.wfw.com | Where-Object {$_.Key -eq "SSH"} | Start-VMHostService -confirm:$false

#SSH off
Get-VMHostService -VMHost wfwdc3vm03.wfw.com | Where-Object {$_.Key -eq "TSM-SSH"} | Stop-VMHostService -confirm:$false
#ESXi Shell off
Get-VMHostService -VMHost wfwdc3vm03.wfw.com | Where-Object {$_.Key -eq "SSH"} | Stop-VMHostService -confirm:$false

#Switch on for a cluster
$cluster = Get-VMHost -Location "DC3 cluster"
foreach ($vmhost in $cluster) {
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM"} | Set-VMHostService -policy "off" -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM"} | Start-VMHostService -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM-SSH"} | Set-VMHostService -policy "off" -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM-SSH"} | Start-VMHostService -Confirm:$false
    #This next line of code (unwisely) turns off yellow warning icon on the host so it's commented out.
    #Get-VMHost $vmhost| Set-VmHostAdvancedConfiguration -Name UserVars.SuppressShellWarning -Value 1
    Write-Host "Host $vmhost is configured" -ForegroundColor Green
    }
#Switch off for a cluster
$cluster = Get-VMHost -Location "DC3 cluster"
foreach ($vmhost in $cluster) {
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM"} | Set-VMHostService -policy "off" -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM"} | Stop-VMHostService -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM-SSH"} | Set-VMHostService -policy "off" -Confirm:$false
    Get-VMHostService -VMHost $vmhost | Where-Object {$_.Key -eq "TSM-SSH"} | Stop-VMHostService -Confirm:$false
    #This next line of code (unwisely) turns off yellow warning icon on the host so it's commented out.
    #Get-VMHost $vmhost| Set-VmHostAdvancedConfiguration -Name UserVars.SuppressShellWarning -Value 1
    Write-Host "Host $vmhost is configured" -ForegroundColor Green
    }