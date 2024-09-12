variable "regions" {
  type = map(any)
}
variable "product" {
  default = "demo"
}
variable "environment" {
  type = any
}
