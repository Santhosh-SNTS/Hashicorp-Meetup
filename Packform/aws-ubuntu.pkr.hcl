packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "dockpacher"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    Name = "Docki"
  }
}

build {
  name = "packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {

    inline = [
      "echo Installing Dockpacher",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo apt install -y apache2",
      "sudo service apache2 start",
      "sudo chown -R $USER:$USER /var/www/html",
      "sudo git clone https://github.com/AbdulBhashith/portfolio.git",
      "sudo mv portfolio/* /var/www/html"
    ]
  }
}
