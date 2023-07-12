terraform {
  #backend "local"
  
  cloud {
    organization = "kessingh"

    workspaces {
      name = "provisioners"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "main" {
  id = "vpc-0c7c01d8f590aaf57"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqEqbJD/PVx3Vsj/L9h4lElpTP4XXG/n2NS170sEl+FgH8Ipl+uiV5rl2ja8/InBFVJrH5yYj1lSm2Ew3P5U3QbN7S4evrM14+iScCzLKljpS1aLko0gKr5YAAFxcZ5KmFi6AWDvdBwD7Y2Fm80vHAk7DgC43JqCL0x2x6AWl03q5aaUYN3NUoLaob95xJPm9njbVEUe3D276viooJJLMfjMPecLFEPLYX+wIR26qZLSY65Xpg6cUfo07bZNnYiNWK78E1NOuSU/1nnFu2wmIdyn8jSEUsEdEipGr0CU1plQk/AppBh5A+nOQcNvtenA8W8RfxiNL5iya2K8riJUEUKvD/f2bq0DEGos+meO6SjIkgKZ593yd8tLWGvZvJRIhGIt4EuFnmMlncnPIarvGywvVSCyqkKRO4NrYdewS1Irt8HeABybyhH5VOKiX42f8AyZtTlPu6hWvyJw48Og8T2wWBcjxcDE1Q2uXouV084pBoc07z9VYmdnZWoXlS3T0= ksingh@localhost.localdomain"
}

resource "aws_security_group" "sg_my_test" {
  name        = "allow_tls"
  description = "my sg test sg"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["49.37.178.208/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    Name = "allow_tls"
  }
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}

resource "aws_instance" "test" {
  ami                    = "ami-0d13e3e640877b0b9"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_test.id]
  #user_data = data.template_file.user_data.rendered
  /*provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ~/private_ips.txt"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ~/public_ips.txt"
  }*/
   connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/.ssh/id_rsa")}" 
    host     = "$(self.public_ip)"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${self.public_ip} >> ~/public_ips.txt"
    ]
  }
  tags = {
    Name = "test-provisioner"
    }
}

output "public_ip" {
  value = aws_instance.test.public_ip
}



































