#Turn off all active Controllers in the Site by resetting all service connection strings to DBUnconfigured.

$controllers = Get-BrokerController | %{$_.DNSName}
foreach ($controller in $controllers) {
Write-Host “Re-setting service DBConnection strings to a DBUnconfigured state & Turning off Controller $controller …” -ForegroundColor white -BackgroundColor DarkGreen
” “
” “
Set-HypDBConnection –DBConnection $null –AdminAddress $controller 
Set-AcctDBConnection –DBConnection $null –AdminAddress $controller 
Set-ProvDBConnection –DBConnection $null –AdminAddress $controller 
Set-EnvTestDBConnection –DBConnection $null –AdminAddress $controller 
Set-MonitorDBConnection –DBConnection $null –AdminAddress $controller 
Set-SFDBConnection –DBConnection $null –AdminAddress $controller 
Set-AnalyticsDBConnection –DBConnection $null –AdminAddress $controller 
Set-BrokerDBConnection –DBConnection $null –AdminAddress $controller 
Set-ConfigDBConnection –DBConnection $null –AdminAddress $controller 
Set-LogDBConnection –DBConnection $null –AdminAddress $controller -force
Set-AdminDBConnection –DBConnection $null –AdminAddress $controller -force
” “
” “

}
