# Сеть VPC
resource "yandex_vpc_network" "diploma-net" {
  name = "diploma-network"
}

# Публичная подсеть (зона A)
resource "yandex_vpc_subnet" "public-a" {
  name           = "public-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma-net.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Приватная подсеть (зона A) с маршрутом через NAT
resource "yandex_vpc_subnet" "private-a" {
  name           = "private-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma-net.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private-route.id
}

# Приватная подсеть (зона B) с маршрутом через NAT
resource "yandex_vpc_subnet" "private-b" {
  name           = "private-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma-net.id
  v4_cidr_blocks = ["192.168.21.0/24"]
  route_table_id = yandex_vpc_route_table.private-route.id
}

# NAT-шлюз для доступа в интернет из приватных подсетей
resource "yandex_vpc_gateway" "nat-gateway" {
  name = "diploma-nat"
  shared_egress_gateway {}
}

# Маршрут для приватных подсетей через NAT
resource "yandex_vpc_route_table" "private-route" {
  name       = "private-route"
  network_id = yandex_vpc_network.diploma-net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.1"
  }
}
