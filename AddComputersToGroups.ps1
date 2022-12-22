#Variable used for the script
$GroupName = "CN=G_Test_Script,OU=AD,OU=Groups,OU=Formation,DC=Formation,DC=local"
$OUName = "OU=Workstation,OU=Formation,DC=Formation,DC=local"
$CSVFile = 'C:\Users\Administrator\Desktop\Computer.csv'
$LogFile = 'C:\Temp\LogAddComputers.txt'

#List all objects in the OU and create log file
$ordiAD = Get-ADObject -Filter * -SearchBase $OUName | Select-Object Name, DistinguishedName

# Add computers in the OU to the group and create log file
Foreach ($ordAD in $ordiAD) 
{
    # Use the -Server parameter to specify the domain controller to use
    # This can help improve performance if you are querying a remote domain controller
    $memberOf = Get-ADComputer $ordAD.Name -Properties MemberOf -Server <domain controller name> | Select-Object -ExpandProperty MemberOf
    if ($memberOf -notcontains $GroupName)
    {
        Add-ADGroupMember -Identity $GroupName -Members $ordAD.DistinguishedName
        $Message = "The computer $($ordAD.Name) is added to the group on $(Get-Date)" 
        Add-Content -Path $LogFile -Value $Message
    }
}

# Add computers in the CSV file and create log file
#Example for the CSV file : 
#   Name;DistinguishedName
#   CLW10;CN=CLW10,OU=Hybridation,OU=Workstation,OU=Formation,DC=Formation,DC=local

$ComputerCSV = Import-CSV -Path $CSVFile -Delimiter ";"
Foreach ($computer in $ComputerCSV) 
{
    Add-ADGroupMember -Identity $GroupName -Members $computer.DistinguishedName
    $Message = "The computer $($computer.Name) is added to the group on $(Get-Date)" 
    Add-Content -Path $LogFile -Value $Message
}
