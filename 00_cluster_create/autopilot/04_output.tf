output "cluster_command" {
  value = "gcloud beta container --project \"${google_container_cluster.default.name}\" clusters get-credentials ${data.google_client_config.default.project} --zone=${google_container_cluster.default.location}"
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_endpoint" {
  value = google_container_cluster.default.endpoint
}

output "nginx_public_ip" {
  value = kubernetes_service_v1.nginx.status[0].load_balancer[0].ingress[0].ip
}

output "nginx_service_url" {
  value = "http://${kubernetes_service_v1.nginx.status[0].load_balancer[0].ingress[0].ip}:80"
}

output "nginx_deployment_name" {
  value = kubernetes_deployment_v1.nginx.metadata[0].name
}

output "nginx_service_type" {
  value = kubernetes_service_v1.nginx.spec[0].type
}

output "nginx_service_ports" {
  value = kubernetes_service_v1.nginx.spec[0].port[*].port
}
