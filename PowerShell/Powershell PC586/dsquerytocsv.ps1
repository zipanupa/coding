# First run dsquery and set the results in a string
$userlist = dsquery * "DC=wfw,DC=Com" -filter objectCategory=Person -scope subtree -attr sAMAccountName distinguishedName -limit 2000
# Create a blank object which export-csv will use
$psObject = $null
$psObject = New-Object psobject
# Cycle through the string
foreach ($user in $userList) {
    $outstring=$user.trim(" ") -replace('\s+',',') 
    Add-Member -InputObject $psObject -MemberType NoteProperty -Name $outstring -Value $outstring
    $psObject.sAMAccountName,distinguishedName | Export-Csv -Append -Path C:\mark.csv -NoTypeInformation
}

# $outstring | Export-Csv C:\mark.txt -NoTypeInformat
