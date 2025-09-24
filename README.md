# Koronet Test

## Deploy
- Build and push Docker image via CI pipeline
- Terraform provisions AWS VPC, ECS cluster, networking

## Monitoring
- Prometheus scrapes metrics from web, Redis, Postgres
- Grafana visualizes metrics

## Directory Structure
- `server/` — Node.js web server and tests
- `monitoring/diagram.md` — Prometheus/Grafana diagram
- `terraform/` — AWS infrastructure as code


