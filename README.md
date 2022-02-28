# Powershell Scripts

A collection of various powershell scripts I am using daily as a EUC Support Analyst. Most of them are related to SCCM / MEM & Application / Software Update deployments.

## Config

Small config file named _sccm-config.json_ contians common variables to be used within these scripts. E.g the SITE_SERVER_NAME & SITE_CODE. An example file is included.

## Script Reference

### Get-CollectionDeviceInfo.ps1

Params:

- CollectionId
- OutputFile

Given a device collection id, exports a csv file with Name, ADLastLogonTime, ADSiteName, CurrentLogonUser, LastActiveTime, LastClientCheckTime, LastDDR, LastLogonUser, PrimaryUser

Useful for getting a report of device online state from a particular colleciton.

<br>

### Get-CollectionsWithDeployment.ps1

Params:

- OutputFile

Returns a CSV with Collections that have at least one deployment

Useful for getting a report of collections that have a deployment tied to them.

<br>

### Get-CollectionsWithoutDeployment.ps1

Params:

- OutputFile

Returns a CSV with Collections that have no deployments.

Useful for getting a report of collections that can be cleaned up.

<br>

### Get-CollectionsWithoutDeployment.ps1

Params:

- OutputFile

Returns a CSV with Collections that have no deployments.

Useful for getting a report of collections that can be cleaned up.
