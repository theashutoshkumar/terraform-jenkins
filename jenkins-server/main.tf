
#VPC MODULE

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names
  public_subnets = var.public_subnets

  map_public_ip_on_launch = true
  enable_dns_hostnames    = true

  tags = {
    Name      = "jenkins-vpc"
    terraform = "true"
    env       = "dev"
    team      = "dev"
  }

  public_subnet_tags = {
    Name = "public"
  }
}

#SG Group
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "jenkins-sg"
  description = "Jenkins security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [{
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  tags = {
    Name      = "jenkins-sg"
    terraform = "true"
    env       = "dev"
    team      = "dev"
  }

}

#EC2 MODULE
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "jenkins-instance"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.security-group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.available.names[0]

  tags = {
    Name      = "jenkins-instance"
    terraform = "true"
    env       = "dev"
    team      = "dev"
  }
}
