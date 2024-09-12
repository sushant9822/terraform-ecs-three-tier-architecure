output "vpc_details" {
  value = module.vpc
}

data "aws_db_subnet_group" "rds" {
  name = module.vpc.database_subnet_group_name
}

output "db_subnet_group_arn" {
  value = data.aws_db_subnet_group.rds.arn
}
