﻿    Function Get-SQLSvrVer {
<#
    .SYNOPSIS
        Checks remote registry for SQL Server Edition and Version.
    .DESCRIPTION
        Checks remote registry for SQL Server Edition and Version.

    .PARAMETER  ComputerName
        The remote computer your boss is asking about.

    .EXAMPLE
        PS C:\> Get-SQLSvrVer -ComputerName mymssqlsvr 

    .EXAMPLE
        PS C:\> $list = cat .\sqlsvrs.txt
        PS C:\> $list | % { Get-SQLSvrVer $_ | select ServerName,Edition }

    .INPUTS
        System.String,System.Int32

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .NOTES
        Only sissies need notes...

    .LINK
        about_functions_advanced

#>
[CmdletBinding()]
param(
    # a computer name
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $ComputerName
)

# Test to see if the remote is up
if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
    $SqlVer = New-Object PSObject
    $SqlVer | Add-Member -MemberType NoteProperty -Name ServerName -Value $ComputerName
    $base = "SOFTWARE\"
    $key = "$($base)\Microsoft\Microsoft SQL Server\Instance Names\SQL"
    $type = [Microsoft.Win32.RegistryHive]::LocalMachine
    $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($type, $ComputerName)
    $SqlKey = $regKey.OpenSubKey($key)
    try {
        $SQLKey.GetValueNames()
    } catch { # if this failed, it's wrong node
        $base = "SOFTWARE\WOW6432Node\"
        $key = "$($base)\Microsoft\Microsoft SQL Server\Instance Names\SQL"
        $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($type, $ComputerName)
        $SqlKey = $regKey.OpenSubKey($key)
    }

        # parse each value in the reg_multi InstalledInstances 
        Foreach($instance in $SqlKey.GetValueNames()){
        $instName = $SqlKey.GetValue("$instance") # read the instance name
        $instKey = $regKey.OpenSubkey("$($base)\Microsoft\Microsoft SQL Server\$instName\Setup") # sub in instance name
        # add stuff to the psobj
        $SqlVer | Add-Member -MemberType NoteProperty -Name Edition -Value $instKey.GetValue("Edition") -Force # read Ed value
        $SqlVer | Add-Member -MemberType NoteProperty -Name Version -Value $instKey.GetValue("Version") -Force # read Ver value
        # return an object, useful for many things
        $SqlVer
    }
} else { Write-Host "Server $ComputerName unavailable..." } # if the connection test fails
}