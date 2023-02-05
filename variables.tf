variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc-name" {
  type    = string
  default = "main-vpc"
}

variable "vpc-cidr_block" {
  type    = string
  default = "172.0.0.0/16"
}

variable "subnet-cidr_block" {
  type    = list(string)
  default = ["172.0.1.0/24", "172.0.2.0/24"]
}

variable "aws_internet_gateway-name" {
  default = "main-IG"
}

variable "route_table-name" {
  default = "main-RT"
}

variable "subnet-AZ" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "subnet-name" {
  type    = list(string)
  default = ["public-subnet1", "public-subnet2"]
}

variable "instance-type" {
  default = "t2.micro"
}

variable "instance_name" {
  type    = list(string)
  default = ["server1", "server2", "server3"]
}

variable "ami" {
  default = "ami-00874d747dde814fa"
}

variable "inbound_ports" {
  type    = list(number)
  default = [22, 443, 80]
}

variable "key-pair" {
  default = "papae-key-pair"
}

variable "domain-name"{
  default = "lucious.me"
}