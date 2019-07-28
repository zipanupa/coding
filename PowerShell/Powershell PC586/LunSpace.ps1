# Quick and Dirty Script to Determine the Oversubscription rate of Thinly provisioned LUNs

# on a Target Filer.


[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$Filer
)


$pass = ConvertTo-SecureString $password -AsPlainText -Force

$admin = "root"

$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $admin,$pass


Connect-naController $Filer -credential $cred

$aggrlist = Get-NAAggr

Foreach ($aggr in $aggrlist){

      [double]$AggrOverSub=1

      Write-Host "Aggr Start      - " $aggr.Name -NoNewline

      Write-host " : Aggr Size = " ([Math]::Round($aggr.SizeTotal/(1024*1024*1024),1))"GB" -nonewline

      Write-host " : Used Size = " ([Math]::Round($aggr.SizeUsed/(1024*1024*1024),1))​"GB" -nonewline

      Write-host " : % used = " $aggr.SizePercentageUsed"%"

      $LunList = Get-NaLun

      $Vollist = Get-NaVol

      ForEach ($volume in $Vollist)

      {     [double]$VolOverSub=1

            $vol = (get-navol $volume.name)

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

                        {     [single]$perc=100 * ([single]((get-nalunoccupiedsize $LUN.path)) /[single]($LUN.Size))

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
