provider "aws" {
  region = "us-east-1"
}

variable "jen-master-count" {
  default = "1"
}

variable "ami" {
        default = "lt-03249c832750f4acd"
}

data "aws_vpc" "MidPro" {
    tags {
      Name = "*OpsSchool*"
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = "${data.aws_vpc.MidPro.id}"
  tags = {
    Name = "*Mid*"
  }
}

data "aws_security_group" "sg" {
    tags = {
    Name = "*Mid*"
    }
}

resource "aws_instance" "jen-master" {
  count             = "${var.jen-master-count}"
  ami               = "${var.ami}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "jen-master-${count.index}"
  }
}
