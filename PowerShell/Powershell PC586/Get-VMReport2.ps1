param (
    [parameter(ValueFromPipeline = $true )]
    [alias("InputObject", "VirtualMachine")]
    [VMware.VimAutomation.Client20.VirtualMachineImpl[]]$VM
    )

process {
        
        #$VM | 
        ForEach-Object {
        $vmcluster = $_ | Get-Cluster
        $vmhost = $_ | Get-VMHost
        $vmview = $_ | Get-View
        #$snapshot = $_ | Get-Snapshot
        $VMProp = @{
            Cluster       = $vmcluster.Name
            Host          = $vmhost.Name
            HostProcTotal = $vmhost.ExtensionData.Hardware.CpuInfo.NumCpuPackages
            HostCoreTotal = $vmhost.ExtensionData.Hardware.CpuInfo.NumCpuCores
            HostMhzTotal  = [math]::round($vmhost.ExtensionData.Hardware.CpuInfo.Hz / 1000000, 0)
            HostMemTotal  = [math]::round($vmhost.ExtensionData.Hardware.MemorySize / 1GB)
            Power         = $_.PowerState
            Name          = $_.Name
            OSName        = $vmview.Config.GuestFullName
            MemoryGB      = $_.MemoryGB
            NumCPU        = $_.NumCpu
            NumDisks      = $_.HardDisks.Count
            DisksGB       = ( $_.HardDisks | Measure-Object -Sum CapacityGB).Sum
            HostNumCPU    = $vmhost.NumCpu
            HostProcCoreMhz   = “PROC:“ + $vmhost.ExtensionData.Hardware.CpuInfo.NumCpuPackages + “ CORES:“ + $vmhost.ExtensionData.Hardware.CpuInfo.NumCpuCores + “ MHZ: “ + [math]::round($vmhost.ExtensionData.Hardware.CpuInfo.Hz / 1000000, 0)
            HostMemUsage  = [math]::round(($vmhost | Measure-Object -property MemoryUsageGB -Sum).sum)
            #HostMemTotal  = [math]::round(($vmhost | Measure-Object -property MemoryTotalGB -Sum).sum)
        }
        New-Object PSObject -Property $VMProp
    }
}

<#
Example1 of how to use the code above for a 'Global' report.


# Setup array with hosts 
$hosts = @( 
    "wfwdc1vcha01", 
    "wfwdc2vcha01", 
    "wfwdc3vcha01" 
);

# Connect to the vCenter Servers required.
Connect-VIServer -Server $hosts -User wfw\adm_mccm1

#Run report - takes a while...
$Report = Get-VM | C:\powershell\Get-VMReport2.ps1 | Sort-Object Cluster,Host,Name | select Cluster, Host, HostProcTotal, HostCoreTotal, HostMhzTotal, HostMemTotal, Name, OSName, Power, MemoryGB, NumCPU, NumDisks, DisksGB

#Export results to a .CSV
$Report | select Cluster, Host, HostProcTotal, HostCoreTotal, HostMhzTotal, HostMemTotal, Name, OSName, Power, MemoryGB, NumCPU, NumDisks, DisksGB  | export-Csv -Path C:\Powershell\Export-VMInfo.csv -NoTypeInformation

#Example2 of how to use the code above for a 'Rome Office' report.

#Run report - takes a while...
$Report = Get-Cluster "Rome Cluster" | Get-VM | .\Get-VMReport2.ps1 | Sort-Object Cluster,Host,Name | select Cluster, Host, HostProcTotal, HostCoreTotal, HostMhzTotal, HostMemTotal, Name, OSName, Power, MemoryGB, NumCPU, NumDisks, DisksGB | Format-Table -GroupBy Cluster -AutoSize

#Export results to a .CSV
$Report | select Cluster, Host, HostProcTotal, HostCoreTotal, HostMhzTotal, HostMemTotal, Name, OSName, Power, MemoryGB, NumCPU, NumDisks, DisksGB  | export-Csv -Path C:\Powershell\Export-VMInfo.csv -NoTypeInformation

where name -like "WFWROONTAPV0*"

<#Old Code Examples

Get-Cluster "DC3 VDI Cluster" | Select @{N=“Cluster“;E={Get-Cluster -VMHost $_}}, Name, @{N=“NumVM“;E={($_ | Get-VM).Count}} | Sort Cluster, Name | Export-Csv -NoTypeInformation c:\powershell\clu-host-numvm.csv

Get-VMHost |Sort Name |Get-View |
Select Name, 
@{N=“Type“;E={$_.Hardware.SystemInfo.Vendor+ “ “ + $_.Hardware.SystemInfo.Model}},
@{N=“CPU“;E={“PROC:“ + $_.Hardware.CpuInfo.NumCpuPackages + “ CORES:“ + $_.Hardware.CpuInfo.NumCpuCores + “ MHZ: “ + [math]::round($_.Hardware.CpuInfo.Hz / 1000000, 0)}},
@{N=“MEM“;E={“” + [math]::round($_.Hardware.MemorySize / 1GB, 0) + “ GB“}}

Get-VM |Where {$_.PowerState -eq “PoweredOn“} | Select Host, Name, NumCPU, @{N=“OSHAL“;E={(Get-WmiObject -ComputerName $_.Name-Query “SELECT * FROM Win32_PnPEntity where ClassGuid = ‘{4D36E966-E325-11CE-BFC1-08002BE10318}’“ |Select Name).Name}}, @{N=“OperatingSystem“;E={(Get-WmiObject -ComputerName $_ -Class Win32_OperatingSystem |Select Caption).Caption}}, @{N=“ServicePack“;E={(Get-WmiObject -ComputerName $_ -Class Win32_OperatingSystem |Select CSDVersion).CSDVersion}} | ft -autosize

Get-DataCenter "DC1 DataCenter" | Get-VM |Where {$_.PowerState -eq “PoweredOn“} | Sort Name | Select Name, NumCPU, @{N=“OperatingSystem“;E={(Get-WmiObject -ComputerName $_ -Class Win32_OperatingSystem |Select Caption).Caption}}, @{N=“ServicePack“;E={(Get-WmiObject -ComputerName $_ -Class Win32_OperatingSystem |Select CSDVersion).CSDVersion}} | ft -autosize

#>
