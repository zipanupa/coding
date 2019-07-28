$disk = Get-WmiObject Win32_LogicalDisk -ComputerName WFWDC2EXCH04 -Filter "DeviceID='DC1DB1'" |
Select-Object Size,FreeSpace

$disk.Size
$disk.FreeSpace

 $diskReport = Get-WmiObject Win32_logicaldisk -ComputerName WFWDC2EXCH04