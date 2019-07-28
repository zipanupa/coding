get-service | where {$_.Name -like "*ccm*"} | stop-service
set-service -StartupType Disabled -Name ccmexec  
get-service | where {$_.StartType -eq "Disabled"} | ft -autosize | Out-File C:\sched\output.txt