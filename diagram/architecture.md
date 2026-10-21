# Architecture Diagram — GCP Streaming Data Warehouse

## Lucid diagram

- **Master Lucid document (all 30 diagrams, icon style):** https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit
- This project is **page 29** of that document.

## Lucid prompt (reusable)

```
Create a GCP data diagram titled "GCP Streaming Data Warehouse".
An Event Publisher publishes to a Pub/Sub Topic; a BigQuery Subscription writes the
messages directly into a partitioned BigQuery table (no Dataflow). Label the arrows.
Clean, professional Google Cloud colors.
```

## Mermaid source

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
