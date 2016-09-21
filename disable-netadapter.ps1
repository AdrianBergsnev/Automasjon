If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

##Øverste delen er for å prioritere at scriptet skal kjøres som Administrator

$nic = "Ethernet"

##Definer navn på ditt nettverkskort med å erstatte "Ethernet" med f.eks "lokalt nettverk"

Disable-NetAdapter -Name $nic -Confirm:$false

Write-Host "Nettverkortet $nic er deaktivert, vil aktiveres igjen om 8 sekunder" -ForegroundColor Red 

Sleep -Seconds 8

Enable-NetAdapter -Name $nic

Write-Host "Nettverkskortet $nic er aktivert" -ForegroundColor Green

Sleep -Seconds 2
