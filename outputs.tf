# Instance Outputs
output "instance_name" {
  description = "Name of the compute instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_id" {
  description = "ID of the compute instance"
  value       = google_compute_instance.vm_instance.instance_id
}

output "instance_self_link" {
  description = "Self link of the compute instance"
  value       = google_compute_instance.vm_instance.self_link
}

output "instance_zone" {
  description = "Zone of the compute instance"
  value       = google_compute_instance.vm_instance.zone
}

output "machine_type" {
  description = "Machine type of the instance"
  value       = google_compute_instance.vm_instance.machine_type
}

# Network Outputs
output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_cidr" {
  description = "CIDR range of the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

# IP Address Outputs
output "external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_address.static_ip.address
}

output "internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

# SSH Connection String
output "ssh_connection" {
  description = "SSH connection string"
  value       = "ssh ${var.ssh_user}@${google_compute_address.static_ip.address}"
}

# HTTP URL
output "http_url" {
  description = "HTTP URL to access the instance"
  value       = "http://${google_compute_address.static_ip.address}"
}

output "https_url" {
  description = "HTTPS URL to access the instance"
  value       = "https://${google_compute_address.static_ip.address}"
}

# Firewall Rules
output "firewall_rules" {
  description = "List of firewall rules created"
  value = {
    ssh   = google_compute_firewall.allow_ssh.name
    http  = google_compute_firewall.allow_http.name
    https = google_compute_firewall.allow_https.name
  }
}
