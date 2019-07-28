$mbcombCollection= @()
$mbcomb= @()
 
# $archiveMbxs= Get-Mailbox -Archive -OrganizationalUnit "ParisUser" -ResultSize Unlimited | Select Identity, ArchiveWarningQuota, ArchiveQuota

$archiveMbxs= Get-Mailbox -Archive -ResultSize Unlimited | Select Identity, ArchiveWarningQuota, ArchiveQuota
 
ForEach ($mbx in $archiveMbxs)
 
{
 $mbxStats= Get-MailboxStatistics $mbx.Identity -Archive | Select DisplayName, StorageLimitStatus, TotalItemSize, TotalDeletedItemSize, ItemCount, DeletedItemCount, Database
 
 $mbcomb ="" | Select "Display Name", StorageLimitStatus, "TotalItemSize (MB)", "TotalDeletedItemSize (MB)", ItemCount, DeletedItemCount, Database, "ArchiveWarningQuota (GB)", "ArchiveQuota (GB)"
 
 
 
       $mbcomb."Display Name"=$mbxStats.DisplayName
 
       $mbcomb.StorageLimitStatus =$mbxStats.StorageLimitStatus
 
       $mbcomb."TotalItemSize (MB)"= [math]::round($mbxStats.TotalItemSize.Value.ToMB(), 2)
 
       $mbcomb."TotalDeletedItemSize (MB)"= [math]::round($mbxStats.TotalDeletedItemSize.Value.ToMB(), 2)
 
       $mbcomb.ItemCount =$mbxStats.ItemCount
 
       $mbcomb.DeletedItemCount =$mbxStats.DeletedItemCount
 
       $mbcomb.Database =$mbxStats.Database
 
       $mbcomb."ArchiveWarningQuota (GB)"=$mbx.ArchiveWarningQuota.Value.ToGB()
 
       $mbcomb."ArchiveQuota (GB)"=$mbx.ArchiveWarningQuota.Value.ToGB()
 
       $mbcombCollection+=$mbcomb
 
}
 
#$mbcombCollection
 
$mbcombCollection | Export-Csv C:\Powershell\"ArchiveStats_$(Get-Date -f 'yyyyMMdd').csv"-NoType

 

 