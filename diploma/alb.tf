# Target Group (целевая группа)
resource "yandex_alb_target_group" "web-tg" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private-a.id
    ip_address = yandex_compute_instance.web-1.network_interface[0].ip_address
  }
  target {
    subnet_id  = yandex_vpc_subnet.private-b.id
    ip_address = yandex_compute_instance.web-2.network_interface[0].ip_address
  }
}

# Backend Group (бэкенд группа)
resource "yandex_alb_backend_group" "web-bg" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.web-tg.id]

    healthcheck {
      timeout  = "10s"
      interval = "2s"
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP Router
resource "yandex_alb_http_router" "web-router" {
  name = "web-router"
}

resource "yandex_alb_virtual_host" "web-vhost" {
  name           = "web-vhost"
  http_router_id = yandex_alb_http_router.web-router.id

  route {
    name = "default-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web-bg.id
        timeout          = "60s"
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web-alb" {
  name        = "web-alb"
  network_id  = yandex_vpc_network.diploma-net.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public-a.id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = ""
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web-router.id
      }
    }
  }
}

output "alb_ip" {
  value = yandex_alb_load_balancer.web-alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
