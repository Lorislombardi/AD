$Etendues=Get-DhcpServerv4Scope -ComputerName "Srv.mydom.dom"

Foreach ($Etendue in $Etendues) 
{
$Value=$Etendue.ScopeId | select IPAddressToString
$File=$Value.IPAddressToString
Export-DhcpServer -ComputerName Srv.mydom.dom -ScopeId $Value.IPAddressToString -File "c:\DHCP\$File.xml" -Leases

}

$nbfichier = (Get-ChildItem "C:\DHCP").Count

if ($nbfichier -eq $Etendues)
{

    Write-host "Exportation ok"

}
Else
{

    Write-host "Exportation ko"
    break

}


Foreach ($Etendue in $Etendues) 
{
$Value=$Etendue.ScopeId | select IPAddressToString
$File=$Value.IPAddressToString 
Import-DhcpServer -ComputerName NewSrv.mydom.dom -ScopeId $Value.IPAddressToString -File "c:\DHCP\$File.xml" -Leases -BackupPath c:\DHCP -Force

}
