<#
.SYNOPSIS
    Returns a CSV with details of devices in a colleciton
.DESCRIPTION
    Returns CSV containing: Name, ADLastLogonTime, ADSiteName, CurrentLogonUser, LastActiveTime, LastClientCheckTime, LastDDR, LastLogonUser, PrimaryUser, DeviceLastOnline (Days Ago).
    Useful for determing Online state of devices in a collection. 
.EXAMPLE
    PS C:\> Get-DeviceCollectionDetails -CollectionId "100" -OutputFile "c:\temp\devices.csv"
.NOTES
    Requires sccm-config.json to be set
#>

param(
    [Parameter(Mandatory = $true)]
    [string] $CollectionId,

    [Parameter(Mandatory = $true)]
    [string] $OutputFile

)

$config = Get-Content -Path "sccm-config.json" | ConvertFrom-Json

$today = get-date

$devices = (Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_CollectionMember_a -Filter "CollectionID = '$($CollectionId)'").Name


$data = @()

for ($index = 0; $index -lt $devices.Length; $index++ ) {
    $device_name = $devices[$index]
    $device_details = Get-CimInstance -ComputerName $config.SITE_SERVER_NAME -Namespace root\sms\site_$config.SITE_CODE -class SMS_CombinedDeviceResources -Filter "Name = '$($device_name)'" | Select-Object Name, ADLastLogonTime, ADSiteName, CurrentLogonUser, LastActiveTime, LastClientCheckTime, LastDDR, LastLogonUser, PrimaryUser
    $last_online = $device_details.LastActiveTime 
    $y = New-TimeSpan -Start $last_online -End $today
    $last_online = "$($y.days)"

    $device_details | Add-Member -MemberType NoteProperty -Name 'Device Last Online (days ago)' -Value $last_online
    
    $data += $device_details
}

$data | Export-csv -Path $OutputFile -NoTypeInformation