# Terraform Configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Uncomment and configure for remote state storage
  # backend "gcs" {
  #   bucket = "your-terraform-state-bucket"
  #   prefix = "terraform/state"
  # }
}

# Google Cloud Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  # Uncomment to use service account key file
  # credentials = file("path/to/service-account-key.json")
}
