<#
.SYNOPSIS
    Returns a CSV with Collections that have at least one deployment
.DESCRIPTION
    Returns a CSV with Collections that have at least one deployment
.EXAMPLE
    PS C:\> Get-CollectionsWithDeployment -OutputFile "c:\temp\collections.csv"
.NOTES
    Requires sccm-config.json to be set
#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $OutputFile
)

$config = Get-Content -Path "sccm-config.json" | ConvertFrom-Json

$all_collections = (Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_Collection) | Select-Object CollectionID, Name, ObjectPath, MemberCount, IncrementalEvaluationRunTime
$collections_deployments_ids = (Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_Deploymentinfo).CollectionID | Get-Unique

$data = @()

for ($index = 0; $index -lt $all_collections.Length; $index++ ) {
    if ($collections_deployments_ids -contains $all_collections[$index].CollectionID) {
        $data += New-Object PsObject -property @{
            'Name'         = $all_collections[$index].Name
            'Object Path'  = $all_collections[$index].ObjectPath
            'Member Count' = $all_collections[$index].MemberCount
        }
    }
}

$data | Sort-Object -Property Name | Export-csv -Path $OutputFile -NoTypeInformation