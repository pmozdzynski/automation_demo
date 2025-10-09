variable "server_count" {
  type    = number
  default = 1  # Default number of servers to create
}

variable "server_type" {
  type    = string
  default = "cpx11"
}

variable "location" {
  type    = string
  default = "hel1"
}
