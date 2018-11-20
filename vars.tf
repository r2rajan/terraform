variable "AWS_ACCESS_KEY"  { default="YOUR_ACCESS_KEY" }
variable "AWS_SECRET_KEY"  { default="YOUR_SECRET_KEY" }
variable "KEY_NAME" { default="awskey"}
variable "PATH_TO_PUBLIC_KEY" { default="awskey.pub" }
variable "PATH_TO_PRIVATE_KEY" { default="awskey" }
variable "WIN_INSTANCE_USERNAME" { default="Terraform" }
variable "WIN_INSTANCE_PASSWORD" { }
variable "AWS_REGION"  {
  default = "us-east-2"
}
variable "AMIS" {
  type = "map"
  default = {     us-east-2="ami-0b19eeac8c68a0d2d"
   		  us-east-1="ami-0f9351b59be17920e"
		  us-west-1="ami-0e066bd33054ef120"
		  us-west-2="ami-0afae182eed9d2b46"
	    }
}
variable "WIN_AMIS" {
  type = "map"
  default = {     us-east-2="ami-028779930ada5200c"
                  us-east-1="ami-028779930ada5200c"
            }
}

