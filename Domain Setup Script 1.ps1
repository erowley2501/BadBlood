
## STEP 1

Function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
Disable-InternetExplorerESC

#mkdir c:\badblood

#cd c:\badblood

#$url = "https://github.com/davidprowe/BadBlood/archive/master.zip"

#$output = "C:\badblood\master.zip"

# Next two lines force Invoke-WebRequest to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::SecurityProtocol = "Tls12"

#Invoke-WebRequest -Uri $url -OutFile $output

#Expand-Archive -Path .\master.zip -DestinationPath C:\badblood

Enable-PSRemoting -Force
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTS Connections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1
#Rename-Computer -ComputerName (hostname) -newname "TEMP-DC"
##netsh winhttp set proxy 1.3.5.2:8080 #removed
#Set-TimeZone -Name "Eastern Standard Time"

Import-Module ServerManager
Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools
Install-WindowsFeature –Name GPMC


## Shutdown and snapshot VM @ AD Installed

## STEP 2

### Run this after restart
$domainname = "secureorg.example"
$NTDPath = "C:\Windows\ntds"
$logPath = "C:\Windows\ntds"
$sysvolPath = "C:\Windows\Sysvol"
$domainmode = "win2012R2"
$forestmode = "win2012R2"

Install-ADDSForest -CreateDnsDelegation:$false `
 -DatabasePath $NTDPath -DomainMode $domainmode `
 -DomainName $domainname -ForestMode $forestmode `
 -InstallDns:$true -LogPath $logPath `
 -NoRebootOnCompletion:$true `
 -SysvolPath $sysvolPath -Force:$true

## Shutdown and snapshot VM @ AD Initialized

## STEP 3

cd "Z:\erowley2501\BadBlood"

.\Invoke-BadBlood.ps1

## Shutdown and snapshot VM @ AD Populated