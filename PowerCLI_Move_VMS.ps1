Import-Module Vmware.vimautomation.core

Connect-VIServer 192.168.0.9

$List = @(
"neo"
"mouse"

)
$Collection = @()
$List | foreach {
    $VMName = $_

    $Collection += Get-VM | where { $_.Name -like "*$VMName*" }
}

$Collection.Name

<#

$VMs = Get-VM | where { $PSItem.Name -like "16*" }

$half = ($VMs.Count) / 2
$half

$i = 1
$VMs | foreach {


    if ($i -le $half)
    {
        $_ | Move-VM -Destination 192.168.0.21
        
    }

    $i++
}
#>