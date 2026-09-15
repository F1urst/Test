# VPC сеть
resource "yandex_vpc_network" "this" {
  name = "diploma-network"
}

# Создание подсетей в цикле
resource "yandex_vpc_subnet" "this" {
  for_each       = var.subnets
  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [each.value.cidr]
}

# NAT-шлюз для доступа в интернет
resource "yandex_vpc_gateway" "nat" {
  name = "diploma-nat"
  shared_egress_gateway {}
}

# Таблица маршрутизации
resource "yandex_vpc_route_table" "private" {
  name       = "private-route"
  network_id = yandex_vpc_network.this.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.1"
  }
}
