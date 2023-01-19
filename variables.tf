variable "instance_type" {
  description = "instance type"
  type        = string
}

variable "tags" {
  description = "Tags to set on the computed variables."
  type        = map(string)
}

variable "db_root_password" {
  description = "sql db root password"
  type        = string
}

variable "database" {
  description = "database name"
  type        = string
}

variable "username" {
  description = "database username"
  type        = string
}

variable "password" {
  description = "database password"
  type        = string
}

variable "region" {
  type        = string
}

variable "project_id" {
  type        = string
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "16 hosts"
  default = "172.17.0.0/28"
}

variable "pods_ipv4_cidr_block" {
  description = "65,536 hosts"
  type        = string
  default = "10.101.0.0/16"
}

variable "services_ipv4_cidr_block" {
  description = "65,536 hosts"
  type        = string
  default = "10.102.0.0/16"
}

variable "initial_node_count" {
  description = "nodes per zone"
  type        = number
}