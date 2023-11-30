param(
    [bool] $WsusEnabled,
    [string] $ComputerName = $null,  
    [pscredential] $Credential = $null
)

# Changing the default action on error, warning, and progress
$EPref = $ErrorActionPreference;
$WPref = $WarningPreference;
$PPref = $ProgressPreference;
$ErrorActionPreference = 'SilentlyContinue';
$WarningPreference = 'SilentlyContinue';
$ProgressPreference = 'SilentlyContinue';

[int] $WsusEnabled = [int][bool]::Parse($WsusEnabled);
$Result = $false;

function Complete-WsusClientPointing {
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [int]$Value
    )
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value $Value -Force -ErrorAction Stop;
        Restart-Service -Name "wuauserv" -Force -ErrorAction Stop;
        return $true;
    } catch {
        return $false;
    }
}

Write-Host;
Write-Host "Setting WSUS client pointing to $WsusEnabled... ";
try {
    if (($ComputerName -eq "") -and ($null -eq $Credential)) {
        $Result = Complete-WsusClientPointing $WsusEnabled;  
    } elseif (($ComputerName -eq "") -and -not($null -eq $Credential)) {
        $Result = Invoke-Command -Credential $Credential -ScriptBlock ${function:Complete-WsusClientPointing} -ArgumentList $WsusEnabled;
    } elseif (($null -eq $Credential) -and -not($ComputerName -eq "")) {
        $Result = Invoke-Command -ComputerName $ComputerName -ScriptBlock ${function:Complete-WsusClientPointing} -ArgumentList $WsusEnabled;
    } else {
        $Result = Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock ${function:Complete-WsusClientPointing} -ArgumentList $WsusEnabled;
    }
} finally {    
    if ($Result) {
        Write-Host "--------------------------> " -NoNewline;
        Write-Host "Success!" -ForegroundColor Green;
    } else {
        Write-Host "Are you using a session or credential with sufficient privileges?" -ForegroundColor Yellow;
        Write-Host "--------------------------> " -NoNewline;
        Write-Host "Failure!" -ForegroundColor Red;                
    }
}
Write-Host;

# Restoring the default action on error, warning and progress
$ErrorActionPreference = $EPref;
$WarningPreference = $WPref;
$ProgressPreference = $PPref;

# Cleaning up
Clear-Variable WsusEnabled;
Clear-Variable ComputerName;
Clear-Variable Credential;
Clear-Variable EPref;
Clear-Variable WPref;
Clear-Variable PPref;
Clear-Variable Result;