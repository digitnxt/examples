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
cd pgr/backend/install/local

## Spin up Digit 3.0

docker compose up -d

## Cleanup

docker compose down -v

```
delete the volumes if you face migration issues. It might fail if there is network issue, do a cleanup using below command in that case too and try "docker compose up -d" again:
```
docker system prune -f --volumes (⚠️ be cautious — this removes all unused containers, images, volumes)
docker compose down --volumes --remove-orphans(If you do not want to remove everything)



