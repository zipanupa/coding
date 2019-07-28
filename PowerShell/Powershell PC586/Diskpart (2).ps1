#==========================================================================
#       Diskpart.ps1
#       Version 1.2
#
#       THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
#       KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
#       IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
#       PARTICULAR PURPOSE.
#
#
#==========================================================================
#
# Imports the servers.csv file and reads the diskmap to create an array for the actual formatting and mounting
# The header line of the server.csv file contains the following:
#     "ServerName","StartDrive","DriveCount","Path"
# 
# The servers.csv file contains one like for each server in the DAG.  An example line is included below
#     "Server 1", "3", "4", "E:\Mountpoints\DB1, E:\Mountpoints\DB7, E:\Mountpoints\DB9, E:\Mountpoints\DB11"
#
#     Servername = "Server 1"                = the host name of the computer
#     StartDrive = "3"                       = the drive number in Disk Manager of the first drive on the server to use for the DAG
#     DriveCount = "4"                       = the number of physical drives on the server to mount for the DAG
#     Path       = "E:\Mountpoints\DB1, ..." = a single string with the mount point for all drives on the server in the DAG
#                                              Note: the number of paths in Path variable should match the value of DriveCount for that server
#

function Get-Diskmap()
{
    $Machine = get-wmiobject "Win32_ComputerSystem"
    $MachineName = $Machine.Name
	Write-Host -ForegroundColor Yellow "Local:" $MachineName "Count" @($Diskpart).count
    foreach($Line in $Diskpart)
    {
        if ($MachineName -eq $Line.ServerName)
        {
			Write-Host -ForegroundColor Green "Found Server"
            $Found = $True
            [array]$Diskmap = $Line.Path -split ","
            $DiskStart = [int]$Line.StartDrive
            $DiskCount = [int]$Line.DriveCount
			Write-Host "Start" $DiskStart "Count" $DiskCount "Paths" $Diskmap
            Configure-Disk
        }
    }
    if ($Found = $False)
    {
        Write-Host "Could not find entry for $MachineName in servers.csv file" -foregroundcolor Magenta
    }
}

function Run-Diskpart
{
    param ([array]$commands)
    $tempfile = [System.IO.Path]::GetTempFileName()
    foreach ($com in $commands)
    {
        add-content $tempfile $com
    }
    $output = DiskPart /s $tempfile
    remove-item $tempfile
    $output 
}

###Important Note: The Disk number below must match the diskmap for each server.
###                The Disk number starting point must be accurate on your machine and match your diskmap

function Configure-Disk()
{
    for($Disk = $DiskStart; $Disk -lt ($DiskStart + $DiskCount); $Disk++)
    {
		$Path = $Diskmap[$Disk-$DiskStart]
		$Path = $Path.trimstart().trimend()
		Write-Host -ForegroundColor Yellow "Path" $Path
        if ((test-path $Path) -eq $false) 
        {
            new-item $Path -type directory
        }
        $format = "format FS=NTFS UNIT=64k Label="+(split-path $Path -leaf) + " QUICK"
		#Write-Host -ForegroundColor Yellow $format 
		
        $mount = "assign mount="+ ($Path)
		#Write-Host -ForegroundColor Yellow $mount
		
        # Scripted diskpart will error out if it tries to do a command that is redundant.
        #  i.e. Online a disk that is already online.
        # To get around that without checking the status of each disk, we just divide the script into several
        #  commands and assume some might error out, but we forge ahead nonetheless.
        # The end result is that the disks get into the state we need.
        Run-diskpart "select disk $Disk","online disk"
        Run-diskpart "select disk $Disk","clean"
        Run-diskpart "select disk $Disk","attributes disk clear readonly","convert MBR"
        Run-diskpart "select disk $Disk","offline disk"
        Run-diskpart "select disk $Disk","attributes disk clear readonly","online disk","convert GPT","create partition primary","$format","$mount"
    }
}

Write-Host -ForegroundColor Green "Starting"
$DiskPart = import-csv .\servers.csv
$Found = $False
get-diskmap

