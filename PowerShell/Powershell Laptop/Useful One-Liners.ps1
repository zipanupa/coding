
# Display a table of processes that includes only the process names, IDs, and whether they’re responding to Windows (the Responding property has that information). Have the table take up as little horizontal room as possible, but don’t allow any information to be truncated.
Get-Process | format-table -Property ProcessName,Id,Responding -AutoSize

# Display a table of processes that includes the process names and IDs. Also include columns for virtual and physical memory usage, expressing those values in megabytes (MB).
Get-Process | format-table ProcessName,Id,@{n='VM(MB)';e={$_.VM / 1MB -as [int]}},@{n='WS(MB)';e={$_.WS / 1MB -as [int]}}

# Use Get-EventLog on Windows to display a list of available event logs. (Hint: you need to read the help to learn the correct parameter to accomplish that.) Format the output as a table that includes, in this order, the log display name and the retention period. The column headers must be LogName and RetDays.
Get-EventLog -List | Format-Table @{n='LogName';e={$_.LogDisplayName}},@{n='RetDays';e={$_.MinimumRetentionDays}}

# Display a list of services so that a separate table is displayed for services that are started and services that are stopped. Services that are started should be displayed first. (Hint: use a -groupBy parameter.)
Get-Service | Sort-Object -Property Status -Descending | Format-Table -GroupBy Status

#Display a four-column-wide list of all directories in the root of the C: drive.
Get-ChildItem C:\ -Directory | Format-Wide -Column 4

#Create a formatted list of all .exe files in C:\Windows displaying the name, version information, and file size. PowerShell uses the length property, but to make it clearer, your output should show Size.
Get-ChildItem C:\Windows -Filter *.exe | Format-list -Property Name,VersionInfo,@{n='Size';e={$_.Length}}

#Get list of running services on remote PC (requires admin privileges).
Get-Service -ComputerName "WFWLON-PC586" | where {$_.Status -eq "running"} | format-wide -Column 4

#Get list of if all snapmanager/snapdrive services are running - strictly speaking this is a two-liner!
$servers = "WFWDC1EXCH01","WFWDC1EXCH02","WFWDC1EXCH03","WFWDC1EXCH04","WFWDC2EXCH01","WFWDC2EXCH02","WFWDC3EXCH01","WFWDC3EXCH02"
Get-Service -ComputerName $servers | where {$_.DisplayName -like "snap*" -and $_.Status -eq "Running"} | sort displayname,machinename | select Machinename, Status, Name, DisplayName
