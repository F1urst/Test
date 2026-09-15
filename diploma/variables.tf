variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "b1gl8jo9hthj07alqgrt"
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default     = "b1g2qij5dprk0aqb2129"
}

variable "ssh_key_path" {
  description = "Path to public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_user" {
  description = "Default VM user"
  type        = string
  default     = "ubuntu"
}

variable "image_id" {
  description = "Ubuntu 22.04 image ID"
  type        = string
  default     = "fd817i7o8012578061ra"
}

# Подсети
variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    zone      = string
    cidr      = string
    is_public = bool
  }))
  default = {
    "public-a" = {
      zone      = "ru-central1-a"
      cidr      = "192.168.10.0/24"
      is_public = true
    }
    "private-a" = {
      zone      = "ru-central1-a"
      cidr      = "192.168.20.0/24"
      is_public = false
    }
    "private-b" = {
      zone      = "ru-central1-b"
      cidr      = "192.168.21.0/24"
      is_public = false
    }
  }
}

# Веб-серверы
variable "web_servers" {
  description = "Map of web servers"
  type = map(object({
    zone       = string
    subnet_key = string
  }))
  default = {
    "web-1" = {
      zone       = "ru-central1-a"
      subnet_key = "private-a"
    }
    "web-2" = {
      zone       = "ru-central1-b"
      subnet_key = "private-b"
    }
  }
}
