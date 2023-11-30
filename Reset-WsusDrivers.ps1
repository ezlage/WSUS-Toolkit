# The original version of this script is authored by Liby Philip Mathew and was obtained through this link:
# https://libyphilip.wordpress.com/2017/01/04/how-to-delete-driver-updates-from-wsus/

# Requires RSAT for WSUS
# Windows Server: Add-WindowsFeature -Name UpdateServices-RSAT -IncludeAllSubFeature;
# Windows Desktop: Add-WindowsCapability -Online -Name Rsat.WSUS.Tools~~~~0.0.1.0;

param(
    [string] $WsusServer = ([System.Net.Dns]::GetHostByName('localhost')).HostName,
    [int] $PortNumber = 8530,
    [bool] $UseSSL = $false
)

# Changing the default action on error, warning, and progress
$EPref = $ErrorActionPreference;
$WPref = $WarningPreference;
$PPref = $ProgressPreference;
$ErrorActionPreference = 'Stop';
$WarningPreference = 'SilentlyContinue';
$ProgressPreference = 'SilentlyContinue';

Write-Host "Disabling and removing WSUS drivers..."
try {    
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null;
    $wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($WsusServer, $UseSSL, $PortNumber);
    Get-WsusClassification -UpdateServer $wsus | Where-Object -FilterScript {$_.Classification.Title -eq "Drivers"} | Set-WsusClassification -Disable;
    Get-WsusClassification -UpdateServer $wsus | Where-Object -FilterScript {$_.Classification.Title -eq "Driver Sets"} | Set-WsusClassification -Disable;
    $Updates = $wsus.GetUpdates();    
    $Drivers = $Updates | Where-Object {($_.UpdateClassificationTitle -eq 'Drivers') -or ($_.UpdateClassificationTitle -eq 'Driver Sets')}
    Write-Host "-> [$($Updates.Count) updates and $($Drivers.Count) drivers found]"
    $Count = 0;
    $Update = "";
    $Drivers | ForEach-Object {
        $Count += 1;
        $Update = $_.Title;
        try {            
            $wsus.DeleteUpdate($_.Id.UpdateID);
            Write-Host "$Count/$($Drivers.Count): '$Update' removed successfully!" -ForegroundColor Green;
        } catch {
            Write-Host "$Count/$($Drivers.Count): '$Update' removal failed!" -ForegroundColor Red;
        }
    }
} catch {
    Write-Host "Failed to find, connect and/or take action in WSUS!" -ForegroundColor Red;
    Write-Host "Is RSAT for WSUS installed? Are you using credentials with sufficient privileges?" -ForegroundColor Yellow;
    Write-Host $_.Exception.GetType().FullName;
    Write-Host $_.Exception.Message;
}
Write-Host "-------------------------------> Done.";

# Restoring the default action on error, warning and progress
$ErrorActionPreference = $EPref;
$WarningPreference = $WPref;
$ProgressPreference = $PPref;

# Cleaning up
Clear-Variable Count;
Clear-Variable Drivers;
Clear-Variable EPref;
Clear-Variable PortNumber;
Clear-Variable PPref;
Clear-Variable Update;
Clear-Variable Updates;
Clear-Variable WPref;
Clear-Variable wsus;
Clear-Variable WsusServer;