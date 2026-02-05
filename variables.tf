# GCP Project Configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for the compute instance"
  type        = string
  default     = "us-central1-a"
}

# Network Configuration
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "terraform-network"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "terraform-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Instance Configuration
variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "terraform-instance"
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_image" {
  description = "Boot disk image for the instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Type of the boot disk"
  type        = string
  default     = "pd-standard"
}

# SSH Configuration
variable "ssh_user" {
  description = "SSH username"
  type        = string
  default     = "terraform"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_sources" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Service Account Configuration
variable "service_account_email" {
  description = "Service account email for the instance"
  type        = string
  default     = ""
}

variable "service_account_scopes" {
  description = "Service account scopes for the instance"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
  ]
}

# Scheduling Configuration
variable "automatic_restart" {
  description = "Automatically restart the instance if terminated"
  type        = bool
  default     = true
}

variable "on_host_maintenance" {
  description = "What to do when host maintenance occurs"
  type        = string
  default     = "MIGRATE"
}

variable "preemptible" {
  description = "Whether the instance is preemptible"
  type        = bool
  default     = false
}

# Tags and Labels
variable "additional_tags" {
  description = "Additional network tags for the instance"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels to apply to the instance"
  type        = map(string)
  default = {
    environment = "development"
    managed_by  = "terraform"
  }
}

# Startup Script
variable "startup_script" {
  description = "Startup script to run on instance creation"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>GCP Instance deployed with Terraform</h1>" > /var/www/html/index.html
  EOF
}
