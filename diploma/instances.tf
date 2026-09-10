# Бастион-хост (публичный IP)
resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Веб-сервер 1 (приватный, зона A) - С ПАРОЛЕМ
resource "yandex_compute_instance" "web-1" {
  name        = "web-1"
  hostname    = "web-1"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-a.id
    nat       = false
  }

  metadata = {
    user-data = "#cloud-config\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: False\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Веб-сервер 2 (приватный, зона B) - С ПАРОЛЕМ
resource "yandex_compute_instance" "web-2" {
  name        = "web-2"
  hostname    = "web-2"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-b.id
    nat       = false
  }

  metadata = {
    user-data = "#cloud-config\nchpasswd:\n  list: |\n    ubuntu:ubuntu123\n  expire: False\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Zabbix (публичный IP)
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Elasticsearch (приватный)
resource "yandex_compute_instance" "elastic" {
  name        = "elastic"
  hostname    = "elastic"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 30
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-a.id
    nat       = false
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}

# Kibana (публичный IP)
resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  allow_stopping_for_update = true
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd817i7o8012578061ra"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }

  metadata = {
    user-data = "#cloud-config\nssh_authorized_keys:\n  - ${file(var.ssh_key_path)}"
  }
}
