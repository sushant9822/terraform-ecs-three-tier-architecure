resource "aws_eip" "ovpn_eip" {
  instance = module.ec2_instance.id
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name                   = "${var.product}-${local.environment}-openvpn"
  ami                    = local.env_conf.ami
  instance_type          = local.env_conf.instance_type
  key_name               = "therix-key"
  monitoring             = true
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets[0]
  tags = local.tags
}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.product}-${local.environment}-openvpn-sg"
  description = "Security group for OpenVPN"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  tags        = local.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}