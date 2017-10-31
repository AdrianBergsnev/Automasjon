Import-Module ActiveDirectory

$Brukernavn = Read-Host -Prompt 'Brukernavn'
$Passord = Read-Host -Prompt 'Passord' -AsSecureString
$Domene = Get-ADDomain | select -ExpandProperty Forest
$ADserver = Get-ADDomain | select -ExpandProperty RIDMaster
$UPN = $Brukernavn + '@' + $Domene
$Year = Get-Date -UFormat %Y 
$Tid = New-TimeSpan -Days (Read-Host -Prompt 'Aktive dager')
$Expirationdate= (Get-Date) + $Tid
$Gjestegruppe = Get-ADGroup -Filter * | where name -Like "VPN gjester"
$GjesteOU = Get-ADOrganizationalUnit -Filter * | where name -Like "Gjester"
$Brukere = New-ADUser $Brukernavn -SamAccountName $Brukernavn -UserPrincipalName $UPN -DisplayName '$Brukernavn' `
-AccountPassword $Passord -Server $ADserver -Enabled $true -Path $GjesteOU -PasswordNeverExpires $true -AccountExpirationDate $Expirationdate

$Brukere | Write-Host

$Gjester = Get-ADUser -Filter * -SearchBase $GjesteOU

Add-ADGroupMember $Gjestegruppe -Members $Gjester








