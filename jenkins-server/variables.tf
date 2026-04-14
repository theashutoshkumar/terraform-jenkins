variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "jenkins-server-key"
  type        = string
}

