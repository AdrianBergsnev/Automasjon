Import-module ActiveDirectory  

### Kommentarer:
## Dette skriptet er hardkodet for IKT-Klassen på Hønefoss VGS. Dette skriptet oppretter brukere, og setter dem i Elevgruppe
## Kjør dette scriptet på domenekontrolleren for å unngå komplikasjoner.
## Det eneste man trenger å gjøre er å passe på at "CSV" pathen stemmer med din egen .csv fil.
## Eksempel på hvordan hvordan en bruker ser ut på .csv filen:
## Fornavn;Etternavn
## Ola;Nordmann
## Skriptet tar de to første bokstavene i fornavn og to første i etternavn etterfulgt av årstallet:
## (eksempel): OlNo2017
## Klasselisten for IKT elever 2017-2018 ligger i Klasseliste.csv på samme repo
## Output med brukernavn og passord havner i terminalen etter man har kjørt scriptet.

$Users = Import-Csv -Delimiter ";" -Path "C:\Users\Administrator\Desktop\Powershell\Klasseliste.csv"      

## Genererer tilfeldig passord for brukeren
Function Tilfeldig-Passord ($length = 8)
{
    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122

    $password = Get-Random -count $length `
        -input ($punc + $digits + $letters) |
            % -begin { $aa = $null } `
            -process {$aa += [char]$_} `
            -end {$aa}

    return $password
}

## Dette oppretter brukeren
    
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
    $OU = Get-ADOrganizationalUnit -Filter * | where name -Like "Elever" 
    $ADUsers = Get-ADUser -Filter * -SearchBase $OU   
    $Group = Get-ADGroup -Filter * | where name -Like "Elever"                           
    $Password = Tilfeldig-Passord
    
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$SAM" `
    -UserPrincipalName $UPN -GivenName "$UserFirstname" `
    -Surname "$UserLastname" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
    -Enabled $true -Path "$OU" -ChangePasswordAtLogon $false –PasswordNeverExpires $true -Server $ADServer
     Write-Host "Navn:" $Displayname "-" "Brukernavn:" $SAM "-" "Passord" $Password 
}

Add-ADGroupMember $Group -Members $ADUsers