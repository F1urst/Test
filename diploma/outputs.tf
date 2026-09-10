output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "zabbix_ip" {
  value = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
}

output "kibana_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "web_1_private_ip" {
  value = yandex_compute_instance.web-1.network_interface[0].ip_address
}

output "web_2_private_ip" {
  value = yandex_compute_instance.web-2.network_interface[0].ip_address
}

output "elastic_private_ip" {
  value = yandex_compute_instance.elastic.network_interface[0].ip_address
}

output "load_balancer_ip" {
  value = yandex_alb_load_balancer.web-alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
