
<#
Mark's NetApp Function Library
Created 5th May 2016
Updated 19 May 2016

Functions
Get-FilerInfo [Filer Name] = This returns the aggregates and volumes from the filer supplied

Old Code
$Array = Get-NaEfficiency 
$vols = Get-NaVol
Clear-Host
$vols | # where {$_.Name -like 'testvol'} # | Select `
    @{Label='Aggregate';Expression={$Aggrs.Name}},`
    @{Label='Volume Name';Expression={$_.Name}},`
    @{Label='Used GB';Expression={[Math]::Round($_.SizeUsed/1GB,2)}},`
    #@{Label='SnapShot Usage';Expression={[Math]::Round((Get-NaEfficiency $_.Name | select SnapUsage)/1GB,2)}},`
    @{Label='%Used';Expression={$_.PercentageUsed}},`
    @{Label='Available';Expression={[Math]::Round($_.SizeAvailable/1GB,2)}},`
    @{Label='Total';Expression={[Math]::Round($_.SizeTotal/1GB,2)}} | Sort 'Volume Name' | ft -AutoSize

for ($i=0; $i -lt $Array.Length; $i++)
{
    if ($Array[$i].SnapUsage.Used -gt 1TB)
        {
        $CurVal = $Array[$i].SnapUsage.Used/1TB
        "`$Array[$i]=" + $Array[$i].Name +"={0:N1} TB" -f $CurVal
        continue
        }
    if ($Array[$i].SnapUsage.Used -gt 1GB)
        {
        $CurVal = $Array[$i].SnapUsage.Used/1GB
        "`$Array[$i]=" + $Array[$i].Name +"={0:N1} GB" -f $CurVal
        continue
        }
    if ($Array[$i].SnapUsage.Used -gt 1MB)
        {
        $CurVal = $Array[$i].SnapUsage.Used/1MB
        "`$Array[$i]=" + $Array[$i].Name +"={0:N1} MB" -f $CurVal
        continue
        }
    if ($Array[$i].SnapUsage.Used -gt 1KB)
        {
        $CurVal = $Array[$i].SnapUsage.Used/1KB
        "`$Array[$i]=" + $Array[$i].Name +"={0:N1} KB" -f $CurVal
        continue
        }
    Else
        {
        "`$Array[$i]=" + $Array[$i].SnapUsage.Used
        }
}

<#
Create a filter for Bytes/KB/MB/GB/TB/PB

Filter ConvertTo-KMG {
         <#
         .Synopsis
          Converts byte counts to Byte\KB\MB\GB\TB\PB format
         .DESCRIPTION
          Accepts an [int64] byte count, and converts to Byte\KB\MB\GB\TB\PB format
          with decimal precision of 2
         .EXAMPLE
         3000 | convertto-kmg 
         #>
    <#https://mjolinor.wordpress.com/2012/04/18/powershell-byte-count-formatting-simplified/
    $bytecount = $_
    switch ([math]::truncate([math]::log($bytecount,1024))) {
                0 {"$bytecount Bytes"}
                1 {"{0:n2}KB" -f ($bytecount / 1kb)}
                2 {"{0:n2}MB" -f ($bytecount / 1mb)}
                3 {"{0:n2}GB" -f ($bytecount / 1gb)}
                4 {"{0:n2}TB" -f ($bytecount / 1tb)}
        Default {"{0:n2}PB" -f ($bytecount / 1pb)}
        }
}

The below seperates KB/MB/GB/TB

