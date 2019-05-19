resource "aws_instance" "k8s-master" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "k8s-master-0"
  }
}

resource "aws_instance" "k8s-slave" {
  count             = "2"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "k8s-slave-${count.index}"
  }
}