# Monitoring Architecture Diagram

```mermaid
graph TD
  Prometheus -->|scrapes| WebServer
  Prometheus -->|scrapes| Redis
  Prometheus -->|scrapes| Postgres
  Prometheus -->|exports| Grafana
  Grafana -->|visualizes| Prometheus
```
