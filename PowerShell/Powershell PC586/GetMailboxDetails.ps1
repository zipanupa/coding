$mbcombCollection= @()
$mbcomb= @()
 
# Get main mailbox details

$mailboxMbxs= Get-Mailbox -ResultSize Unlimited | Select Identity
 
ForEach ($mbx in $mailboxMbxs)
 
{
 $mbxStats= Get-MailboxStatistics $mbx.Identity  | Select DisplayName, StorageLimitStatus, TotalItemSize, TotalDeletedItemSize, ItemCount, DeletedItemCount, Database
 
 $mbcomb ="" | Select "Display Name", StorageLimitStatus, "TotalItemSize (MB)", "TotalDeletedItemSize (MB)", ItemCount, DeletedItemCount, Database
 
       $mbcomb."Display Name"=$mbxStats.DisplayName
 
       $mbcomb.StorageLimitStatus =$mbxStats.StorageLimitStatus
 
       $mbcomb."TotalItemSize (MB)"= [math]::round($mbxStats.TotalItemSize.Value.ToMB(), 2)
 
       $mbcomb."TotalDeletedItemSize (MB)"= [math]::round($mbxStats.TotalDeletedItemSize.Value.ToMB(), 2)
 
       $mbcomb.ItemCount =$mbxStats.ItemCount
 
       $mbcomb.DeletedItemCount =$mbxStats.DeletedItemCount
 
       $mbcomb.Database =$mbxStats.Database
 
       $mbcombCollection+=$mbcomb
 
}

#$mbcombCollection
 
$mbcombCollection | Export-Csv C:\Powershell\"MailboxStats_$(Get-Date -f 'yyyyMMdd').csv"-NoType