add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "c:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.Office.Client.Policy.dll" 

#CHANGE THOSE FOR PROD
$siteUrl = "https://<webapplication>/<list>"
$username = "<user>"

#COMMENT THIS FOR PROD
$password = "<password>" 


# UNCOMMENT THOSE FOR PROD
#$ssp = Read-Host -Prompt "Enter password" -AsSecureString
#$sspPointer = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($ssp)
#$password = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($sspPointer)
#[System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($sspPointer)

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

$ctx.AuthenticationMode = "FormsAuthentication"

$ctx.FormsAuthenticationLoginInfo = New-Object Microsoft.SharePoint.Client.FormsAuthenticationLoginInfo($username, $password)

$rootWeb = $ctx.Web

$ctx.Load($rootWeb)
$ctx.Load($rootWeb.RegionalSettings)
$ctx.Load($rootWeb.Fields)
$ctx.ExecuteQuery()
$spList = $ctx.Web.Lists.GetByTitle("<ListName>") 

       
$camlQuery = New-Object Microsoft.SharePoint.Client.CamlQuery
$collListItem = $spList.GetItems($camlQuery)
$ctx.Load($collListItem)
$ctx.Load($spList.RootFolder)
$ctx.Load($spList.DefaultView)
$ctx.Load($spList.Views)
$ctx.ExecuteQuery()

Write-Host "items: "$collListItem.count

foreach($item in $collListItem)  
{  
    try
    {
        if($item.FileSystemObjectType -eq "Folder" -and $item.Name -ne "Forms")
        {
            $ctx.Load($item.Folder)          
            $ctx.Load($item.Folder.Files)
            $ctx.Load($item.Folder.ListItemAllFields)
            $ctx.ExecuteQuery();


            $lookupField = [Microsoft.SharePoint.Client.FieldLookupValue]$item.FieldValues["<LookupFieldName>"]
            Write-Host "LookupFieldName: " $lookupField.LookupValue

            Write-Host "ID: " $item.FieldValues["ID"]
            Write-Host "Folder.ServerRelativeUrl: " $item.Folder.ServerRelativeUrl;
           
            Write-Host "********************************************************************************************"
        }
    }
    catch
    {
        Write-Host $_
    } 
}  

Write-Host "done"