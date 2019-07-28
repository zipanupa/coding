$LUN = gwmi win32_diskdrive | where {$_.model -like "netapp*"}
foreach ($disk in $LUN) 
 {$diskID = $disk.index
 $dpscript = @"
 select disk $diskID
 online disk noerr
 attrib disk clear readonly
 "@
 $dpscript | diskpart}