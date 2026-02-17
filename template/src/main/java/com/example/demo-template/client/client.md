# Client Folder Template Guide

This document provides a template and guidelines for adding new client classes to the `src/main/java/com/example/demo-template/client/` folder.

## Overview

The client folder contains wrapper classes that encapsulate external service interactions. These classes serve as a facade layer between your business logic and external APIs, reducing complexity in service layers and providing centralized error handling.

## Example Client Classes for PGR

- `NotificationServiceClient.java` - Handles email notifications
- `WorkflowServiceClient.java` - Manages workflow transitions and state management

## Template for New Client Classes

### Basic Structure

```java
package com.example.pgrown30.client;

import [required imports];
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Value;

/**
 * Wrapper class for [SERVICE_NAME]-related operations.
 * Encapsulates [SERVICE_NAME] client interactions to reduce clutter in service layer.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class [ServiceName]Client {

    private final [ExternalClient] [externalClient];

    @Value("${[config.property]}")
    private String configProperty;

    /**
     * [Method description]
     *
     * @param [parameter] [parameter description]
     * @return [return description]
     */
    public [ReturnType] [methodName]([Parameters]) {
        try {
            // Implementation logic
            log.info("Successfully executed [operation] for [identifier]");
            return result;
        } catch (Exception ex) {
            log.error("Failed to [operation] for [identifier]: {}", ex.getMessage(), ex);
            throw new RuntimeException("[Operation] failed", ex);
        }
    }
}
```

## Guidelines for New Client Classes

### 1. Naming Convention
- Class name should end with `Client` (e.g., `PaymentServiceClient`, `UserServiceClient`)
- Use descriptive names that clearly indicate the external service being wrapped

### 2. Required Annotations
- `@Slf4j` - For logging capabilities
- `@Component` - For Spring dependency injection
- `@RequiredArgsConstructor` - For constructor injection via Lombok

### 3. Constructor Injection
- Use `private final` fields for dependencies
- Let Lombok generate the constructor with `@RequiredArgsConstructor`

### 4. Configuration Properties
- Use `@Value` annotation for configuration properties
- Follow the pattern: `${service.property.name}`

### 5. Error Handling
- Always wrap external service calls in try-catch blocks
- Log errors with appropriate context
- Throw meaningful exceptions with descriptive messages

### 6. Logging
- Log successful operations at INFO level
- Log errors at ERROR level with full context
- Include relevant identifiers (IDs, request numbers, etc.)

### 7. Method Documentation
- Use JavaDoc comments for all public methods
- Document parameters, return values, and exceptions
- Explain the business purpose of each method

## Common Client Types to Add

### 1. Payment Service Client
```java
/**
 * Wrapper class for payment-related operations.
 * Handles payment processing, refunds, and transaction status checks.
 */
public class PaymentServiceClient {
    // Methods: processPayment, refundPayment, getTransactionStatus
}
```

### 2. User Management Client
```java
/**
 * Wrapper class for user management operations.
 * Handles user authentication, profile management, and role assignments.
 */
public class UserManagementClient {
    // Methods: authenticateUser, getUserProfile, assignRole
}
```

### 3. Document Service Client
```java
/**
 * Wrapper class for document management operations.
 * Handles document upload, retrieval, and validation.
 */
public class DocumentServiceClient {
    // Methods: uploadDocument, retrieveDocument, validateDocument
}
```

### 4. Audit Service Client
```java
/**
 * Wrapper class for audit logging operations.
 * Handles audit trail creation and retrieval.
 */
public class AuditServiceClient {
    // Methods: logAuditEvent, getAuditTrail, searchAuditLogs
}
```

## Configuration Requirements

### Application Properties
Add corresponding configuration properties in `application.properties`:

```properties
# [Service Name] Configuration
[service.name].base.url=https://api.example.com
[service.name].api.key=${API_KEY}
[service.name].timeout=30000
[service.name].retry.attempts=3
```

### Dependencies
Ensure required dependencies are added to `pom.xml`:

```xml
<dependency>
    <groupId>org.example</groupId>
    <artifactId>[external-service-client]</artifactId>
    <version>[version]</version>
</dependency>
```

## Best Practices

1. **Single Responsibility**: Each client should handle only one external service
2. **Fail Fast**: Validate inputs early and provide clear error messages
3. **Idempotency**: Design methods to be safely retryable when possible
4. **Circuit Breaker**: Consider implementing circuit breaker pattern for resilience
5. **Caching**: Implement caching for frequently accessed, slowly changing data
6. **Monitoring**: Add metrics and health checks for external service dependencies

## Testing

Create corresponding test classes in `src/test/java/com/example/pgrown30/client/`:

```java
@ExtendWith(MockitoExtension.class)
class [ServiceName]ClientTest {
    
    @Mock
    private [ExternalClient] externalClient;
    
    @InjectMocks
    private [ServiceName]Client serviceClient;
    
    @Test
    void should[ExpectedBehavior]_when[Condition]() {
        // Test implementation
    }
}
```

## Integration with Service Layer

Client classes should be injected into service implementations:

```java
@Service
@RequiredArgsConstructor
public class SomeServiceImpl implements SomeService {
    
    private final [ServiceName]Client serviceClient;
    
    public void businessMethod() {
        // Use client for external service calls
        serviceClient.performOperation();
    }
}
```


