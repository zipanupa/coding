$interval = 10000 #ms
$timeout = 2000 #ms
$duration = 240 #Minutes
$begindate = "From " + (get-date -format "ddd d HH.mm")

$nodes = @(
,[PSCustomObject]@{Name = "*LOCAL * Lon CL"; Host = "10.44.63.1"}
,[PSCustomObject]@{Name = "*LOCAL * Lon Vz"; Host = "10.44.63.17"}
,[PSCustomObject]@{Name = "*LOCAL * Lon Talari"; Host = "10.44.0.240"}
,[PSCustomObject]@{Name = "*LOCAL * Lon Riverbed"; Host = "10.44.0.230"}
,[PSCustomObject]@{Name = "*LOCAL * Lon Core"; Host = "172.22.117.254"}
,[PSCustomObject]@{Name = "*REMOTE* DC1 CL"; Host = "10.101.15.1"}
,[PSCustomObject]@{Name = "*REMOTE* DC1 Vz"; Host = "10.101.15.17"}
,[PSCustomObject]@{Name = "*REMOTE* DC2 CL"; Host = "10.102.15.1"}
,[PSCustomObject]@{Name = "*REMOTE* DC2 Vz"; Host = "10.102.15.17"}
,[PSCustomObject]@{Name = "*REMOTE* DC3 CL"; Host = "10.103.15.1"}
,[PSCustomObject]@{Name = "*REMOTE* DC3 Vz"; Host = "10.103.15.1"}
)

function Draw() {
    cls
    $FormattedResults = @()
    $DT = "To - " + (get-date -format "ddd d HH.mm") 
    foreach ($Result in $Results) {
        $success = @($Result.Results.Result | ?{$_.Status -eq "Success"})
        $failed = @($Result.Results.Result | ?{$_.Status -ne "Success"})
        $stats = $success.RoundtripTime | Measure-Object -Maximum -Minimum -Average      
        $FormattedResults += [PSCustomObject] @{
            Name = $Result.Node.Name;
            Host = $Result.Node.Host;
            Success = $Success.Count;
            Fail = $failed.Count;
            Min = $stats.Minimum;
            Max = $stats.Maximum;
            Avg = [Math]::Round($stats.Average, 1);
            BeginDate = $DT
        }
    }
         
    $a = @{Expression={$_.Name};Label="Name";width=22}, `
            @{Expression={$_.Host};Label="Host ID";width=14},
            @{Expression={$_.Success};Label="Success";width=9},
            @{Expression={$_.Fail};Label="Fail";width=5},
            @{Expression={$_.Min};Label="-Min-";width=5},
            @{Expression={$_.Max};Label="-Max-";width=5},
            @{Expression={$_.Avg};Label="-Avg-";width=5},
            @{Expression={$_.BeginDate};Label=$Begindate;width=17}

    <# 
    '$FormattedResults | sort Avg | ft -autosize
    '$FormattedResults | sort Avg | ft -autosize | Out-File C:\powershell\pingresultslocal.txt
    #>
    
    $FormattedResults | sort Avg | ft $a

}

[datetime]$startTime = (get-date)
[datetime]$endTime = $startTime.AddMinutes($duration)

$Results = @()
foreach ($node in $nodes) {
    $Results += [PSCustomObject]@{Node = $node; Results = @()}
}
$Tasks = @()
$loopStart = (get-date)
while ((get-date) -lt $endTime) {
    #while (1) { - temp to keep it running.
    $loopStart = (get-date)   
    foreach ($node in $nodes) {
        $Tasks += [PSCustomObject]@{
            Node = $node;
            Date = (get-date);
            Task = (New-Object System.Net.NetworkInformation.Ping).SendPingAsync($node.Host, $timeout);
        }
    }
    while ((get-date) -lt $loopStart.AddMilliseconds($interval)) {        
        start-sleep -Milliseconds 100        
    }
    $Completed = @($Tasks | ?{$_.Task.IsCompleted -eq $true})
    $Tasks = @($Tasks | ?{$_.Task.IsCompleted -eq $false})
    foreach ($Task in $Completed) {   
        $index = $Results.Node.IndexOf($Task.Node)
        if ($index -ge 0) {    
            $Results[$index].Results += [PSCustomObject]@{Date = $Task.Date; Result = $Task.Task.Result}
            $Results[$index].Results = @($Results[$index].Results | ?{$_.Date -ge (get-date).AddMinutes((-1*$duration))})
            }
    }        
    Draw
}

<#

$a = @{Expression={$_.Name};Label="Process Name";width=14}, `
>> @{Expression={$_.ID};Label="Proce";width=5}, `
>> @{Expression={$_.MainWindowTitle};Label="Window Title";width=40}

Get-Process | where {$_.Name -like "r*"}  | Format-Table $a

#>

<#
,[PSCustomObject]@{Name = "Par Vz"; Host = "10.33.31.17"}
,[PSCustomObject]@{Name = "Ham CL"; Host = "10.49.63.1"}
,[PSCustomObject]@{Name = "Ham Vz"; Host = "10.49.63.17"}
,[PSCustomObject]@{Name = "DC2 CL"; Host = "10.102.15.1"}
,[PSCustomObject]@{Name = "DC2 Vz"; Host = "10.102.15.17"}
,[PSCustomObject]@{Name = "Fran CL"; Host = "10.49.31.1"}
,[PSCustomObject]@{Name = "Fran Vz"; Host = "10.49.31.17"}
,[PSCustomObject]@{Name = "Mun Vz"; Host = "10.49.127.17"}
,[PSCustomObject]@{Name = "Mad CL"; Host = "10.34.31.1"}
,[PSCustomObject]@{Name = "Mad Vz"; Host = "10.34.31.17"}
,[PSCustomObject]@{Name = "Mil CL"; Host = "10.39.31.1"}
,[PSCustomObject]@{Name = "Mil Vz"; Host = "10.39.31.17"}
,[PSCustomObject]@{Name = "Rom CL"; Host = "10.39.63.1"}
,[PSCustomObject]@{Name = "Rom Vz"; Host = "10.39.63.17"}
,[PSCustomObject]@{Name = "Ath CL"; Host = "10.30.31.1"}
,[PSCustomObject]@{Name = "Ath Vz"; Host = "10.30.31.17"}
,[PSCustomObject]@{Name = "NY CL"; Host = "10.1.191.1"}
,[PSCustomObject]@{Name = "NY Vz"; Host = "10.1.191.17"}
,[PSCustomObject]@{Name = "Dub CL"; Host = "10.97.31.1"}
,[PSCustomObject]@{Name = "Dub Vz"; Host = "10.97.31.17"}
,[PSCustomObject]@{Name = "Ban CL"; Host = "10.66.31.1"}
,[PSCustomObject]@{Name = "Ban Vz"; Host = "10.66.31.17"}
,[PSCustomObject]@{Name = "DC3 CL"; Host = "10.103.15.1"}
,[PSCustomObject]@{Name = "DC3 Vz"; Host = "10.103.15.1"}
,[PSCustomObject]@{Name = "Sin CL"; Host = "10.65.31.1"}
,[PSCustomObject]@{Name = "Sin Vz"; Host = "10.65.31.17"}
,[PSCustomObject]@{Name = "Hon CL"; Host = "10.85.63.1"}
,[PSCustomObject]@{Name = "Hon Vz"; Host = "10.85.63.17"}

#>