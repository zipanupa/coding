#Possible fields
#Id
#CanonicalName
#RuntimeName
#Key
#LunType
#Model
#SerialNumber
#Vendor
#ConsoleDeviceName
#CapacityMB
#CapacityGB
#MultipathPolicy
#CommandsToSwitchPat
#BlocksToSwitchPath
#HostId
#VMHostId
#VMHost
#Uid
#IsLocal
#ExtensionData
#Client

Param($VM)

if (Get-VM $VM) {

$Disks = Get-VM $VM | Get-HardDisk | Where {$_.DiskType -eq “RawPhysical”}

Foreach ($Disk in $Disks) {

$output = Get-SCSILun $Disk.SCSICanonicalName -VMHost (Get-VM $VM).VMHost | Select-Object CanonicalName,RunTimeName,LunType,CapacityGB,MultipathPolicy,@{Name="LUN number";Expression={$_.RuntimeName.Substring($_.RuntimeName.LastIndexof(“L”)+1)}} | ft -AutoSize

$output

#$lun = Get-SCSILun $Disk.SCSICanonicalName -VMHost (Get-VM $VM).VMHost

#$Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1)

}
}

