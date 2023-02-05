#create 3 ec2 intances

resource "aws_instance" "server1" {
  ami             = var.ami
  instance_type   = var.instance-type
  security_groups = [aws_security_group.servers-SG.id]
  subnet_id       = aws_subnet.public-subnet1.id

  tags = {
    Name = var.instance_name[0]
  }
  key_name = var.key-pair
}

resource "aws_instance" "server2" {
  ami             = var.ami
  instance_type   = var.instance-type
  security_groups = [aws_security_group.servers-SG.id]
  subnet_id       = aws_subnet.public-subnet2.id

  tags = {
    Name = var.instance_name[1]
  }
  key_name = var.key-pair
}

resource "aws_instance" "server3" {
  ami             = var.ami
  instance_type   = var.instance-type
  security_groups = [aws_security_group.servers-SG.id]
  subnet_id       = aws_subnet.public-subnet1.id

  tags = {
    Name = var.instance_name[2]
  }
  key_name = var.key-pair
}


#create file to store the ip adresses of the instances

resource "local_file" "Ip_address" {
  filename = "/home/simonlucious1/terraform-project/host-inventory"
  content  = <<EOT
${aws_instance.server1.public_ip}
${aws_instance.server2.public_ip}
${aws_instance.server3.public_ip}
EOT
}

#create load balancer

resource "aws_lb" "main-lb" {
  name               = "main-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-lb.id]
  subnets            = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  depends_on = [
    aws_instance.server1, aws_instance.server2, aws_instance.server3
  ]
}

#create target group

resource "aws_lb_target_group" "main-TG" {
  name        = "main-TG"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3

  }
}

#create listener
resource "aws_lb_listener" "main-listener" {
  load_balancer_arn = aws_lb.main-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-TG.arn
  }
}

#create listener rule

resource "aws_lb_listener_rule" "main-listener-rule" {
  listener_arn = aws_lb_listener.main-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-TG.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

locals {
  app_servers = {
    "server1" = "${aws_instance.server1.id}"
    "server2" = "${aws_instance.server2.id}"
    "server3" = "${aws_instance.server3.id}"
  }

}
resource "aws_lb_target_group_attachment" "main-TG-attachment" {
  for_each         = local.app_servers
  target_group_arn = aws_lb_target_group.main-TG.arn
  target_id        = each.value
  port             = 80
}



