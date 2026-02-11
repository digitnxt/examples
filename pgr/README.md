# PGR Module - Backend Developer Guide

A step-by-step tutorial for building a **Public Grievance Redressal (PGR)** microservice on top of the **DIGIT 3.0** platform. By the end of this guide you will have a fully functional Spring Boot service that can create, update, and search citizen service requests — integrated with DIGIT platform services for workflow, notifications, identity, and registry.

## Prerequisites

| Tool | Version / Link |
|------|---------------|
| Git | [Windows](https://git-scm.com/download/win) / [Linux](https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-18-04-quickstart) |
| JDK 17 | [Windows](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html) / [Linux](https://javahelps.com/install-oracle-jdk-17-on-linux) |
| IntelliJ IDEA | [Windows](https://www.jetbrains.com/idea/download/#section=windows) / [Linux](https://www.jetbrains.com/idea/download/#section=linux) |
| OpenAPI Generator CLI | [Installation guide](https://openapi-generator.tech/docs/installation/) |
| Postman | [Windows](https://www.postman.com/downloads/) / [Linux](https://dl.pstmn.io/download/latest/linux64) |
| Docker Engine | >= 24.x |
| Docker Compose | >= 2.x |

## Guide Structure

The guide is split into sequential steps. Each step is a separate Markdown file:

| Step | File | Description |
|------|------|-------------|
| Intro | [Introduction.md](Introduction.md) | Overview of the guide and what you will build |
| 0 | [Step 0: System Setup.md](Step%200%3A%20System%20Setup.md) | Install development tools and set up your environment |
| 0.5 | [Step 0.5: Deploying DIGIT locally.md](Step%200.5%3A%20Deploying%20DIGIT%20locally.md) | Run the DIGIT platform locally with Docker Compose |
| 1 | [Step 1: Configuring DIGIT Service.md](Step%201%3A%20Configuring%20DIGIT%20Service.md) | Use DIGIT CLI to create accounts, users, roles, workflows, and registries |
| 2 | [Step 2: Generate Project.md](Step%202%3A%20Generate%20Project.md) | Generate a Spring Boot project stub from OpenAPI specs |
| 3 | [Step 3: Fill the logic in Controller Layer.md](Step%203%3A%20Fill%20the%20logic%20in%20Controller%20Layer.md) | Implement REST endpoints for create, update, and search |
| 4 | [Step 4: Creating Service Layer.md](Step%204%3A%20Creating%20Service%20Layer.md) | Build the core business logic — enrichment, validation, persistence, and orchestration |
| 5 | [Step 5: Creating Validation Layer.md](Step%205%3A%20Creating%20Validation%20Layer.md) | Add validation against external platform data (boundaries, file store) |
| 6 | [Step 6: Creating Client Layer.md](Step%206%3A%20Creating%20Client%20Layer.md) | Integrate with DIGIT client libraries for workflow, notifications, and more |
| 7 | [Step 7: Run Final Application.md](Step%207%3A%20Run%20Final%20Application.md) | Build, run, and test the completed PGR service |

## Supporting Files

| File | Purpose |
|------|---------|
| [docker-compose.yml](docker-compose.yml) | Docker Compose configuration for running DIGIT locally |
| [pgr2-registry-schema.yaml](pgr2-registry-schema.yaml) | Registry schema definition used in Step 1 |
| `Configure w DIGIT CLI.mp4` | Video walkthrough: configuring DIGIT services via the CLI |
| `Deploy DIGIT w Docker (5).mp4` | Video walkthrough: deploying DIGIT locally with Docker |

## Quick Start

```bash
# 1. Deploy DIGIT locally
docker-compose up -d

# 2. Install DIGIT CLI and configure the platform (Step 1)
digit create-account --name Amaravati --email test@example.com --server https://digit-lts.digit.org

# 3. Generate the Spring Boot project (Step 2)
openapi-generator generate -g spring -i pgr.yaml -o generated-pgr ...

# 4. Implement controller, service, validation, and client layers (Steps 3-6)

# 5. Build and run
mvn clean install
mvn spring-boot:run

# 6. Test the APIs (Step 7)
# Create a service request
curl -X POST http://localhost:8083/citizen-service/create ...
# Search for a service request
curl http://localhost:8083/citizen-service/search?serviceRequestId=<id>
# Update a service request
curl -X POST http://localhost:8083/citizen-service/update ...
```

## Architecture Overview

The PGR module follows a layered architecture:

```
Controller Layer  -->  Service Layer  -->  Registry (persistence)
                            |
                            +--> Validation Layer (boundary, filestore checks)
                            +--> Workflow Client (state transitions)
                            +--> Notification Client (email alerts)
                            +--> IdGen Client (ID generation)
```

- **Controller**: Translates HTTP requests into domain operations, extracts tenant and role info from JWT
- **Service**: Orchestrates the create/update/search lifecycle — ID generation, validation, workflow, persistence
- **Validation**: Checks external platform data (boundaries, file references) before persisting
- **Client**: Wraps DIGIT client libraries (workflow, notifications) into simple method calls
- **Registry**: Replaces direct database access with DIGIT Registry service calls

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/citizen-service/create` | Create a new PGR service request |
| POST | `/citizen-service/update` | Update an existing service request |
| PUT | `/citizen-service/update/{registryId}` | Update a service request by registry ID |
| GET | `/citizen-service/search?serviceRequestId=` | Search for a service request by ID |

## References

- [DIGIT 3.0 Repository](https://github.com/digitnxt/digit3)
- [PGR Module Source](https://github.com/digitnxt/digit3/tree/11b02a69a501282acceea9c93172ff584025c12a/pgrown3.0_copy)
- [DIGIT CLI](https://github.com/digitnxt/digit3/tree/de5d714c59919e61e68a83072badde6f4b2a0ae4/tools/digit-cli)
- [DIGIT Client Library](https://github.com/digitnxt/digit3/tree/de5d714c59919e61e68a83072badde6f4b2a0ae4/src/libraries/digit-client)
- [DIGIT Design Guide](https://docs.digit.org/platform/guides/design-guide)
- [PGR OpenAPI Specs](https://github.com/digitnxt/digit3/blob/77dc0285b094a19966b0f3e4edb8480f96571a06/PGR-specs.yaml)
