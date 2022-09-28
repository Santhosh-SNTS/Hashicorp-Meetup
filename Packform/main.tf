terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_ami" "packer_image" {
	#name_regex = "my-server-httpd"
	filter {
			name   = "name"
			values = ["dockpacher"]
		}
	owners = ["self"]
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.packer_image.id
  instance_type = "t2.medium"
  vpc_security_group_ids = [ aws_security_group.hug-sg.id ]
  key_name = aws_key_pair.hugkey.key_name
	tags = {
		Name = "Docins"
	}
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}
