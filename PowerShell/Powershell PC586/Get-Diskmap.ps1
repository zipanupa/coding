
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
            #Configure-Disk
        }
    }
    if ($Found = $False)
    {
        Write-Host "Could not find entry for $MachineName in servers.csv file" -foregroundcolor Magenta
    }
}
$DiskPart = import-csv .\servers.csv
Write-Host -ForegroundColor Green "Starting"
$DiskPart = import-csv .\servers.csv
$Found = $False
get-diskmap
