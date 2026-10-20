data "google_project" "this" {}

locals {
  name       = var.project_name
  dataset_id = replace("${var.project_name}_dw", "-", "_")
  pubsub_sa  = "serviceAccount:service-${data.google_project.this.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

############################
# BigQuery warehouse
############################
resource "google_bigquery_dataset" "this" {
  dataset_id = local.dataset_id
  location   = "US"
}

resource "google_bigquery_table" "events" {
  dataset_id          = google_bigquery_dataset.this.dataset_id
  table_id            = "events"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "ts"
  }

  schema = jsonencode([
    { name = "id", type = "STRING", mode = "NULLABLE" },
    { name = "event", type = "STRING", mode = "NULLABLE" },
    { name = "value", type = "FLOAT", mode = "NULLABLE" },
    { name = "ts", type = "TIMESTAMP", mode = "NULLABLE" },
  ])
}

############################
# Pub/Sub -> BigQuery subscription (no Dataflow needed)
############################
resource "google_pubsub_topic" "this" {
  name = "${local.name}-events"
}

resource "google_bigquery_dataset_iam_member" "pubsub_writer" {
  dataset_id = google_bigquery_dataset.this.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = local.pubsub_sa
}

resource "google_pubsub_subscription" "to_bigquery" {
  name  = "${local.name}-to-bq"
  topic = google_pubsub_topic.this.id

  bigquery_config {
    table               = "${var.project_id}.${google_bigquery_dataset.this.dataset_id}.${google_bigquery_table.events.table_id}"
    use_table_schema    = true
    drop_unknown_fields = true
  }

  depends_on = [google_bigquery_dataset_iam_member.pubsub_writer]
}