$result = @()
foreach ($vol in $vols) {
    $ArrayItem = $Array | ?{$_.Name -eq $vol.Name}
    $result += $vol | Select `
        @{Label='Aggregate';Expression={$Aggrs.Name}},
        @{Label='Volume Name';Expression={$_.Name}},
        @{Label='Used GB';Expression={$_.SizeUsed | ConvertTo-KMG}},
        @{L='SnapUsage';Expression={$ArrayItem[0].SnapUsage.Used | ConvertTo-KMG}},
        @{Label='%Used';Expression={$_.PercentageUsed}},
        @{Label='Available';Expression={$_.SizeAvailable | ConvertTo-KMG}},
        @{Label='Total';Expression={$_.SizeTotal | ConvertTo-KMG}},
        @{L='EfficiencyPercentage';Expression={$ArrayItem[0].EfficiencyPercentage}}
}
$result | Sort 'Volume Name' | ft -AutoSize

#>




Function Get-FilerInfo($Filer)
{
#Import the Data ONTAP module.
# import-module DataOntap

#Connect to Filer.
Connect-NaController $Filer
#Connect-NaController WFWDC3FI1

<#Get aggregates from the Filer and display the result similar to this...

Retrieve NetApp aggregate info in the following format

Filer     Aggregate Name Available TB Used TB Total TB Vols Disks
-----     -------------- ------------ ------- -------- ---- -----
WFWDC3FI1 aggr0                  6.01   20.17    26.19   30    22

#>
#Get aggregates
$Aggrs = Get-NaAggr
$Aggrs | Select `
    @{Label='Filer';Expression={$_.HomeName}},`
    @{Label='Aggregate Name';Expression={$_.Name}},`
    @{Label='Available TB';Expression={[Math]::Round($Aggrs.Available/1TB,2)}},`
    @{Label='Used TB';Expression={[Math]::Round(($Aggrs.TotalSize*($Aggrs.Used/100))/1TB,2)}},`
    @{Label='Total TB';Expression={[Math]::Round($Aggrs.TotalSize/1TB,2)}},`
    @{Label='Vols';Expression={$_.VolumeCount}},`
    @{Label='Disks';Expression={$_.DiskCount}} | ft -AutoSize

<#Get volumes from the Filer and display the result similar to this...

Name                      State       TotalSize  Used  Available Dedupe  FilesUsed FilesTotal Aggregate                                                                  
----                      -----       ---------  ----  --------- ------  --------- ---------- ---------                                                                  
DC3_EXCH01_ARC1           online         1.1 TB   36%   715.3 GB  True         106        32M aggr0                                                                      

#>
#Get volumes
$vols = Get-NaVol

#Get efficiency for the volumes.
$voleff = Get-NaEfficiency 

#Clear the screen.
#Clear-Host

#Create empty result array to put the values in.
$result = @()

#Iterate through the volumes found and get results.
foreach ($vol in $vols) {
    $ArrayItem = $voleff | ?{$_.Name -eq $vol.Name}
    $result += $vol | Select `
        @{Label='Aggregate';Expression={$Aggrs.Name}},
        @{Label='Volume Name';Expression={$_.Name}},
        @{Label='Used GB';Expression={[Math]::Round($_.SizeUsed/1GB,2)}},
        @{L='SnapUsage';Expression={[Math]::Round($ArrayItem[0].SnapUsage.Used/1GB,2)}},
        @{Label='%Used';Expression={$_.PercentageUsed}},
        @{Label='Available';Expression={[Math]::Round($_.SizeAvailable/1GB,2)}},
        @{Label='Total';Expression={[Math]::Round($_.SizeTotal/1GB,2)}}
}
#Output the result
$result | Sort 'Volume Name' | ft -AutoSize

#The End.

}


#Get active interface config from Filer
$ActiveConf = Get-NaNetActiveConfig

#Get each interface on the Filer
$Ints = Get-NaNetInterface

#Set a counter variable
$counter = 1

#Create empty result array to put the values in.
$result = @()

#Cycle through each ifgrp
foreach ($Int in $Ints) 
    {
        If ($ActiveConf.Ifgrps | ?{$_.Name -eq $Int.InterFaceName} eq true)
        {
            Write-Host Found
        }
        $ArrayItem = $ActiveConf.Ifgrps | ?{$_.Name -eq $Int.InterFaceName}
        $result += $Int | Select `
        $int | select `
        @{L='Number';Expression={$counter}},
        InterFaceName,
        V4PrimaryAddress,
    $counter++
    }
$result
