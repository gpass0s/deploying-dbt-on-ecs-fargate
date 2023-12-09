resource "aws_security_group" "sg_for_ecs_cluster" {
  name        = "${var.PROJECT_NAME}-${var.ENV}-ecs-cluster-sg"
  description = "Security group where all ports are blocked"
  vpc_id      = var.VPC_ID
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.PROJECT_NAME}-${var.ENV}-lambdas-sg"
  }
}
