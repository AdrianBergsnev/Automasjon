$DNSDomain="IKT-FAG.no"
$DNSServers="172.18.0.2","172.18.0.3"
$DHCPServerIP="172.18.0.10"
$WDSServerIP="172.18.0.4"
$Bootfilename="boot\x86\pxeboot.com"

#VLAN Definitions: Name, Description, StartIP, EndIP, NetMask, Router, ScopeID (*.*.*.0)
$vlan300 = @("Elevnett", "VLAN 300", "172.16.0.10", "172.16.0.150", "255.255.255.0", "172.16.0.1","172.16.0.0")
$vlan400 = @("Laerernett", "VLAN 400", "172.17.0.10", "172.17.0.240", "255.255.255.0", "172.17.0.254","172.17.0.0")
$vlan600 = @("Testlabnett", "VLAN 600", "192.168.1.10", "192.168.1.240", "255.255.255.0", "192.168.1.254","192.168.1.0")
$vlan999 = @("Management", "VLAN 999", "192.168.0.110", "192.168.0.180", "255.255.255.0", "192.168.0.102","192.168.0.0")

$vlans = $vlan300,$vlan400,$vlan600,$vlan999

# Install DHCP Server
Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools

# Create local security groups for DHCP Service
cmd.exe /c "netsh dhcp add securitygroups"

# Restart DHCP-Service
Restart-service dhcpserver

# Authorize DHCP in Active Directory
Add-DhcpServerInDC -DnsName $Env:COMPUTERNAME $DHCPServerIP

# Suppress ServerManager post-installation notification
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Create all VLANs with their options
foreach ($vlan in $vlans) {
    Add-DhcpServerV4Scope -Name $vlan[0] -Description $vlan[1] -StartRange $vlan[2] -EndRange $vlan[3] -SubnetMask $vlan[4]
    Set-DhcpServerV4OptionValue -ScopeId $vlan[6] -Router $vlan[5] -DnsServer $DNSServers -DnsDomain $DNSDomain
    Set-DhcpServerv4Scope -ScopeId $vlan[6] -LeaseDuration 8.00:00:00
    Write-Host "Scope"$vlan[0]"is created!" -ForegroundColor Green
    }

# Set up DHCP Server options
Set-DhcpServerV4OptionValue -DnsServer $DNSServers -DnsDomain $DNSDomain
Set-DhcpServerv4OptionValue -OptionId 66 -Value $WDSServerIP
Set-DhcpServerv4OptionValue -OptionId 67 -Value $Bootfilename
Write-Host "All done!" -ForegroundColor Green
