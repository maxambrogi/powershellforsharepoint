#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Variables for Processing
$siteUrl = "<siteUrl>"
$listName = "<listName>"
 
$userName="<username>"
$password ="<password>"

  
#Setup Credentials to connect
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName,(ConvertTo-SecureString $password -AsPlainText -Force))
  
#Set up the context
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)
$ctx.Credentials = $credentials

$web = $ctx.Web
$ctx.Load($web)
$ctx.ExecuteQuery()

  
#Get the List
$list = $ctx.web.Lists.GetByTitle($ListName)
 
#sharepoint online get list items powershell
$listItems = $list.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery())
$ctx.Load($listItems)
$ctx.ExecuteQuery()   

Write-Host "items: "$collListItem.count

foreach($item in $collListItem)  
{  
    try
    {
        $ctx.Load($item.AttachmentFiles)
        $ctx.ExecuteQuery()  
        if ($item.AttachmentFiles.Count -gt 0)
        {
            Write-Host "attachments: " $item.AttachmentFiles.Count
        }

        Write-Host "********************************************************************************************"        
    }
    catch
    {
        Write-Host $_
    } 
}  

Write-Host "done"
