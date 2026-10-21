output "pubsub_topic" {
  value = google_pubsub_topic.this.name
}
output "bigquery_table" {
  value = "${var.project_id}.${google_bigquery_dataset.this.dataset_id}.${google_bigquery_table.events.table_id}"
}
output "subscription" {
  value = google_pubsub_subscription.to_bigquery.name
}
