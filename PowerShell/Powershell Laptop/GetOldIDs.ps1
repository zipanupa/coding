Import-csv c:\powershell\book1.csv | ForEach-Object {
    $id = $_.employeeID
    try {
            get-aduser -identity $id | select-object Name
        }
    Catch
        {
            write "Name no longer in AD - Deleted user"
        }
}