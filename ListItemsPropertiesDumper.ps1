$fullName = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SharePoint.Client').Location
Add-Type -Path $fullName

$fullName = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SharePoint.Client.Runtime').Location
Add-Type -Path $fullName


$siteUrl = "https://<webapplication>/<site>"
$username = "user"
$password = "passowrd" 
$listName = "listName"

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl)

$ctx.AuthenticationMode = "FormsAuthentication"
$ctx.FormsAuthenticationLoginInfo = New-Object Microsoft.SharePoint.Client.FormsAuthenticationLoginInfo($username, $password)

$docs = $ctx.web.Lists.GetByTitle($listName)
$items = $docs.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery()) 
$ctx.Load($items)
$ctx.ExecuteQuery()


Foreach($item in $items)
{
        Write-host -f Green $item["Title"] "("$item.FileSystemObjectType")"
        try
        {
            $fieldValues = $item.FieldValues
            Foreach($prop in $fieldValues.keys)
            {
                Write-host -f yellow $prop 
            }
        }
        catch
        {
            Write-host "Error:"$_.Exception.Message -f Red
        }
}


