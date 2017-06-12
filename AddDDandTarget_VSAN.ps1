Import-Module StarWindX

$server = New-SWServer -host 127.0.0.1 -port 3261 -user root -password starwind

New-Item -Path C:\$folder -ItemType Directory

$folder = "VSANwPowerShell"

$path = "C:\$folder"

try
{
    #Connection
    $server.Connect()

    if ( $server.Connected )
    {
        #create image file
        $fileName="VSANwPowerShell"
        New-Storage -server $server -path $path -fileName $fileName -storageSize 1024 -blockSize 512
        
        #create device
        $device = Add-DDDevice -server $server -path $path -fileName $fileName -sectorSize 512 -CacheMode "wb" -CacheSize 128

        $device
        
        #create target
        $targetAlias="VSANwPowerShell"
        $target = New-Target -server $server -alias $targetAlias -devices $device.Name

        $target
    }

    $server.Disconnect()
}
catch
{
    Write-Host "Exception $($_.Exception.Message)" -foreground red
    $server.Disconnect()
}