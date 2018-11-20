/* 
Pre-Requisites
 1. Create a SSH Key Pair using ssh-keygen or putty. My keys are named awskey and defined in vars.tf
Create new AWS t2.micro instance with the following resource block 
 1. AMI as defined in vars.tf
 2. Default AWS region is defined in vars.tf
 3. Provisioner used
	3.1 file - To copy a script "script.sh" that will install a few packages
	3.2 local-exec -  local-exec provisioner invokes a local executable after a resource is created
	3.3 remote-exec - The remote-exec provisioner invokes a script on a remote resource after it is created.
	    It executes the script copied in the above step
 4. Connection - Terraform uses a number of defaults when connecting to a resource. Any connection information provided in a resource will apply to all the provisioners.  
    Private key(generated in Pre-requisite) is used by provisioners and is defined in vars.tf. Provisioners use ssh as connection type for linux instances.
*/
## # Create a key pair in AWS 
#
resource "aws_key_pair" "mykey" {
  key_name = "${var.KEY_NAME}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}
## # Crete an AWS Instance 
#
resource "aws_instance" "ubuntu_t2micro" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${var.KEY_NAME}"

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "local-exec" {
    command = "uname -a"
  }
  provisioner "remote-exec" {
    inline = [ "chmod +x /tmp/script.sh",
	     "/tmp/script.sh", ]
  } 
  connection {
    user = "ubuntu"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}
