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
  depends_on = ["aws_instance.ansible"]
}

data "aws_security_group" "sg" {
    tags = {
    Name = "*Mid*"
    }
    depends_on = ["aws_instance.ansible"]
}
resource "aws_instance" "minikube" {
  count             = "1"
  ami               = "${var.ami}"
  instance_type     = "${var.image-flavor}"
  private_ip        = "10.0.1.120"
  key_name          = "${var.key-pair}"
  subnet_id         = "${element(data.aws_subnet_ids.subnets.ids, count.index)}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]
  associate_public_ip_address = true
  user_data = <<-EOF
#!/bin/bash
sudo chmod 777 /var/tmp
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo apt-get update
sudo apt-get install docker.io -y
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
sleep 180

sudo minikube start --vm-driver=none
sudo minikube start --vm-driver=none
#sudo minikube start
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

sudo kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
sudo kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
#sudo kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
#sudo kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
sudo kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
sudo kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml





 EOF

  tags {
    Name            = "minikube-1"
  }
}
