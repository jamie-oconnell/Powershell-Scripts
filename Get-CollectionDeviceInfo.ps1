<#
.SYNOPSIS
    Given a device collection id, retrieve the status of each device.
.DESCRIPTION
    Given a device collection id, exports a csv file with Name, ADLastLogonTime, ADSiteName, CurrentLogonUser, LastActiveTime, LastClientCheckTime, LastDDR, LastLogonUser, PrimaryUser
.EXAMPLE
    PS C:\> Get-CollectionDeviceInfo -CollectionId 100 -OutputFile C:\temp\output.csv
.NOTES
    Requires sccm-config.json to be set
#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $OutputFile,
    [Parameter(Mandatory = $true)]
    [string]
    $CollectionId
)

$config = Get-Content -Path "sccm-config.json" | ConvertFrom-Json
$today = get-date

$devices = (Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_CollectionMember_a -Filter "CollectionID = '$($CollectionId)'").Name

$data = @()

for ($index = 0; $index -lt $devices.Length; $index++ ) {
    $name = $devices[$index]
    $details = Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_CombinedDeviceResources -Filter "Name = '$($name)'" | Select-Object Name, ADLastLogonTime, ADSiteName, CurrentLogonUser, LastActiveTime, LastClientCheckTime, LastDDR, LastLogonUser, PrimaryUser
    $last_online = ""
    if ($details.LastActiveTime) {
        $y = New-TimeSpan -Start $details.LastActiveTime -End $today
        $last_online = "$($y.days)"
    }
    $details | Add-Member -MemberType NoteProperty -Name 'Device Last Online (days ago)' -Value $last_online
    
    $data += $details
}

$data | Export-csv -Path $OutputFile -NoTypeInformation