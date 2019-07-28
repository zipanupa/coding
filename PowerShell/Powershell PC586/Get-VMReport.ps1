param (
    [parameter( ValueFromPipeline = $True)]
    [alias("InputObject", "VirtualMachine")]
    [VMware.VimAutomation.Client30.VirtualMachineImpl[]]$VM
    )

process {
    $VM | ForEach-Object {
        $vmview = $_ | Get-View
        $snapshot = $_ | Get-Snapshot
        $network = $_ | Get-NetworkAdapter
        $VMProp = @{
            Name = $_.Name
            Memory = $_.Memory
            #DisksGB = ($_.HardDisks | Measure-Object -Sum CapacityGB)
            }
        New-Object PSObject -Property $VMProp
        }
    }