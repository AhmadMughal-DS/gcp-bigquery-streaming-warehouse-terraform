# GCP Streaming Data Warehouse (Terraform)

> Real-time analytics on Google Cloud: Pub/Sub streams straight into a partitioned BigQuery table via a BigQuery subscription — no Dataflow required.
> **Author:** Muhammad Ahmad · **IaC:** Terraform · **Cloud:** GCP

![Terraform CI](https://github.com/AhmadMughal-DS/gcp-bigquery-streaming-warehouse-terraform/actions/workflows/terraform.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.6%2B-7B42BC?logo=terraform&logoColor=white)
![Security](https://img.shields.io/badge/scanned-tfsec%20%7C%20checkov-success)
![GCP](https://img.shields.io/badge/GCP-Pub%2FSub%20%7C%20BigQuery-4285F4?logo=googlecloud&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

- A **Pub/Sub topic** receives event messages.
- A **BigQuery subscription** writes messages directly into a **partitioned BigQuery table** (`ts` day-partitioned) — Google manages the streaming, so there is no Dataflow job to run.
- The Pub/Sub service account is granted **BigQuery Data Editor** on the dataset.

## 🏗️ Architecture

> 🎨 **Interactive diagram (industry-standard icons):** [open in Lucid — page 29](https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit)

```mermaid
flowchart LR
    Pub([Event Publisher])
    Topic[Pub/Sub Topic]
    Sub[BigQuery Subscription]
    BQ[(BigQuery - partitioned)]

    Pub -->|publish| Topic
    Topic --> Sub
    Sub -->|direct write| BQ
```

## 🚀 Deploy & test

```bash
cd terraform
gcloud auth application-default login
terraform init
terraform apply -var="project_id=YOUR_PROJECT_ID"

# Stream an event straight into BigQuery
gcloud pubsub topics publish $(terraform output -raw pubsub_topic) \
  --message='{"id":"1","event":"purchase","value":42.0,"ts":"2026-10-20T10:00:00Z"}'
```

## 🧹 Clean up

```bash
terraform destroy -var="project_id=YOUR_PROJECT_ID"
```

## 💰 Cost note

Pub/Sub and BigQuery are pay-per-use; partitioning keeps query costs down. Near-zero idle cost.

## 🔐 Production hardening (next steps)

- Add a **dead-letter topic** for messages that fail to write.
- Add **clustering** on high-cardinality columns.
- Use **scheduled queries** to build curated/aggregated tables.

---

*Built and maintained by **Muhammad Ahmad**.*
