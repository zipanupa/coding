$interval = 10000 #ms
$timeout = 2000 #ms
$duration = 10080 #Minutes
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
            Success = $success.Count;
            Fail = $failed.Count;
            Min = $stats.Minimum;
            Max = $stats.Maximum;
            Avg = [Math]::Round($stats.Average, 1);
            BeginDate = $DT
        }
    }
        $a = @{Expression={$_.Name};Label="Name";width=22}, `
            @{Expression={$_.Host};Label="Host ID";width=15},
            @{Expression={$_.Success};Label="Success";width=9},
            @{Expression={$_.Fail};Label="Fail";width=5},
            @{Expression={$_.Min};Label="-Min-";width=5},
            @{Expression={$_.Max};Label="-Max-";width=5},
            @{Expression={$_.Avg};Label="-Avg-";width=5},
            @{Expression={$_.BeginDate};Label=$Begindate;width=17}

    <# Old Code
    '$FormattedResults | sort Avg | ft -autosize
    '$FormattedResults | sort Avg | ft -autosize | Out-File C:\powershell\pingresultslocal.txt
    #>
    
    $FormattedResults | sort Avg | ft $a
    $FormattedResults | sort Avg | ft $a | Out-File C:\powershell\pingresultslocal.txt
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