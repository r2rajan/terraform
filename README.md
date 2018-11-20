
Terraform Instance Creation Scripts for AWS

<b>Pre-Requisites</b>

- Create a SSH Key Pair using ssh-keygen or putty. My keys are named awskey and declared in <b>vars.tf</b>
- Refer to <b>vars.tf</b> for all variables 

<b>Create new AWS t2.micro instance with the following resource block </b>

 Terraform Script - instance.tf

 1. AMI as defined in vars.tf
 
 2. Default AWS region is defined in vars.tf
 
 3. Provisioner used
 
	3.1 file - To copy a script "script.sh" that will install a few packages
        
	3.2 local-exec -  local-exec provisioner invokes a local executable after a resource is created
        
	3.3 remote-exec - The remote-exec provisioner invokes a script on a remote resource after it is created.
	    It executes the script copied in the above step
 
 4. Connection - Terraform uses a number of defaults when connecting to a resource. Any connection information provided in a resource will apply to all the provisioners.  Private key(generated in Pre-requisite) is used by provisioners and is defined in vars.tf. Provisioners use ssh as connection type for linux instance

<b> Windows Instance Creation in AWS </b>

Terraform Script - windows.tf

Create a windows AWS t2.micro instance with the following resource block<br>
1. Windows AMI is declared in vars.tf

2. Default AWS region is declared in vars.tf

3. "aws_instance" creation block uses "user_data" is a powershell script supplied to the instance to create the below

	3.1. Creation of a user account as declared in variable WIN_INSTANCE_USERNAME in vars.tf
	
	3.2. Setup winrm
	
	3.3. Allow Firewall inbound access on port 5985,5986
 
 4. Provisioner
        4.1. file - To copy a script "Welcome.txt" that will install a few packages
	
	4.2. It executes the script copied in the above step
 
 5. Connection - Terraform uses a number of defaults when connecting to a resource. Any connection information provided in a   resource will apply to all the provisioners. Provisioner defined in this instance creation use windows RM as connection type for windows. Username is supplied in vars.tf and password will be prompted during terraform apply. 
Terraform Script - windows.tf
