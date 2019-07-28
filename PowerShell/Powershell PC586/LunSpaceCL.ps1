# Quick and Dirty Script to Determine the Oversubscription rate of Thinly provisioned LUNs

# on a Target Filer.

#Get stats for LUNs (from 10th Aug 2016)
DC1
Connect-NcController DC1_CLU1 -Vserver NEWWFWDC1FI1 -Credential admin
Get-NcVol | Sort-Object {$_.Used} -descending | Where-Object {$_.Used -gt 85}
Get-Nclun

DC2
Connect-NcController DC2_CLU1 -Vserver NEWWFWDC2FI1 -Credential admin
Get-NcVol | Sort-Object {$_.Used} -descending | Where-Object {$_.Used -gt 85}
Get-Nclun

DC3
Connect-NcController DC3_CLU1 -Vserver NEWWFWDC3FI1 -Credential admin
Get-NcVol | Sort-Object {$_.Used} -descending | Where-Object {$_.Used -gt 85}
Get-Nclun


[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$Filer
)

<#
$pass = ConvertTo-SecureString "pass" -AsPlainText -Force
$admin = "root"
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $admin,$pass
#>

Connect-NcController London_CLU2 -Vserver NEWWFWLOFI2 -Credential admin

$aggrlist = Get-NCAggr

Foreach ($aggr in $aggrlist){

      [double]$AggrOverSub=1

      Write-Host "Aggr Start      - " $aggr.Name -NoNewline

      Write-host " : Aggr Size = " ([Math]::Round($aggr.SizeTotal/(1024*1024*1024),1))"GB" -nonewline

      Write-host " : Used Size = " ([Math]::Round($aggr.SizeUsed/(1024*1024*1024),1))​"GB" -nonewline

      Write-host " : % used = " $aggr.SizePercentageUsed"%"

      $LunList = Get-NCLun

      $Vollist = Get-NCVol

      ForEach ($volume in $Vollist)

      {     [double]$VolOverSub=1

            $vol = (get-ncvol $volume.name)

            [single]$perc=100 * ([single]($vol.SizeUsed) /[single]($vol.SizeTotal))

            $perc=[math]::Round($perc,2)

            if ($aggr.name -eq $vol.containingaggregate)
            {     
            
            Write-Host "      Vol Start - " $vol.Name -NoNewline

                  Write-host " : Vol Size = " ([math]::round($volume.SizeTotal/(1024*1024*1024),1))"GB" -nonewline

                  Write-host " : Used Size = " $Perc "%"

                  Foreach ($LUN in $LunList)

                  {     $Sour=$LUN.Path

                        if ($Sour.Contains($vol.name))

                        {     [single]$perc=100 * ([single]((get-nclunoccupiedsize $LUN.path)) /[single]($LUN.Size))

                              $perc=[math]::Round($perc,2)

                              Write-Host "          LUN   = " $LUN.path -NoNewline

                              Write-Host " : Size = " ([Math]::Round(($LUN.size/(1024*1024*1024)),1))"GB​" -NoNewline

                              Write-Host " : Used = " ([Math]::Round( ((get-nalunoccupiedsize $LUN.path)/(1024*1024*1024)),1))"GB" -NoNewline

                              Write-Host " = " $perc"%"

                              $VolOverSub=$VolOverSub+[double]$LUN.Size

                        }

                  }

                  Write-Host "      Vol End   - " $vol.Name -NoNewline

                  Write-Host " : Vol Subscribed = " ([Math]::Round(($VolOverSub/(1024*1024*1024)),1))"​GB"  -NoNewline

                  Write-Host " OverSubscribed Ratio = " ([Math]::Round(($VolOverSub/$Vol.SizeTotal),1))":1​"

                  $AggrOverSub=$AggrOverSub+$VolOverSub

            }

      }    

      Write-Host "Aggr End        - " $aggr.Name -NoNewline

      Write-host " : SubScribed = " ([Math]::Round(($AggrOverSub/(1024*1024*1024)),1))​"GB" -NoNewline

      Write-host " OverSubscribed Ratio = " ([Math]::Round(($AggrOverSub/$aggr.SizeTotal),1))"​:1"

}    
