Function Ping-Subnet {
    [cmdletbinding()]
    Param(
        [string]$subnet = "172.22.117.",
        [int]$Start = 1,
        [int]$end = 254
    )

    $Start..$end | where {Test-Connection -ComputerName "$Subnet$_" -Count 1 -Quiet} |
    foreach {"$Subnet$_"}
    
} # End Ping-Subnet