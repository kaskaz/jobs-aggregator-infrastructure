variable "service_type" {
  type      = string
  nullable  = false
  
  validation {
    condition = contains(["js", "go", "kotlin", "python"], var.service_type)
    error_message = "Invalid service type value. Use one of the following: js, go, kotlin or python"
  }
}

variable "service_folder" {
  type      = map
  nullable  = false
}
