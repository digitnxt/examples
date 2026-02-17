# DIGIT 3.0 - Docker Compose Setup

This repository allows you to run the complete **DIGIT 3.0 core stack** locally using Docker Compose. It includes all essential services.

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
NOTE:Continue with the next steps only after Docker containers are fully up and healthy.If you face any issues, clean up volumes and retry.There may be port conflicts if any required ports are already in use on your local machine.Free up the conflicting ports and run the setup again in such cases.

## Cleanup commands at the end to free up memory

```bash
docker compose down -v
```

## delete/cleanup the volumes using below commands

```bash
docker compose down --volumes --remove-orphans
```
