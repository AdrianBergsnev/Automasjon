$usr = "admin"
$passw = ConvertTo-SecureString –String "Password!" –AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $usr, $passw 

    #Automatisk legger til credentials i logon prompt

$confpath = "C:\Users\Adrian\Desktop\configcisco\"


$session = new-SSHSession "192.168.0.150" -Credential $cred

    #Oppretter session på Hostname\IP som er definert

$date = Get-Date -format dd-mm-yyy

    #Dato variabel som setter dagens dato på .txt filen


(Invoke-SSHCommand -SSHSession $session -Command "sh run").output | Out-File ($confpath + "Config_$date.txt") -Force

    #Sender "show running-config" kommando til SSHSession og piper ut configen til en .txt fil

Remove-SSHSession -SSHSession $session

    #Fjerner SSHSessionen etter config er tatt backup av


