#Turn on all Controllers in the Site by setting the DBConnection strings for all service instances.

$controllers = “WFWDC1XD01.WFW.COM”
foreach ($controller in $controllers) {
Write-Host “Re-setting service DBConnection strings to a Configured state & Turning on Controller $controller …” -ForegroundColor white -BackgroundColor DarkGreen
” “
” “
Set-AdminDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security =True” –AdminAddress $controller 
Set-LogDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-BrokerDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security =True” –AdminAddress $controller 
Set-ConfigDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-HypDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-AcctDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-ProvDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-EnvTestDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security =True” –AdminAddress $controller 
Set-MonitorDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-SfDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
Set-AnalyticsDBConnection -DBConnection “Server=WFWDC1XD01\SQLEXPRESS;Initial Catalog = DC1_Citrix; Integrated Security = True” –AdminAddress $controller 
” “
” “

}
