#resource "local_file" "kubernetes_config" {
#  content  = google_container_cluster.default.kube_config.0.raw_config
#  filename = "kubeconfig.yaml"
#}
