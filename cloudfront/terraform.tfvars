regions = {
  dev = "ap-south-1"
}
environment = {
  dev = {
    profile                  = "demo"
    region                   = "ap-south-1"
    bucket_name              = "demo-bucket"
    alias                    = "demo.com"
    minimum_protocol_version = "TLSv1.2_2021"
    acm_arn                  = ""
  }

}