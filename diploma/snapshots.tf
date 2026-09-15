# Ежедневное резервное копирование дисков всех ВМ
resource "yandex_compute_snapshot_schedule" "daily" {
  name = "daily-snapshots"

  schedule_policy {
    expression = "0 2 * * *"  # Каждый день в 02:00
  }

  retention_period = "168h"  # 7 дней

  snapshot_spec {
    description = "Daily snapshot for diploma project"
  }

  disk_ids = concat(
    [yandex_compute_instance.bastion.boot_disk[0].disk_id],
    [for vm in yandex_compute_instance.web : vm.boot_disk[0].disk_id],
    [yandex_compute_instance.zabbix.boot_disk[0].disk_id],
    [yandex_compute_instance.elastic.boot_disk[0].disk_id],
    [yandex_compute_instance.kibana.boot_disk[0].disk_id]
  )
}
