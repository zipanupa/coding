$vcentername = "wfwlovc01"

$outputfile = "c:\powershell\cpucount.csv"

Connect-VIServer $vcentername
 

get-vmhost | ForEach-Object 
    { 
    if ((Get-annotation -Entity $_ -CustomAttribute "DC SPLA" | select -ExpandProperty value ) -ne "No")
        {
        New-Object -TypeName PSobject -Property
            @{
            HostName = $_.name 
            CpuCount = (Get-View $_.ID).Hardware.CpuInfo.NumCpuPackages
            } | Select-Object Parent,Hostname,CpuCount,ConnectionState,Powerstate | ft
        }

    } | export-csv -Path $outputfile 


#Disconnect-VIServer $vcentername -Confirm:$false

