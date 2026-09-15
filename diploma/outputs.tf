output "alb_ip" {
  description = "Public IP of Application Load Balancer"
  value       = yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_ip" {
  description = "Public IP of bastion host"
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "zabbix_ip" {
  description = "Public IP of Zabbix"
  value       = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
}

output "kibana_ip" {
  description = "Public IP of Kibana"
  value       = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "web_servers" {
  description = "Web servers internal IPs"
  value = {
    for k, v in yandex_compute_instance.web : k => v.network_interface[0].ip_address
  }
}

output "elastic_private_ip" {
  description = "Elasticsearch internal IP"
  value       = yandex_compute_instance.elastic.network_interface[0].ip_address
}
