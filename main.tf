module "vpc" {
  source           = "./vpc"
  vpc_name         = var.vpc_name
  pub_subnet_name  = var.pub_subnet_name
  priv_subnet_name = var.priv_subnet_name
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "rke2_key" {
  key_name   = "rke2_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoHJmeX5Uof5r/ynAnr35ibp/qrShar9m/M7xBV8UZge7zGNyWvW4qSKMDJF5Dx3CnzDcrA/4rpsPOdIIYQyfn6KfmTeM/Yi+IL0BJk1yXTifuRcaW9Ze12YXTLX60HkuODhR7H/MgXVrhdq/673XlNBg/Au7u5Tya32bm2Xmpq+X4GpyD5Sm8fEwHFumuDxdb/dxfzMlFqxroUEIRV8tdAIP8A+/denVLgIiBTE3fnXQK2JVf28pjVsxuC8YOaId2iJav7BaK5VWjl91plIEGAb/GTq7oVv/o43YcYPEVIyKVGpUMhndkfk38Z8iVzCIHOqlICcRTbUYKjV5XkTWTtIJ7fTFGjhJBlyvDHre6dzvszROU9107MyhXTgvhK0R5Cd765N6lFvNy2g3cQizbjUc6uPfluxDUuRFCh18r4um0h9lhr/kpO5LoFMGmolKoewSb8PfKFi5vlwZ+4C40qaMyP1DIZcyLKUTlYC9UbWtckkMlByPgjcdv1hc/F3k= emumba@emumba-HP-ProBook-450-G8-Notebook-PC"
}


resource "aws_instance" "foo" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.rke2_key.id
  subnet_id                   = module.vpc.pub_subnet

}