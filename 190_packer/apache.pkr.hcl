variable "ami_id" {
	type = string
	default = "ami-0d13e3e640877b0b9"
}

locals {
	app_name = "httpd"
}

source "amazon-ebs" "httpd" {
	ami_name = "my-server-${local.app_name}"
	instance_type = "t2.micro"
	region = "ap-south-1"
	source_ami = "${var.ami_id}"
	ssh_username = "ec2-user"
	tags = {
		Name = local.app_name
	}
}

build {
	sources = ["source.amazon-ebs.httpd"]
	provisioner "shell"  {
		inline = [
			"sudo yum install -y httpd",
			"sudo systemctl start httpd",
			"sudo systemctl enable httpd"
		]
	}
}