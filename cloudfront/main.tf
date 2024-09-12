module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.1"

  bucket = local.env_conf.bucket_name
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  tags = local.tags
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "1"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.env_conf.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
    }
  }
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["${local.env_conf.alias}"]

  comment             = "${var.product}- ${local.environment}  Cloudfront"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "cyvx Origin Access Identity - ${local.environment}"
  }

  origin = {
    s3_one = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_one"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    query_string           = false

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  custom_error_response = [
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 300
    }
  ]

  geo_restriction = {
    restriction_type = "none"
  }

  viewer_certificate = {
    acm_certificate_arn = local.env_conf.acm_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version : local.env_conf.minimum_protocol_version
  }
  tags = local.tags


}

