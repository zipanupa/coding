Private Sub OutputToFile_Click()
    'Dim variables
    Dim FileName As String
    Dim SuggestFileName As String
    
    'Set-up
    'Set-up default file name
    SuggestFileName = "OutlookRules.txt"
    'Ask user for a file name
    FileName = InputBox("Enter File Name: ", "Please enter a file name", SuggestFileName)
    'If user enters something, use that as the filename
    If FileName = "" Then FileName = SuggestFileName
    'Run subroutine to write the file
    WriteFile (FileName)
    
    'Tidy up.
    SuggestFileName = ""
    FileName = ""
    
    End Sub
    
    Private Sub RuleResultsOK_Click()
    'Close the RuleResults window!
    Unload Me
    'Tidy up.
    
    End Sub
    
    Sub WriteFile(FileName)
    'Dim variables
    Dim WshShell As Object
    Dim DocPath As String
    Dim FileToWrite As String
    
    'Set-up
    'Set-up WScript Shell Object
    Set WshShell = CreateObject("WScript.Shell")
    'Find the path to 'My Documents'
    DocPath = WshShell.SpecialFolders("MyDocuments")
    'Append the path and filename together
    FileToWrite = DocPath + "\" + FileName
    
    'Main routine
    'A bit of error handing
    On Error Resume Next
    'Delete old copy of the file
    Kill FileToWrite
    'On error leave
    On Error GoTo 0
    'Open The File
    Open FileToWrite For Output As #1
    'Write out the items in the RuleResults listbox to the file
    'Set last item
    LastItem = RuleResults.ListBox1.ListCount - 1
    'For each item...
    For Item = 0 To LastItem
        'Write a line in the file...
        Print #1, "'   RunRule """ + RuleResults.ListBox1.List(Item) + """"
    Next
    'Close the file
    Close #1
    
    'Tidy up
    Item = ""
    LastItem = ""
    FileToWrite = ""
    DocPath = ""
    Set WshShell = Nothing
    FileName = ""
    End Sub    