<# 

Get the bitlocker encryption key for a computer.

#>

$computer = Get-ADComputer -Filter {Name -eq 'WFWLON-LAP5'}

$BitLockerObjects = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $computer.DistinguishedName -Properties 'msFVE-RecoveryPassword'
