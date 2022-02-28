<#
.SYNOPSIS
    Enables unattended access via SCCM Remote Control.
.DESCRIPTION
    Modifies the registry on a remote device to enable unattended access to SCCM.
.EXAMPLE
    PS C:\> Set-RemoteControlUnattendedAccess -ComputerName "TEST"
    PS C:\> Set-RemoteControlUnattendedAccess -ComputerName "TEST" -Reset
    The reset flag will set the registry to the default values.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]   $ComputerName,

    [Parameter(Mandatory = $false)]
    [switch]   $Reset
)

$hive = [Microsoft.Win32.RegistryHive]::LocalMachine
$path = "SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control"

$base = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($hive, $ComputerName)
$key = $base.OpenSubKey($path, $true)

if ($Reset) {
    $key.SetValue("Audible Signal", 1, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("Permission Required", 1, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("RemCtrl Taskbar Icon", 1, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("RemCtrl Connection Bar", 1, [Microsoft.Win32.RegistryValueKind]::DWord)
}
else {
    $key.SetValue("Audible Signal", 0, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("Permission Required", 0, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("RemCtrl Taskbar Icon", 0, [Microsoft.Win32.RegistryValueKind]::DWord)
    $key.SetValue("RemCtrl Connection Bar", 0, [Microsoft.Win32.RegistryValueKind]::DWord)
}
