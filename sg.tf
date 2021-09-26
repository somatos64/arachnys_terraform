
resource "aws_security_group" "take_home_test_ec2_sg" {
  description = "Allow traffic between the Load Balancer security group and the backend ec2 instances"
  name        = "${local.application}-elb-ec2-sg"
  # vpc_id      = var.vpc_id
  tags = local.tags
  lifecycle {
  ignore_changes = [
    tags,
  ]
}
}

 resource "aws_security_group_rule" "application_elb_ec2_sg_egress_1" {
  type                     = "egress"
  description              = "Allow all traffic outbound"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.take_home_test_ec2_sg.id
} 

resource "aws_security_group_rule" "application_elb_ec2_sg_ingress_1" {
  type                     = "ingress"
  description              = "Allow traffic inbound from anywhere on port 443"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.take_home_test_ec2_sg.id
}


resource "aws_security_group_rule" "application_elb_ec2_sg_ingress_2" {
  type                     = "ingress"
  description              = "Allow ssh inbound from joao_mac pc on port 22"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks = ["82.155.23.162/32"]
  security_group_id        = aws_security_group.take_home_test_ec2_sg.id
}


resource "aws_security_group_rule" "application_elb_ec2_sg_ingress_3" {
  type                     = "ingress"
  description              = "Allow tcp inbound from anywhere pc on port 9000"
  from_port                = 9000
  to_port                  = 9000
  protocol                 = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.take_home_test_ec2_sg.id
}