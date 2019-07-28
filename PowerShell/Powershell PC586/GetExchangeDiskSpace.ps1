<# 
.Synopsis 
   Get-ExchangeDiskSpace.ps1 - Gathers LUN Diskspace from each mailbox server 
.DESCRIPTION 
   Queries for all Exchange mailbox servers - parses disks to locate LUNs and gathers stats. Exports to report and sends email. 
.EXAMPLE 
   .\Get-ExchangeDiskSpace.ps1 -ReportMode -SendEmail 
        Checks all servers in the organization, outputs the results to an HTML report and 
        emails the HTML report to the address configured in the script. 
.PARAMETER ReportMode 
    Set to $true to generate a HTML report. A default file name is used if none is specified. 
.PARAMETER SendEmail 
    Sends the HTML report via email using the SMTP configuration within the script. 
.NOTES 
    Written by Jeremy Corbello 
    V1.0 - 6/7/17 
    V1.01 - 6/26/17 - Added removal of existing backup report before creating new backup. 
#> 
 
[CmdletBinding()] 
param (   
        [Parameter( Mandatory=$false)] 
        [switch]$ReportMode, 
         
        [Parameter( Mandatory=$false)] 
        [switch]$SendEmail 
    ) 
     
#Add Exchange snapin if not already loaded in the PowerShell session 
if (Test-Path $env:ExchangeInstallPath\bin\RemoteExchange.ps1) 
{ 
    if (-not (Get-PSSession).ConfigurationName -eq "Microsoft.Exchange") { 
        . $env:ExchangeInstallPath\bin\RemoteExchange.ps1 
        Connect-ExchangeServer -auto -AllowClobber 
        Write-Host "Established Remote Exchange Session" 
    } else { 
        Write-Host "Exchange Session Already Established" 
    } 
} 
else 
{ 
    Write-Warning "Exchange Server management tools are not installed on this computer." 
    EXIT 
} 
 
 
#Declaring output variables 
$now = Get-Date 
$date = $now.ToShortDateString()     
$titleDate = get-date -uformat "%m-%d-%Y - %A" 
$outPath = "C:\powershell\Exchange_DiskSpace.htm" 
$backupPath = "C:\powershell\Exchange_DiskSpace_Backup.htm" 
$reportemailsubject = "Exchange Diskspace Report - $date" 
 
#SMTP Settings 
$smtpsettings = @{ 
    To =  "mmccullough@wfw.com" 
    From = "Exchange Disk Report@wfw.com" 
    Subject = "$reportemailsubject" 
    SmtpServer = "dc1smtp.wfw.com" 
    } 
 
#Backup of Previous Log file, Removal of last backup 
if (Test-Path $outPath) { 
    if (Test-Path $backupPath) { 
        Remove-Item -Path $backupPath -Force 
        } 
    Move-Item -Path $outPath -Destination $backupPath -Force  
    } 
     
#Gathering Data
#$exchangeServers = Get-ExchangeServer | Where-Object {$_.ServerRole -contains "Mailbox, ClientAccess, HubTransport"} | sort name 
#$exchangeServers = @{}
$LUNSize = @{}
$RESULTS = "" 
$dags = Get-DatabaseAvailabilityGroup | Sort-Object Name #| where {$_.Name -eq "DC1"}
foreach ($dag in $dags) {
    foreach ($server in $dag.Servers) { 
        $LUNSize.$($server.name) = Get-WmiObject -ComputerName $server win32_volume -Filter "DriveType='3'" | Where-Object {$_.Label -like "DC*" -OR $_.name -like "*DC*"} | foreach { 
            New-Object PSObject -Property @{ 
                FreeSpace_GB = ([MATH]::Round($_.FreeSpace / 1GB)) 
                TotalSize_GB = ([MATH]::Round($_.Capacity / 1GB)) 
                PercentFree = ([MATH]::Round(($_.FreeSpace/$_.Capacity)*100)) 
                DAG = $dag
                Name = $server.Name 
                LUN = $_.Label 
                }  
            }
            iF (!$results) {
            $RESULTS = @{}
            $RESULTS = @($LUNSize.$($server.name) | Sort-Object PercentFree | Select DAG, Name, LUN, PercentFree, FreeSpace_GB, TotalSize_GB)
            #$RESULTS | Out-Host 
            }
            else {
            $RESULTS += @($LUNSize.$($server.name) | Sort-Object PercentFree | Select DAG, Name, LUN, PercentFree, FreeSpace_GB, TotalSize_GB)
            #$RESULTS | Out-Host 
            }
        } 

}
 
    #Writing output to console 
    $RESULTS | Sort-Object DAG,Name, PercentFree | Select DAG, Name, LUN, PercentFree, FreeSpace_GB, TotalSize_GB | ft -AutoSize | Out-Host 
         
    if ($ReportMode -or $SendEmail) { 
        $header = " 
                <html> 
                <head> 
                <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
                <title>DiskSpace Report</title> 
                <STYLE TYPE='text/css'> 
                <!-- 
                    table { 
                            border: thin solid #666666; 
                            margin-left: auto;  
                            margin-right: auto; 
                    } 
                td { 
                    font-family: Tahoma; 
                    font-size: 13px; 
                    border-top: 1px solid #999999; 
                    border-right: 1px solid #999999; 
                    border-bottom: 1px solid #999999; 
                    border-left: 1px solid #999999; 
                    padding-top: 0px; 
                    padding-right: 2px; 
                    padding-bottom: 0px; 
                    padding-left: 2px; 
                } 
                body { 
                    margin-top: 5px; 
                    margin-bottom: 10px; 
                    margin-left: auto;  
                    margin-right: auto; 
                    table { 
                        border: thin solid #000000; 
                    } 
                --> 
                </style> 
                </head> 
                <body> 
                <table width='100%'> 
                <tr bgcolor='#CCCCCC'> 
                <td colspan='7' height='25' align='center'> 
                    <font face='tahoma' color='#003399' size='4'><strong>DiskSpace Report for $titledate</strong></font> 
                </td> 
                </tr> 
                </table> 
        " 
        $htmltail = "</body> 
                    </html>" 
        if ($ReportMode) { 
            $header | Out-File $outPath 
        } 
        foreach ($RESULT in $RESULTS) { 
            $htmlbody += [PSCustomObject] $RESULTS | ConvertTo-Html -Fragment -Property Name,LUN,FreeSpace_TB,TotalSize_TB,PercentFree 
            if ($ReportMode) { 
                [PSCustomObject] $RESULT | ConvertTo-Html -Fragment -Property Name,LUN,FreeSpace_TB,TotalSize_TB,PercentFree | Out-File $outPath -Append  
                $htmltail | Out-File $outPath -Append 
            } 
        } 
        $htmlreport = $header + $htmlbody + $htmltail 
 
        if ($SendEmail) { 
            $htmlreport = $header + $htmlbody + $htmltail 
            Send-MailMessage @smtpsettings -Body $htmlreport -BodyAsHtml -Encoding ([System.Text.Encoding]::UTF8) 
        } 
}
