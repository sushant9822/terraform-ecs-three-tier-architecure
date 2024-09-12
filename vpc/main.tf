resource "aws_eip" "nat" {
  count = 1
  #vpc   = true
  tags  = local.tags
}

module "vpc" {
  source                             = "terraform-aws-modules/vpc/aws"
  version                            = "3.14.0"
  name                               = "${var.product}-${local.environment}-vpc"
  azs                                = local.env_conf.azs
  cidr                               = local.vpc_conf.vpc_cidr_block
  private_subnets                    = local.vpc_conf.private_subnets
  public_subnets                     = local.vpc_conf.public_subnets
  database_subnets                   = local.vpc_conf.database_subnets
  create_database_subnet_route_table = false
  database_dedicated_network_acl     = false
  database_inbound_acl_rules         = local.database_inbound_acl_rules
  database_outbound_acl_rules        = local.database_outbound_acl_rules
  private_dedicated_network_acl      = true
  private_inbound_acl_rules          = local.private_inbound_acl_rules
  private_outbound_acl_rules         = local.private_outbound_acl_rules
  public_dedicated_network_acl       = true
  public_inbound_acl_rules           = local.public_inbound_acl_rules
  public_outbound_acl_rules          = local.public_outbound_acl_rules
  create_database_subnet_group       = true
  enable_dns_hostnames               = true
  enable_nat_gateway                 = true
  single_nat_gateway                 = true
  reuse_nat_ips                      = true
  external_nat_ip_ids                = aws_eip.nat.*.id
  tags                               = local.tags
}