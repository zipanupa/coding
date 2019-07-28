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

$lunTab = @{}
Get-ScsiLun -VMHost (Get-VM $VM).VMHost | %{
   $lunTab.Add($_.CanonicalName,$_)
}

if (Get-VM $VM) {

    $Disks = Get-VM $VM | Get-HardDisk | Where {$_.DiskType -eq "RawPhysical"}
    $WinDisks = Get-WmiObject -Class Win32_DiskDrive -ComputerName $VM
    $Luns = @()

    Foreach ($Disk in $Disks) {
        $Lun = "" | Select CanonicalName,RunTimeName,LunType,CapacityGB,MultipathPolicy,LUNNumber,MountPoint,VolumeName
        $SCSILun = $lunTab[$Disk.SCSICanonicalName]
        $Lun.CanonicalName = $SCSILun.CanonicalName
        $Lun.RuntimeName = $SCSILun.RuntimeName
        $Lun.LunType = $SCSILun.LunType
        $Lun.CapacityGB = $SCSILun.CapacityGB
        $Lun.MultipathPolicy = $SCSILun.MultipathPolicy
        $Lun.LUNNumber = $SCSILun.RuntimeName.Substring($SCSILun.RuntimeName.LastIndexof("L")+1)
        $SCSIController = Get-SCSIController -HardDisk $Disk
        $DiskMatch = $WinDisks | ?{($_.SCSIPort - 2) -eq $SCSIController.ExtensionData.BusNumber -and $_.SCSITargetID -eq $Disk.ExtensionData.UnitNumber}
        if ($DiskMatch) {
            $Volume,$Drive = @()
            $partitionquery = "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($DiskMatch.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"
            $partitions = @(Get-WmiObject -Query $partitionquery -ComputerName $VM)
            foreach ($partition in $partitions) {
                $logicaldiskquery = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($partition.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"
                $logicaldisks = @(Get-WmiObject -ComputerName $VM -Query $logicaldiskquery)
                foreach ($logicaldisk in $logicaldisks) {
                    $Drive += $logicaldisk.Name
                    $Volume += $logicaldisk.VolumeName
                }                    
            $Lun.MountPoint = $Drive
            $Lun.VolumeName = $Volume
            }
        $Luns += $Lun
        }
    
    }
    $Luns | ft -autosize
    
    # | Out-Gridview

} 
