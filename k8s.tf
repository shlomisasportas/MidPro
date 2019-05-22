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

resource "aws_instance" "k8s-master" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  private_ip        = "10.0.1.55"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "k8s-master-0"
  }
}

resource "aws_instance" "k8s-slave" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  private_ip        = "10.0.1.205"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "k8s-slave-${count.index}"
  }
}
