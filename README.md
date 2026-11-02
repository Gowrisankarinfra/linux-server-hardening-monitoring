# Linux Server Hardening, Backup and Monitoring Automation

## Goal
Provide reusable Linux operations scripts and a local monitoring lab:
- Read-only system health report (CPU, memory, disk, uptime)
- Log and service checks
- Optional S3 backup of a selected directory
- Docker Compose stack for Prometheus, Node Exporter, and Grafana
- A hardening checklist for SSH, firewall, updates, and least privilege

## Repository contents
- `scripts/system-health.sh` – safe read-only health report
- `scripts/s3-backup.sh` – archive and upload a chosen directory to S3
- `monitoring/` – Prometheus and Grafana Compose configuration
- `docs/hardening-checklist.md` – manual hardening checklist

## Run the health report

```bash
chmod +x scripts/*.sh
./scripts/system-health.sh
```

The script does not change system configuration.

## Run the monitoring stack
Prerequisite: Docker Engine and Docker Compose plugin.

```bash
cd monitoring
docker compose up -d
docker compose ps
```

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000

The sample Grafana password is configured through an environment variable. Set it
before starting the stack:

```bash
export GRAFANA_ADMIN_PASSWORD='replace-with-a-strong-local-password'
docker compose up -d
```

Change the password for any shared environment. Do not commit `.env` files or secrets.

## Optional S3 backup
Prerequisites: AWS CLI configured using a least-privilege identity and an existing
private S3 bucket.

```bash
./scripts/s3-backup.sh /path/to/sample-data your-private-bucket backups/linux-lab
```

The script creates a timestamped archive in `/tmp` and uploads it. Test first with
non-sensitive sample files. The script does not delete local source files or old S3
objects.

## Hardening
Read `docs/hardening-checklist.md` before applying any changes. SSH and firewall
changes can lock you out. Test on a disposable VM and keep console access available.

## Validation checklist
- [ ] Health script runs without errors
- [ ] Monitoring containers are healthy
- [ ] Prometheus scrapes Node Exporter
- [ ] Grafana can query Prometheus
- [ ] S3 backup uploads a sample archive
- [ ] No credentials or sensitive data are committed
