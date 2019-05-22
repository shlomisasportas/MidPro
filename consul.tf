resource "aws_instance" "consul" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  private_ip        = "10.0.1.113"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true

  tags {
    Name            = "consul-1"
  }
}
