Import-Module StarWindX

$server = New-SWServer -host 127.0.0.1 -port 3261 -user root -password starwind

$folder = "VSANwPowerShell"

$path = "C:\$folder"

$targetname = "testtarget"

New-Item -Path C:\$folder -ItemType Directory


try
{
    #Connection
    $server.Connect()

    if ( $server.Connected )
    {
        #create image file
        $fileName=$folder
        New-Storage -server $server -path $path -fileName $fileName -storageSize 1024 -blockSize 512
        
        #Create device
        $device = Add-DDDevice -server $server -path $path -fileName $fileName -sectorSize 512 -CacheMode "wb" -CacheSize 1024

        $device
        
        #Create target
        $targetAlias=$targetname
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