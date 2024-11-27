# WSUS Toolkit

A set of scripts for cleaning, maintaining, configuring and optimizing Windows Server Update Services (WSUS).

## Dependencies and Requirements

- PowerShell 5 or 6 ([Microsoft has not yet ported the WSUS module to PowerShell 7](https://learn.microsoft.com/en-us/powershell/windows/module-compatibility?view=windowsserver2022-ps#:~:text=UpdateServices,by%20Compatibility%20Layer))
- [IIS Administration PowerShell module](https://blogs.iis.net/iisteam/introducing-iisadministration-in-the-powershell-gallery), when using Windows Server 2012 R2
- Windows Server Update Services (WSUS) and/or RSAT for WSUS
- [Microsoft SQL Server Official PowerShell module](https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module?view=sql-server-ver15)

## Usage Instructions

- **Optimize-WsusService.ps1**: Performs a comprehensive set of WSUS optimization tasks

    ```powershell
    # Offers the user to perform each of the recommended tasks
    .\Optimize-WsusService.ps1 -FirstRun
    ```

    ```powershell
    # Disable and remove drivers 
    # Note: this will do a lot more things, see the "Remove-DriversFromWsus.ps1" script
    .\Optimize-WsusService.ps1 -DisableDrivers
    .\Optimize-WsusService.ps1 -DeepClean
    ```
    For more details, check out the [original repository](https://github.com/awarre/Optimize-WsusServer) or the comments within the script itself. Keep in mind that the *Optimize-WsusService.ps1* script is a modified version of *Optimize-WsusServer.ps1*.

- **Remove-DriversFromWsus.ps1**: Removes drivers from WSUS

    ```powershell
    # Manually supplied parameters

    .\Remove-DriversFromWsus.ps1 [-WsusServer <server-name-or-IP>] [-PortNumber <8530|8531>] [-UseSSL <$false|$true>]
    ```

    ```powershell
    # Case without parameters, defaults to http://localhost:8530 without SSL/TLS

    .\Remove-DriversFromWsus.ps1
    ```

- **Set-WsusClientPointing.ps1**: Enable or disable a client's pointing to WSUS

    ```powershell
    .\Set-WsusClientPointing.ps1 -WsusEnabled <$false|$true> [-ComputerName <client-computer-name>] [-Credential <PSCredential>]
    ```

## Roadmap and Changelog

This repository is based on and inspired by - but not limited to - [Keep a Changelog](https://keepachangelog.com/), [Semantic Versioning](https://semver.org/) and the [ezGTR](https://github.com/ezlage/ezGTR) template. Therefore, any changes made, expected or intended will be documented in the [Roadmap and Changelog](./RMAP_CLOG.md) file.  

## Credits, Sponsorship and Licensing

Developed by [Ezequiel Lage](https://github.com/ezlage), Sponsored by [Lageteck](https://lageteck.com) and Published under the [MIT License](./LICENSE.txt).  

Credits to [AWARRE](https://github.com/awarre) and [DUMMVOLG](https://github.com/Dummvogl) for the original version and contributions to the *Optimize-WsusService.ps1* script, formerly *Optimize-WsusServer.ps1*<sup>[1](https://github.com/awarre/Optimize-WsusServer)</sup>. Credit also to [Liby Philip Mathew](https://libyphilip.wordpress.com/) for the code that gave rise to the *Remove-DriversFromWsus.ps1*<sup>[2](https://libyphilip.wordpress.com/2017/01/04/how-to-delete-driver-updates-from-wsus/)</sup> script.

All suggestions, criticisms and contributions are welcome!  

### Support this initiative!

BTC: 1Nw2fzDgtXM5X219Q9VtJ7WaSTDPua3oe8  
ERC20*: 0x089499f57ee20fd2c19f57612d9af69d645dff0d  
\* Any ERC20 token supported by Binance (ETH, USDC, USDT, etc.)  