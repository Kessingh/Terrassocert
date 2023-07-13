data "aws_vpc" "main" {
  id = "var.vpc_id"
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
      cidr_blocks      = [var.my_ip_with_cidr]
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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230503.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data" {
  template = file("./userdata.yaml")
}


resource "aws_instance" "test" {
  ami                    = "${data.aws_ami.latest-amazon-linux-image.id}"
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_test.id]
  user_data = data.template_file.user_data.rendered
  /*provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ips.txt"
  }*/

  /*provisioner "remote-exec" {
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("${path.module}/home/ksingh/.ssh/id_rsa")}"
    #private_key = "${file("/home/ksingh/.ssh/id_rsa")}" 
    host     = "$(self.public_ip)"
  }
    inline = [
      "echo ${self.public_ip} >> ~/public_ips.txt"
    ]
  }*/

  provisioner "file" {
    source      = "/home/ksingh/testfile"
    destination = "/home/ec2-user/testfile"
  connection {
    type     = "ssh"
    user     = "ec2-user"
    #private_key = "${file("${path.module}/home/ksingh/.ssh/id_rsa")}"
    private_key = var.private_key 
    host     = "${self.public_ip}"
   }
  }
  tags = {
    Name = var.server_name
    }
}


