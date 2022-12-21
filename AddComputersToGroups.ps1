#Variable used for the script
$GroupName="CN=G_Test_Script,OU=AD,OU=Groups,OU=Formation,DC=Formation,DC=local"
$OUName="OU=Workstation,OU=Formation,DC=Formation,DC=local"
$CSVFile='C:\Users\Administrator\Desktop\Computer.csv'
$LogFile='C:\Temp\LogAddComputers.txt'

#List all objet in the OU and create log file
$ordiAD=Get-ADObject -Filter * -SearchBase $OUName | Select-Object name, DistinguishedName
$ComputeraddedGroups=""
Foreach ($ordAD in $ordiAD) 
{
    Get-ADComputer $ordAD.Name -Properties MemberOf | %{if ($_.MemberOf -like $GroupName) {$ComputeraddedGroups="1"} }
    If ($ComputeraddedGroups -ne 1)
    {
        add-ADGroupMember -Identity $GroupName -Members $ordAD.DistinguishedName
        $Message="The computer" + $ordAD.Name + " is added to the group the $(get-date)" 
        Add-Content -Path $LogFile $Message
        
    }
    $ComputeraddedGroups=""
     
}

#Add computers in the csv file and create log file
#Example for the CSV file : 
   #Name;DistinguishedName
   #CLW10;CN=CLW10,OU=Hybridation,OU=Workstation,OU=Formation,DC=Formation,DC=local
   
$ComputerCSV=Import-CSV -Path $CSVFile -Delimiter ";"
Foreach ($ordAD in $ordiAD) 
{
    add-ADGroupMember -Identity $GroupName -Members $ordAD.DistinguishedName
    echo $ordAD.name
    echo $ordAD.DistinguishedName
     
}
