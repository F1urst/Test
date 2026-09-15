# Бастион-хост
resource "yandex_compute_instance" "bastion" {
  name                      = "bastion"
  hostname                  = "bastion"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this["public-a"].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Веб-серверы (создание в цикле)
resource "yandex_compute_instance" "web" {
  for_each = var.web_servers

  name                      = each.key
  hostname                  = each.key
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = each.value.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this[each.value.subnet_key].id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    user-data = "#cloud-config\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: False\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Zabbix сервер
resource "yandex_compute_instance" "zabbix" {
  name                      = "zabbix"
  hostname                  = "zabbix"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this["public-a"].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.zabbix.id]
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Elasticsearch
resource "yandex_compute_instance" "elastic" {
  name                      = "elastic"
  hostname                  = "elastic"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 30
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this["private-a"].id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.elastic.id]
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Kibana
resource "yandex_compute_instance" "kibana" {
  name                      = "kibana"
  hostname                  = "kibana"
  allow_stopping_for_update = true
  platform_id               = "standard-v2"
  zone                      = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this["public-a"].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kibana.id]
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}
