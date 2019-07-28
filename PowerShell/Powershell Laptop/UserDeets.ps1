 $obj = Get-Aduser budv1 -Properties * | Get-Member

 foreach ($property in $obj)
 {
 if ($property.Name -like "ext*")
    {
        write $property.Name | Get-Member | where {$_.MemberType -eq "Method"}
    }
}
<#

 if ($property.Name -eq "whencreated")
    {
    write $property
    }
#>