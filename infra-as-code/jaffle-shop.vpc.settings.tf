/* This project creates a VPC with two subnets, one public and one private. It also creates all necessary
resources to guarantee connectivity to the internet from the public subnet. Moreover, this project
establishes a VPC peering connection to Quext's main VPC.
*/

# Instantiate a single VPC using foundational models
module "base-vpc" {
  source               = "./modules/vpc-resources/vpc"
  PROJECT_NAME         = local.PROJECT_NAME
  ENV                  = local.ENV
  AWS_TAGS             = local.AWS_TAGS
  RESOURCE_SUFFIX      = "vpc"
  VPC_CIDR_BLOCK       = var.VPC_CIDR_BLOCKS[local.ENV]
  ENABLE_DNS_HOSTNAMES = true
}

# Instantiate an internet gateway for
module "internet-gateway" {
  source          = "./modules/vpc-resources/internet-gateway"
  PROJECT_NAME    = local.PROJECT_NAME
  ENV             = local.ENV
  AWS_TAGS        = var.AWS_TAGS
  RESOURCE_SUFFIX = "igw"
  VPC_ID          = module.base-vpc.id
}

#region Private Subnet
module "private_subnet_1a" {
  source            = "./modules/vpc-resources/subnet"
  PROJECT_NAME      = local.PROJECT_NAME
  ENV               = local.ENV
  RESOURCE_SUFFIX   = "private-subnet-1a"
  AWS_TAGS          = merge(var.AWS_TAGS, tomap({ "Type" = "private" }))
  VPC_ID            = module.base-vpc.id
  AVAILABILITY_ZONE = "us-east-1a"
  CIDR_BLOCK        = var.PRIVATE_SUBNET_1A_CIDR_BLOCKS[local.ENV]
}


module "private_subnet_route_table" {
  source          = "./modules/vpc-resources/route-table"
  PROJECT_NAME    = local.PROJECT_NAME
  ENV             = local.ENV
  RESOURCE_SUFFIX = "private-subnet-rt"
  AWS_TAGS        = var.AWS_TAGS
  VPC_ID          = module.base-vpc.id
}

resource "aws_route_table_association" "private_subnet_1a" {
  subnet_id      = module.private_subnet_1a.id
  route_table_id = module.private_subnet_route_table.id
}

resource "aws_route" "private_subnet" {
  route_table_id         = module.private_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat-gateway.id
}
#endregion

#region Public Subnet
/* A public subnet is a subnet that is associated with a route table that has a route to
an Internet gateway
*/
module "public_subnet_1a" {
  source            = "./modules/vpc-resources/subnet"
  PROJECT_NAME      = local.PROJECT_NAME
  ENV               = local.ENV
  RESOURCE_SUFFIX   = "public-subnet-1a"
  AWS_TAGS          = merge(var.AWS_TAGS, tomap({ "Type" = "public" }))
  VPC_ID            = module.base-vpc.id
  AVAILABILITY_ZONE = "us-east-1a"
  CIDR_BLOCK        = var.PUBLIC_SUBNET_1A_CIDR_BLOCKS[local.ENV]
}

module "public_subnet_route_table" {
  source          = "./modules/vpc-resources/route-table"
  PROJECT_NAME    = local.PROJECT_NAME
  ENV             = local.ENV
  RESOURCE_SUFFIX = "public-subnet-rt"
  AWS_TAGS        = var.AWS_TAGS
  VPC_ID          = module.base-vpc.id
}

resource "aws_route_table_association" "public_subnet_1a" {
  subnet_id      = module.public_subnet_1a.id
  route_table_id = module.public_subnet_route_table.id
}

# Routes traffic from public subnet to internet gateway
resource "aws_route" "igw" {
  route_table_id         = module.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet-gateway.id
}

module "elastic-ip-for-nat-gateway" {
  source          = "./modules/vpc-resources/elastic-ip"
  PROJECT_NAME    = local.PROJECT_NAME
  ENV             = local.ENV
  RESOURCE_SUFFIX = "eip"
  AWS_TAGS        = var.AWS_TAGS
}

# NAT Gateways enables resources present in a private subnet to connect to the internet.
# NAT Gateways deployed in a public subnet must have an elastic IP address associated to it.
module "nat-gateway" {
  source          = "./modules/vpc-resources/nat-gateway"
  PROJECT_NAME    = local.PROJECT_NAME
  ENV             = local.ENV
  RESOURCE_SUFFIX = "nat-gateway"
  AWS_TAGS        = var.AWS_TAGS
  VPC_ID          = module.base-vpc.id
  SUBNET_ID       = module.public_subnet_1a.id
  ELASTIC_IP_ID   = module.elastic-ip-for-nat-gateway.id
}
#endregion
#region SG
module "ecs-resources-security-group" {
  source                     = "./modules/vpc-resources/security-group"
  PROJECT_NAME               = local.PROJECT_NAME
  ENV                        = local.ENV
  RESOURCE_SUFFIX            = "general-purpose-sg"
  AWS_TAGS                   = var.AWS_TAGS
  VPC_ID                     = module.base-vpc.id
  SECURITY_GROUP_DESCRIPTION = "General purpose security group for shared network VPC"
  EGRESS_RULES = [
    {
      description      = "Egress rule for general purpose SG"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  INGRESS_RULES = [
    {
      description              = "Full ingress for DMS"
      from_port                = 0
      to_port                  = 0
      protocol                 = "all"
      cidr_blocks              = []
      ipv6_cidr_blocks         = []
      source_security_group_id = module.ecs-resources-security-group.id
    }
  ]
}
#end region

module "vpc-endpoint-ecr" {
  source          = "./modules/vpc-resources/ecr-vpc-endpoint"
  ENV             = local.ENV
  PROJECT_NAME    = local.PROJECT_NAME
  RESOURCE_SUFFIX = "vpc-endpoint"
  VPC_ID          = module.base-vpc.id
  SUBNET_ID_LIST = [
    module.private_subnet_1a.id
  ]
  SECURITY_GROUP_LIST = [module.ecs-resources-security-group.id]
  AWS_TAGS            = var.AWS_TAGS
}