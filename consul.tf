provider "aws" {
  region = "us-east-1"
}

variable "ami" {
        default = "ami-0a313d6098716f372"
}

variable image-flavor {
        default = "t2.micro"
}

variable key-pair {
        default = "shlomi1"
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
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "jen-master-${count.index}"
  }
}

resource "aws_instance" "jen-slave" {
  count             = "${var.jen-slave-count}"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "jen-slave-${count.index}"
  }
}
