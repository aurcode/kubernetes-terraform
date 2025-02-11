resource "google_compute_network" "default" {
  name = var.network_name

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name = var.subnetwork_name

  ip_cidr_range = "10.0.0.0/16"
  region        = var.region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL" # Change to "EXTERNAL" if creating an external loadbalancer

  network = google_compute_network.default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }
}

# Define a firewall rule to allow traffic on port 30000
resource "google_compute_firewall" "allow-30000" {
  name    = "allow-30000"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["30000"]
  }

  # Source range (allows from any IP, adjust as necessary)
  source_ranges = ["0.0.0.0/0"]

  # Optionally, you can apply this rule to specific tags (e.g., custom-app-server)
  target_tags = ["kubernetes-server"]
}

# Define a firewall rule to allow both port 8080 and port 30000
resource "google_compute_firewall" "allow-8080-30000" {
  name    = "allow-8080-30000"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["8080", "30000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kubernetes-testing-server"]
}
