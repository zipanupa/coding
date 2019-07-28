<#Connect to Filer
#Connect-NaController WFWLOFI1

#Get active interface config from Filer
$Ifgrps = Get-NaNetActiveConfig

#Create hash table
$hash = @{"Interface" = "Links"}

#for 

#Get each interface on the Filer
$Ints = Get-NaNetInterface

#Set a counter variable
$counter = 1

#Create empty result array to put the values in.
$result = @()

#Cycle through each ifgrp
foreach ($Int in $Ints) 
    {
        <#If ($ActiveConf.Ifgrps | ?{$_.Name -eq $Int.InterFaceName} eq true)
        {
            Write-Host Found
        }
        $ArrayItem = $ActiveConf.Ifgrps | ?{$_.Name -eq $Int.InterFaceName}
        #>
        <#$result += $Int | Select `
        @{L='Number';Expression={$counter}},
        InterFaceName,
        V4PrimaryAddress,
    $counter++
    }
$result
#>
#Pseudo code
#Get active config for ifgrps ($ActiveConf)
#Get all the interfaces ($Ints)
#Set a counter
#For loop
#Cycle through each interface


#we will compare the value $Ints.Interface[$int] to $ActiveConf.ifgrps.name

$Counter=1

$result = @()

foreach ($int in $ifgrps.Interfaces)
    {
    $result += $Int | Select `
    @{L='Number';Expression={$counter}},
    <#
    @{L='Interface';Expression={$Ifgrps.Interfaces[$int].Interface}}
    #>
    @{L='Phy Interface';Expression={$_.Interfaces[$int].Interface}}
    $counter++
    }


