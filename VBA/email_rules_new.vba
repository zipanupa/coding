Sub ClearAlertsFromGroups(SenderName)
    Dim myNameSpace As Outlook.NameSpace
    Dim myInbox As Outlook.Folder
    Dim myDestFolder As Outlook.Folder
    Dim myItems As Outlook.Items
    Dim myItem As Object
    
    Set myNameSpace = Application.GetNamespace("MAPI")
    Set myInbox = myNameSpace.GetDefaultFolder(olFolderInbox)
    Set myItems = myInbox.Items
    Set myDestFolder = myInbox.Folders("Other Alerts")
    Set myItem = myItems.Find("[SenderName] = '" & SenderName & "'")
    While TypeName(myItem) <> "Nothing"
        myItem.Move myDestFolder
        Set myItem = myItems.FindNext
    Wend
End Sub

Sub ClearAlerts()
'   RunRule "AD Audit Alerts 1"
'   RunRule "AD Audit Alerts 2"
'   RunRule "Backups NetVault Alerts 1"
'   RunRule "Backups NetVault Alerts 2"
'   RunRule "Backup Alerts Exchange 1"
'   RunRule "Backup Alerts Exchange 2"
'   RunRule "Backup Alerts Exchange 3"
'   RunRule "Backup Alerts Exchange 4"
'   RunRule "Backup Alerts Exchange 5"
'   RunRule "Bimco - Filing"
'   RunRule "Cisco Phone System Alerts 1"
'   RunRule "Cisco Phone System Alerts 2"
'   RunRule "Content Crawler Alerts"
'   RunRule "CounterACT Alerts"
'   RunRule "DPX Alerts"
'   RunRule "Exchange Backup Check"
'   RunRule "Exchange DB Check"
'   RunRule "Exchange Health Report"
'   RunRule "Firewall Alerts"
'   RunRule "InterAction Alerts"
'   RunRule "Leavers and Joiners Notifications"
'   RunRule "NETAPP Unified Manager Alerts 1"
'   RunRule "NETAPP Unified Manager Alerts 2"
'   RunRule "ON COMMAND Alerts"
'   RunRule "Rackspace Alerts"
'   RunRule "Riverbed Alerts"
'   RunRule "SCOM Alerts"
'   RunRule "ShareFile Alerts"
'   RunRule "Solarwinds Alerts"
'   RunRule "SQL vCheck Alerts"
'   RunRule "SSIS Alerts 1"
'   RunRule "SSIS Alerts 2"
'   RunRule "SSIS Alerts GroupMaker 1"
'   RunRule "SSIS Alerts GroupMaker 2"
'   RunRule "Talari Alerts"
'   RunRule "Tintri Alerts"
'   RunRule "UPS Alerts"
'   RunRule "UPS-ATS-PDU- Alerts - By Address (Athens, Mlian, Munich)"
'   RunRule "Varonis Alerts 1"
'   RunRule "Varonis Alerts 2"
'   RunRule "Varonis Alerts 3"
'   RunRule "Varonis Alerts 4"
'   RunRule "vCheck Alerts"
'   RunRule "Verizon Alerts"
'   RunRule "VRTX Alerts"
    ClearAlertsFromGroups "ADVFN Newsdesk"
    ClearAlertsFromGroups "Bytes Software Services"
    ClearAlertsFromGroups "Compliance Worldwide"
    ClearAlertsFromGroups "Contact Alerts"
    ClearAlertsFromGroups "DataBreachToday Enews"
    ClearAlertsFromGroups "Expedia Deal Alert"
    ClearAlertsFromGroups "Human Resources Worldwide"
    ClearAlertsFromGroups "ITPro Today"
    ClearAlertsFromGroups "IT Technical Services"
    ClearAlertsFromGroups "IT Service Desk"
    ClearAlertsFromGroups "IT V&S Team"
    ClearAlertsFromGroups "IT Worldwide"
    ClearAlertsFromGroups "MobileIron"
    ClearAlertsFromGroups "Mesh Computers"
    ClearAlertsFromGroups "musicMagpie"
    ClearAlertsFromGroups "New User Information"
    ClearAlertsFromGroups "No Reply"
    ClearAlertsFromGroups "IT V&S Team"
    ClearAlertsFromGroups "RecommindAdmin"
    ClearAlertsFromGroups "SSISSystem"
    ClearAlertsFromGroups "SSISSystemErrors"
End Sub

Sub RunRule(rulename)
'Dim variables
'Dim a default Session holder
Dim st As Outlook.Store
'Dim a Outlook rules holder
Dim myRules As Outlook.rules
'Dim an Outlook Rule holder
Dim rl As Outlook.Rule
'Dim a variable for the current rule
Dim RunThisRule As String

'Set st to a new application session/default store
Set st = Application.Session.DefaultStore
'Set myRules to the rules found in the current session
Set myRules = st.GetRules

'Loop thorugh each of the rules...
For Each rl In myRules
    'If the current rule is a receive rule then process it...
    If rl.RuleType = olRuleReceive Then
        'If the 'rulename' we called the subroutine with matches the current rule run it...
        If rl.Name = rulename Then
            '...but don't show progress...
            rl.Execute ShowProgress:=False
            'This is where we run the rule.
            RunThisRule = rl.Name
        End If
    End If
Next

'This code can be used for checking the code is working correctly - set a breakpoint here and step
RuleList = "This rule was executed against the Inbox:" & vbCrLf & RunThisRule

'We are finished processing now so tidy up variables.
RunThisRule = Nil
Set rl = Nothing
Set myRules = Nothing
Set st = Nothing
End Sub

Sub GetRules()
'Dim variables
'Dim a default Session holder
Dim st As Outlook.Store
'Dim a Outlook rules holder
Dim myRules As Outlook.rules
'Dim an Outlook Rule holder
Dim rl As Outlook.Rule

'Set-up
'Set-up Session
Set st = Application.Session.DefaultStore
'Get rules
Set myRules = st.GetRules

'Loop through rules
For Each rl In myRules
    'Add found rules to RuleResults form Listbox1
    RuleResults.ListBox1.AddItem (rl.Name)
Next

'Display results in custom form
RuleResults.Show

'We are finished processing now so tidy up variables.
Set rl = Nothing
Set myRules = Nothing
Set st = Nothing
End Sub

Sub NotUsed()
'For i = 0 To counter
'    LongString = LongString + rules(i) + vbCrLf
'Next i
'MsgBox LongString, vbOKOnly, "Rules"
'RuleResults.TextBox1.Text = (LongString)
End Sub