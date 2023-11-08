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

variable "service_jobs_provider_reedcouk_api_key" {
  type      = string
  nullable  = false
}

variable "web_demo_folder" {
  type = string
  nullable = false
}

variable "web_demo_polling_time" {
  type = number
}
