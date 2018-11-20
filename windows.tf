/* 
Create new windows AWS t2.micro instance with the following resource block 
 1. Windows AMI are defined in vars.tf
 2. Default AWS region is defined in vars.tf
 3. "aws_instance" creation block user "user_data" which is a powershell script supplied to the instance to create the below
	3.1. Creation of a user account as declared in variable WIN_INSTANCE_USERNAME in vars.tf
	3.2. Setup winrm 
	3.3. Allow Firewall inbound access on port 5985,5986
 4. Provisioner 
	4.1. file - To copy a script "Welcome.txt" that will install a few packages
	    It executes the script copied in the above step
 4. Connection - Terraform uses a number of defaults when connecting to a resource. Any connection information provided in a resource will apply to all the provisioners. Provisioner defined in this instance creation use windows RM as connection type for windows. Username is supplied in vars.tf and password will be prompted during terraform apply.
*/
## # Create a key pair in AWS 
#
resource "aws_key_pair" "mykey" {
  key_name = "${var.KEY_NAME}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

## # Create a Windows AWS Instance
#
resource "aws_instance" "windows_t2micro" {
  ami = "${lookup(var.WIN_AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro" 
  key_name = "${var.KEY_NAME}"
  user_data = <<EOF
<powershell>
net user ${var.WIN_INSTANCE_USERNAME} '${var.WIN_INSTANCE_PASSWORD}' /add /y
net localgroup administrators ${var.WIN_INSTANCE_USERNAME} /add

winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF
  provisioner "file" {
    source = "Welcome.txt"
    destination = "C:/Welcome.txt"
  }
  connection {
    type = "winrm"
    timeout ="10m"
    user="${var.WIN_INSTANCE_USERNAME}"
    password="${var.WIN_INSTANCE_PASSWORD}"
  }
}
