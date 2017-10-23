Import-module ActiveDirectory  

### Kommentarer:
## Dette skriptet er hardkodet for IKT-Klassen på Hønefoss VGS. Dette skriptet oppretter brukere, og setter dem i Elevgruppe
## Kjør dette scriptet på domenekontrolleren for å unngå komplikasjoner.
## Det eneste man trenger å gjøre er å passe på at "CSV" pathen stemmer med din egen .csv fil.
## Eksempel på hvordan hvordan en bruker ser ut på .csv filen:
## Fornavn;Etternavn;Passord
## Ghada;Alashqar;8EGB4MA
## Skriptet tar de to første bokstavene i fornavn og to første i etternavn etterfulgt av årstallet:
## (eksempel): GhAl2017
## Klasselisten for IKT elever 2017-2018 ligger i Klasseliste.csv på samme repo
## Output med brukernavn og passord havner i terminalen etter man har kjørt scriptet.
## Brukerne må logge på en domenemaskin, for å der etter bli bedt om å endre passordet sitt.


$Users = Import-Csv -Delimiter ";" -Path "C:\Users\Administrator\Desktop\Powershell\Klasseliste.csv"          
foreach ($User in $Users)             
{    
    $Year = Get-Date -UFormat %Y
    $Domainname = Get-ADDomain | select -ExpandProperty Forest
    $ADServer = Get-ADDomain | select -ExpandProperty RIDMaster
    $Displayname =  $User.Fornavn + " " +  $User.Etternavn          
    $UserFirstname = $User.Fornavn   
    $UserLastname = $User.Etternavn   
    $SAM = $UserFirstname.Substring(0,2) + $UserLastname.Substring(0,2) + $Year
    $UPN = $SAM + '@' + $Domainname 
    $OU = "OU=Elever,OU=2IKA,DC=2,DC=ika,DC=no"  
    $ADUsers = Get-ADUser -Filter * -SearchBase $OU   
    $Group = "CN=Elever,OU=Grupper,OU=2IKA,DC=2,DC=ika,DC=no"                            
    $Password = $User.Passord
    
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$SAM" `
    -UserPrincipalName $UPN -GivenName "$UserFirstname" `
    -Surname "$UserLastname" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
    -Enabled $true -Path "$OU" -ChangePasswordAtLogon $True –PasswordNeverExpires $false -Server $ADServer
     Write-Host "Brukernavn:" $SAM "-" "Passord" $Password
}

Add-ADGroupMember $Group -Members $ADUsers