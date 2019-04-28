Sub SetDesc()
' Author MMC
' Date 25/02/2018
' This Macro will give the description of the machine to the left
' based on the value of the cell and figuring out what type of machine
' it is.
    
    Range("J8").Select
    Do While ActiveCell.Offset(0, -1) <> ""
        TestVal = ActiveCell.Offset(0, -1)
        Select Case True
            Case InStr(TestVal, "-CLU")
                ActiveCell.Value = "NetApp ONTAP EDGE Server"
            Case InStr(TestVal, "-Node")
                ActiveCell.Value = "NetApp ONTAP Select Server"
            Case InStr(TestVal, "_WFWLON-PC")
                ActiveCell.Value = "IT Staff VMs (not server)"
            Case InStr(TestVal, "A365")
                ActiveCell.Value = "Anywhere 365 Server"
            Case InStr(TestVal, "Aerohive")
                ActiveCell.Value = "Aerohive VPN Appliance"
            Case InStr(TestVal, "APP0")
                ActiveCell.Value = "Application / SCCM Server"
            Case InStr(TestVal, "AUDIT")
                ActiveCell.Value = "ManageEngine AD Audit Server"
            Case InStr(TestVal, "BES") Or InStr(TestVal, "BB")
                ActiveCell.Value = "Blackberry Enterprise Server"
            Case InStr(TestVal, "BH") Or InStr(TestVal, "BHG")
                ActiveCell.Value = "Big Hand Server"
            Case InStr(TestVal, "CMSAPI") Or InStr(TestVal, "CMSFWK") Or InStr(TestVal, "CMSTEST") Or InStr(TestVal, "DC1XDCMSAC01")
                ActiveCell.Value = "CMS API/Framework/Test Servers"
            Case InStr(TestVal, "CMS")
                ActiveCell.Value = "SQL Server"
            Case InStr(TestVal, "CCOCR01")
                ActiveCell.Value = "Content Crawler OCR Server"
            Case InStr(TestVal, "CLUOCM")
                ActiveCell.Value = "NetApp Monitoring Server"
            Case InStr(TestVal, "CONFBK")
                ActiveCell.Value = "Condeco Booking Server"
            Case InStr(TestVal, "DA0") Or InStr(TestVal, "DIR0") Or InStr(TestVal, "DIRECT")
                ActiveCell.Value = "Direct Access Server"
            Case InStr(TestVal, "DDC0")
                ActiveCell.Value = "Citrix DDC Server"
            Case InStr(TestVal, "DC0")
                ActiveCell.Value = "Domain Controller"
            Case InStr(TestVal, "DC1DM") Or InStr(TestVal, "DC2DM") Or InStr(TestVal, "DC3DM") Or InStr(TestVal, "BADM") Or InStr(TestVal, "NYDM") Or InStr(TestVal, "SIDM")
                ActiveCell.Value = "iManage DM Server"
            Case InStr(TestVal, "DC1SCSM") Or InStr(TestVal, "DC1SCOM") Or InStr(TestVal, "DC1SCORCH") Or InStr(TestVal, "DC1SCSH01")
                ActiveCell.Value = "SCSM/SCOM Server"
            Case InStr(TestVal, "DC1SOLARW")
                ActiveCell.Value = "SolarWinds Server"
            Case InStr(TestVal, "DC1TPD")
                ActiveCell.Value = "Top Desk Server"
            Case InStr(TestVal, "DD")
                ActiveCell.Value = "Digital Dictation Server"
            Case InStr(TestVal, "DHCP")
                ActiveCell.Value = "DHCP Client INET Server"
            Case InStr(TestVal, "DPX")
                ActiveCell.Value = "DPX Backup Server"
            Case InStr(TestVal, "DC1QU")
                ActiveCell.Value = "Quest Notes/Exchange Mail Server"
            Case InStr(TestVal, "DC1SH0") Or InStr(TestVal, "DC1SH1") Or InStr(TestVal, "DC2SH0") Or InStr(TestVal, "DC2SH1") Or InStr(TestVal, "DC3SH0") Or InStr(TestVal, "DC3SH1") Or InStr(TestVal, "SHMASTER")
                ActiveCell.Value = "Citrix W2012/Session Host"
            Case InStr(TestVal, "DC1XD") Or InStr(TestVal, "DC2XD") Or InStr(TestVal, "DC3XD")
                ActiveCell.Value = "Citrix W81/Desktop Host"
            Case InStr(TestVal, "DC2SP")
                ActiveCell.Value = "SharePoint Server"
            Case InStr(TestVal, "ECOPY")
                ActiveCell.Value = "ECOPY Server"
            Case InStr(TestVal, "EDGE") Or InStr(TestVal, "LYNC")
                ActiveCell.Value = "Skype for Business Server"
            Case InStr(TestVal, "EPM01")
                ActiveCell.Value = "CheckPoint EndPoint Server"
            Case InStr(TestVal, "EXCH")
                ActiveCell.Value = "Exchange Server"
            Case InStr(TestVal, "FW0") Or InStr(TestVal, "LOFW")
                ActiveCell.Value = "Firewall Server"
            Case InStr(TestVal, "FS1") Or InStr(TestVal, "FS01")
                ActiveCell.Value = "Windows File Server (Profiles)"
            Case InStr(TestVal, "GIT01")
                ActiveCell.Value = "GitLab Server"
            Case InStr(TestVal, "HS01") Or InStr(TestVal, "HSUAT")
                ActiveCell.Value = "Handshake Extraction Server"
            Case InStr(TestVal, "HR01") Or InStr(TestVal, "HR02")
                ActiveCell.Value = "Cascade HR Server"
            Case InStr(TestVal, "IDOL")
                ActiveCell.Value = "iManage IDOL Indexer Server"
            Case InStr(TestVal, "1INT")
                ActiveCell.Value = "Intapp Server"
            Case InStr(TestVal, "IPFX")
                ActiveCell.Value = "Cisco IPFX Server"
            Case InStr(TestVal, "KEMP")
                ActiveCell.Value = "Kemp Load Balancer"
            Case InStr(TestVal, "LOCA") Or InStr(TestVal, "DC1CA")
                ActiveCell.Value = "Certificate Authority Server"
            Case InStr(TestVal, "LOIA")
                ActiveCell.Value = "InterAction Server"
            Case InStr(TestVal, "LOCM1")
                ActiveCell.Value = "Commonstore Server"
            Case InStr(TestVal, "LONS") Or InStr(TestVal, "DC1NS") Or InStr(TestVal, "DC2NS") Or InStr(TestVal, "DC3NS")
                ActiveCell.Value = "Lotus Domino Server"
            Case InStr(TestVal, "LONS") Or InStr(TestVal, "DC1NS") Or InStr(TestVal, "DC2NS") Or InStr(TestVal, "DC3NS")
                ActiveCell.Value = "Lotus Domino Server"
            Case InStr(TestVal, "LOTTMS")
                ActiveCell.Value = "TMS Server"
            Case InStr(TestVal, "LOVC01") Or InStr(TestVal, "LOVSS0")
                ActiveCell.Value = "Old VMware vSphere/View Server"
            Case InStr(TestVal, "MISEN")
                ActiveCell.Value = "MobileIron Sentry"
            Case InStr(TestVal, "NAG01")
                ActiveCell.Value = "Nagios Server"
            Case InStr(TestVal, "NETS0")
                ActiveCell.Value = "NetScaler Server"
            Case InStr(TestVal, "ONTAPV")
                ActiveCell.Value = "NetApp ONTAP-V Server"
            Case InStr(TestVal, "OOS0")
                ActiveCell.Value = "Office Online Server"
            Case InStr(TestVal, "OWA")
                ActiveCell.Value = "OWA Server"
            Case InStr(TestVal, "PACTSIEM")
                ActiveCell.Value = "PROACT SIEMaaS Server"
            Case InStr(TestVal, "PIPE")
                ActiveCell.Value = "RAVN Pipeline Server"
            Case InStr(TestVal, "PRX")
                ActiveCell.Value = "WebMarshal Server"
            Case InStr(TestVal, "PSC")
                ActiveCell.Value = "vSphere Program Services Controller"
            Case InStr(TestVal, "PVS")
                ActiveCell.Value = "Citrix PVS Server"
            Case InStr(TestVal, "PH")
                ActiveCell.Value = "Cisco Voice Server"
            Case InStr(TestVal, "RAVN01")
                ActiveCell.Value = "RAVN Server"
            Case InStr(TestVal, "RAVNSP")
                ActiveCell.Value = "RAVN SharePoint Server"
            Case InStr(TestVal, "RECOMM")
                ActiveCell.Value = "Recommind Server"
            Case InStr(TestVal, "RD0")
                ActiveCell.Value = "Remote Desktop Server"
            Case InStr(TestVal, "SCCM0")
                ActiveCell.Value = "SCCM Server"
            Case InStr(TestVal, "SF0") Or InStr(TestVal, "SHARF")
                ActiveCell.Value = "ShareFile Server"
            Case InStr(TestVal, "SME0")
                ActiveCell.Value = "SnapManager For Exch Server"
            Case InStr(TestVal, "SPBS")
                ActiveCell.Value = "SharePoint Web Apps Server"
            Case InStr(TestVal, "SQ") Or InStr(TestVal, "SQL")
                ActiveCell.Value = "SQL Server"
            Case InStr(TestVal, "UAG")
                ActiveCell.Value = "UAG Server"
            Case InStr(TestVal, "USX")
                ActiveCell.Value = "Atlantis USX Server"
            Case InStr(TestVal, "TINTRI")
                ActiveCell.Value = "TinTri Global Catalog Server"
            Case InStr(TestVal, "TRENDM")
                ActiveCell.Value = "Trend Micro AV Server"
            Case InStr(TestVal, "VCHA")
                ActiveCell.Value = "vSphere 6.5 Server"
            Case InStr(TestVal, "VCTEST01")
                ActiveCell.Value = "vSphere 5.5 Server for View"
            Case InStr(TestVal, "VPN")
                ActiveCell.Value = "Microsoft VPN Server"
            Case InStr(TestVal, "VRNS")
                ActiveCell.Value = "Varonis Server"
            Case InStr(TestVal, "VSP0")
                ActiveCell.Value = "MobileIron VSP Server"
            Case InStr(TestVal, "WEB")
                ActiveCell.Value = "IIS Web Server"
            Case InStr(TestVal, "WFWDC1CC01")
                ActiveCell.Value = "SafeNet MobilePASS 2FA Server"
            Case InStr(TestVal, "WFWGRPS01") Or InStr(TestVal, "WFWLOPS01") Or InStr(TestVal, "WFWMAPS01") Or InStr(TestVal, "WFWHKPS01") Or InStr(TestVal, "WFWPAPS01")
                ActiveCell.Value = "Print Server"
            Case InStr(TestVal, "WFWNY-VW") Or InStr(TestVal, "WFWLON-VW")
                ActiveCell.Value = "View Desktop"
            Case InStr(TestVal, "WFWNYVIEW") Or InStr(TestVal, "WFWLOVIEW") Or InStr(TestVal, "WFWLOVIEWTEST01") Or InStr(TestVal, "WFWLOVV1")
                ActiveCell.Value = "View Server"
            Case Else
                ActiveCell.Value = "NOT DEFINED"
        End Select
        ActiveCell.Offset(1, 0).Select
    Loop
    Range("J8").Select
End Sub
