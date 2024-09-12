variable "regions" {
  type = map(any)
}
variable "product" {
  default = "demo"
}
variable "environment" {
  type = any
}
# variable "parameter" {
#   type = any
# }

# variable "log_delivery_configuration" {
#   type = any
# }