Get-WmiObject -Class Win32_DiskDrive | foreach { 
    "`n {0} {1}" -f $($_.Name), $($_.Model) 

    $query = "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=’" ` 
     + $_.DeviceID + "’} WHERE ResultClass=Win32_DiskPartition" 
      
    Get-WmiObject -Query $query | foreach { 
        "" 
        "Name : {0}" -f $_.Name 
        "Description : {0}" -f $_.Description 
        "PrimaryPartition : {0}" -f $_.PrimaryPartition 
     
        $query2 = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=’" ` 
        + $_.DeviceID + "’} WHERE ResultClass=Win32_LogicalDisk" 
             
        Get-WmiObject -Query $query2 | Format-List Name, 
        @{Name="Disk Size (GB)"; Expression={"{0:F3}" -f $($_.Size/1GB)}}, 
        @{Name="Free Space (GB)"; Expression={"{0:F3}" -f $($_.FreeSpace/1GB)}} 
        }}