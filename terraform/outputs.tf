output "pubsub_topic" {
  description = "Publish events to this topic"
  value       = google_pubsub_topic.this.name
}

output "bigquery_table" {
  description = "Streaming destination table"
  value       = "${var.project_id}.${google_bigquery_dataset.this.dataset_id}.${google_bigquery_table.events.table_id}"
}

output "subscription" {
  description = "BigQuery subscription name"
  value       = google_pubsub_subscription.to_bigquery.name
}
