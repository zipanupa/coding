Sub ClearAlertsFromGroups(senderName)
    Dim myNameSpace As Outlook.NameSpace
    Dim myInbox As Outlook.Folder
    Dim myDestFolder As Outlook.Folder
    Dim myItems As Outlook.Items
    Dim myItem As Object
    
    Set myNameSpace = Application.GetNamespace("MAPI")
    Set myInbox = myNameSpace.GetDefaultFolder(olFolderInbox)
    Set myItems = myInbox.Items
    Set myDestFolder = myInbox.Folders("Alerts")
    Set myItem = myItems.Find("[SenderName] = '" & senderName & "'")
    While TypeName(myItem) <> "Nothing"
        myItem.Move myDestFolder
        Set myItem = myItems.FindNext
    Wend
End Sub

Sub ClearAlerts()
    REM RunRule "No Reply"
    REM RunRule "Based on Sender"
    REM RunRule "Based on Subject"
    REM RunRule "SolarWinds"
    REM RunRule "Based on Sender Address"
    REM RunRule "unifiedmanager"
    RunRule "AD Audit Alerts 1"
    RunRule "AD Audit Alerts 2"
    RunRule "Backups NetVault Alerts 1"
    RunRule "Backups NetVault Alerts 2"
    RunRule "Backup Alerts Exchange 1"
    RunRule "Backup Alerts Exchange 2"
    RunRule "Backup Alerts Exchange 3"
    RunRule "Backup Alerts Exchange 4"
    RunRule "Backup Alerts Exchange 5"
    RunRule "Cisco Phone System Alerts 1"
    RunRule "Cisco Phone System Alerts 2"
    RunRule "Content Crawler Alerts"
    RunRule "CounterACT Alerts"
    RunRule "DPX Alerts"
    RunRule "Exchange Backup Check"
    RunRule "Exchange DB Check"
    RunRule "Exchange Health Report"
    RunRule "Firewall Alerts"
    RunRule "InterAction Alerts"
    RunRule "NETAPP Unified Manager Alerts 1"
    RunRule "NETAPP Unified Manager Alerts 2"
    RunRule "ON COMMAND Alerts"
    RunRule "Rackspace Alerts"
    RunRule "SCOM Alerts"
    RunRule "Sharefile Alerts"
    RunRule "Solarwinds Alerts"
    RunRule "SQL vCheck Alerts"
    RunRule "SSIS Alerts 1"
    RunRule "SSIS Alerts 2"
    RunRule "SSIS Alerts GroupMaker 1"
    RunRule "SSIS Alerts GroupMaker 2"
    RunRule "Talari Alerts"
    RunRule "Tintri Alerts"
    RunRule "UPS Alerts"
    RunRule "UPS Alerts Mlian"
    RunRule "Varonis Alerts 1"
    RunRule "Varonis Alerts 2"
    RunRule "Varonis Alerts 3"
    RunRule "Varonis Alerts 4"
    RunRule "vCheck Alerts"
    RunRule "Verizon Alerts"
    RunRule "VRTX Alerts"
    REM ClearAlertsFromGroups "IT Technical Services"
    REM ClearAlertsFromGroups "SSISSystemErrors"
    REM ClearAlertsFromGroups "Human Resources Worldwide"
    REM ClearAlertsFromGroups "New_User_Setup@wfw.com"
    REM ClearAlertsFromGroups "SSISSystem"
End Sub

Sub RunRule(rulename)
Dim st As Outlook.Store
Dim myRules As Outlook.Rules
Dim rl As Outlook.Rule
Dim RunRule As String

Set st = Application.Session.DefaultStore

Set myRules = st.GetRules

For Each rl In myRules

If rl.RuleType = olRuleReceive Then

If rl.Name = rulename Then
rl.Execute ShowProgress:=True
RunRule = rl.Name

End If
End If
Next

ruleList = "This rule was executed against the Inbox:" & vbCrLf & RunRule

Set rl = Nothing
Set st = Nothing
Set myRules = Nothing
End Sub
