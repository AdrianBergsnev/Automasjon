Import-module ActiveDirectory  

$Users = Import-Csv -Delimiter ";" -Path "C:\Users\Administrator\Desktop\Powershell\Klasseliste.csv"          
foreach ($User in $Users)             
{    
    $Year = Get-Date -UFormat %Y
    $Domainname = Get-ADDomain | select -ExpandProperty Forest
    $ADUsers = Get-ADUser -Filter * -SearchBase $OU  
    $ADServer = Get-ADDomain | select -ExpandProperty RIDMaster
    $Displayname =  $User.Fornavn + " " +  $User.Etternavn          
    $UserFirstname = $User.Fornavn   
    $UserLastname = $User.Etternavn   
    $SAM = $UserFirstname.Substring(0,2) + $UserLastname.Substring(0,2) + $Year
    $UPN = $SAM + '@' + $Domainname 
    $OU = "OU=Elever,OU=2IKA,DC=2,DC=ika,DC=no"    
    $Group = "CN=Elever,OU=Grupper,OU=2IKA,DC=2,DC=ika,DC=no"                            
    $Password = $User.Passord 
    
    New-ADUser -Name "$Displayname" -DisplayName "$Displayname" -SamAccountName "$SAM" -UserPrincipalName $UPN -GivenName "$UserFirstname" `
    -Surname "$UserLastname" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
    -Enabled $true -Path "$OU" -ChangePasswordAtLogon $True –PasswordNeverExpires $false -Server $ADServer
       Write-Host "Brukernavn:" $SAM "-" "Passord" $Password
}

Add-ADGroupMember $Group -Members $ADUsers