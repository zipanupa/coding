# Start of Settings 
# The NTP server which should be set on your hosts
$ntpserver = "pool.ntp.org|pool2.ntp.org|10.102.0.254|172.22.100.254|172.22.112.246|172.22.112.247|172.22.20.248|172.22.40.246|172.22.42.254|172.22.50.248|172.22.60.254|172.22.70.254|172.22.80.248|172.22.85.254|172.22.93.254"
# End of Settings

$Result = @($VMH | Where {$_.Connectionstate -ne "Disconnected"} | Select Name, @{N="NTPServer";E={$_ | Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key -eq "ntpd"}).Running}} | Where {$_.ServiceRunning -eq $false -or $_.NTPServer -notmatch $ntpserver})
$Result

$Title = "NTP Name and Service"
$Header = "NTP Issues: $(@($Result).Count)"
$Comments = "The following hosts do not have NTP settings and may cause issues if the time becomes far apart from the vCenter/Domain or other hosts"
$Display = "Table"
$Author = "Alan Renouf"
$PluginVersion = 1.2
$PluginCategory = "vSphere"
