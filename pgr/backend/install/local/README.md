# DIGIT 3.0 - Docker Compose Setup

This repository allows you to run the complete **DIGIT 3.0 core stack** locally using Docker Compose.

---

## Prerequisites

Ensure the following are installed on your machine:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: Comes with Docker Desktop.

## Clone the Repo

```bash
git clone https://github.com/digitnxt/examples.git
```

```bash
cd pgr/backend/install/local
```

## Spin up Digit 3.0

```bash
docker compose up -d
```
## Cleanup commands after using

```bash
docker compose down -v
```

## delete/cleanup the volumes using below commands

```bash
docker compose down --volumes --remove-orphans
```

```bash
docker system prune -f --volumes (be careful as this removes all unused containers, images, volumes)
```




