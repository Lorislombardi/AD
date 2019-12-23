#powershell script to create a local administrator account if it is not present on the machine. 
#The account name is defined in the variable $ localUsers (line 12). 

#Subsequently, the list of local accounts is recovered, then the script checks if the account is to create this. 

#If the account is then nothing happens, if it is not present then the creation is made: 

#Account Ownership: 
#Account Type: Administrator 
#Password: Pa$$w0rd (line 37) 
#Properties: Password never expires activated
#This script has been inserted into a GPO to run on hundreds of stations

Param
(
	[Parameter(Position=0,Mandatory=$false)]
	[ValidateNotNullorEmpty()]
	[Alias('cn')][String[]]$ComputerName=$Env:COMPUTERNAME,
	[Parameter(Position=1,Mandatory=$false)]
	[Alias('un')][String[]]$AccountName,
	[Parameter(Position=2,Mandatory=$false)]
	[Alias('cred')][System.Management.Automation.PsCredential]$Credential
)
$localUsers='LocalAdmin'	
$Obj = @()

Foreach($Computer in $ComputerName)
{
	If($Credential)
	{
		$AllLocalAccounts = Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2" `
		-Filter "LocalAccount='$True'" -ComputerName $Computer -Credential $Credential -ErrorAction Stop
	}
	else
	{
		$AllLocalAccounts = Get-WmiObject -Class Win32_UserAccount -Namespace "root\cimv2" `
		-Filter "LocalAccount='$True'" -ComputerName $Computer -ErrorAction Stop
	}
	
	if($AllLocalAccounts.name -Contains $localUsers)
       {
            
    
           
        }
        else
        {
            Add-Type -Assembly System.Web
            $pass='Pa$$w0rd'
            NET USER LocalAdmin "$pass" /ADD /y
            NET LOCALGROUP "Administrateurs" "LocalAdmin" /add
            WMIC USERACCOUNT WHERE "Name='LocalAdmin'" SET PasswordExpires=FALSE
	    


        }

} 
