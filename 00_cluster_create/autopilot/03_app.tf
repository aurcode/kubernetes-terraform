resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx-deployment"
  }

  spec {
    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx-container"

          port {
            container_port = 80
            name           = "http"
          }
        }

        toleration {
          effect   = "NoSchedule"
          key      = "kubernetes.io/arch"
          operator = "Equal"
          value    = "amd64"
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.nginx.spec[0].selector[0].match_labels.app
    }

    port {
      port        = 80
      target_port = kubernetes_deployment_v1.nginx.spec[0].template[0].spec[0].container[0].port[0].container_port
    }

    type = "LoadBalancer"
  }
}

output "nginx_public_ip" {
  value = kubernetes_service_v1.nginx.status[0].load_balancer[0].ingress[0].ip
}
