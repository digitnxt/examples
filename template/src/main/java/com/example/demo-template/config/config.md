# Config Folder Template Guide

This document provides a template and guidelines for adding new configuration classes to the `src/main/java/com/example/demo-template/config/` folder.

## Overview

The config folder contains Spring configuration classes that define beans, security settings, and integration configurations. These classes are responsible for application-wide setup, dependency wiring, and framework integrations.

## Example Configuration Classes for PGR

- `DigitClientConfig.java` - Configures Digit Client Library integration
- `SecurityConfig.java` - Configures OAuth2 JWT authentication and authorization

## Template for New Configuration Classes

### Basic Structure

```java
package com.example.pgrown30.config;

import [required imports];
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.annotation.Value;

/**
 * Configuration class for [FEATURE_NAME].
 * [Brief description of what this configuration provides]
 */
@Configuration
public class [FeatureName]Config {

    @Value("${[config.property]}")
    private String configProperty;

    /**
     * [Bean description]
     *
     * @return [return description]
     */
    @Bean
    public [BeanType] [beanName]() {
        // Bean initialization logic
        return new [BeanType]();
    }
}
```

## Common Configuration Types

### 1. Database Configuration

```java
package com.example.pgrown30.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * Configuration class for database connection pooling.
 * Configures HikariCP data source with custom settings.
 */
@Configuration
public class DatabaseConfig {

    @Value("${spring.datasource.url}")
    private String jdbcUrl;

    @Value("${spring.datasource.username}")
    private String username;

    @Value("${spring.datasource.password}")
    private String password;

    @Value("${spring.datasource.hikari.maximum-pool-size:10}")
    private int maxPoolSize;

    @Bean
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(username);
        config.setPassword(password);
        config.setMaximumPoolSize(maxPoolSize);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        
        return new HikariDataSource(config);
    }
}
```

### 2. REST Template Configuration

```java
package com.example.pgrown30.config;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

/**
 * Configuration class for RestTemplate beans.
 * Provides configured RestTemplate instances for external API calls.
 */
@Configuration
public class RestTemplateConfig {

    /**
     * Creates a RestTemplate with timeout and interceptor configurations.
     *
     * @param builder RestTemplateBuilder provided by Spring Boot
     * @return configured RestTemplate instance
     */
    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
                .setConnectTimeout(Duration.ofSeconds(10))
                .setReadTimeout(Duration.ofSeconds(30))
                .interceptors(loggingInterceptor())
                .build();
    }

    /**
     * Request/response logging interceptor.
     *
     * @return ClientHttpRequestInterceptor for logging
     */
    @Bean
    public ClientHttpRequestInterceptor loggingInterceptor() {
        return (request, body, execution) -> {
            // Add logging logic
            return execution.execute(request, body);
        };
    }
}
```

### 3. Async Configuration

```java
package com.example.pgrown30.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * Configuration class for asynchronous task execution.
 * Enables @Async annotation support with custom thread pool.
 */
@Configuration
@EnableAsync
public class AsyncConfig {

    /**
     * Creates a thread pool executor for async operations.
     *
     * @return configured Executor
     */
    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-");
        executor.initialize();
        return executor;
    }
}
```

### 4. Caching Configuration

```java
package com.example.pgrown30.config;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for application caching.
 * Enables Spring Cache abstraction with in-memory cache manager.
 */
@Configuration
@EnableCaching
public class CacheConfig {

    /**
     * Creates a simple in-memory cache manager.
     *
     * @return CacheManager instance
     */
    @Bean
    public CacheManager cacheManager() {
        return new ConcurrentMapCacheManager("services", "users", "tenants");
    }
}
```

### 5. Jackson/JSON Configuration

```java
package com.example.pgrown30.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

/**
 * Configuration class for JSON serialization/deserialization.
 * Customizes ObjectMapper with specific settings.
 */
@Configuration
public class JacksonConfig {

    /**
     * Creates a customized ObjectMapper bean.
     *
     * @param builder Jackson2ObjectMapperBuilder
     * @return configured ObjectMapper
     */
    @Bean
    public ObjectMapper objectMapper(Jackson2ObjectMapperBuilder builder) {
        ObjectMapper mapper = builder.build();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
        return mapper;
    }
}
```

### 6. Scheduling Configuration

```java
package com.example.pgrown30.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Configuration class for scheduled tasks.
 * Enables @Scheduled annotation support.
 */
@Configuration
@EnableScheduling
public class SchedulingConfig {
    // Additional scheduling configuration can be added here
}
```

### 7. CORS Configuration

```java
package com.example.pgrown30.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;

/**
 * Configuration class for Cross-Origin Resource Sharing (CORS).
 * Defines allowed origins, methods, and headers.
 */
@Configuration
public class CorsConfig {

    @Value("${cors.allowed.origins:*}")
    private String[] allowedOrigins;

    /**
     * Creates CORS filter with configured settings.
     *
     * @return CorsFilter bean
     */
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(Arrays.asList(allowedOrigins));
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        config.setAllowedHeaders(Arrays.asList("*"));
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);

        return new CorsFilter(source);
    }
}
```

### 8. Validation Configuration

```java
package com.example.pgrown30.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import jakarta.validation.Validator;

/**
 * Configuration class for Bean Validation.
 * Configures JSR-380 validator.
 */
@Configuration
public class ValidationConfig {

    /**
     * Creates a validator factory bean.
     *
     * @return Validator instance
     */
    @Bean
    public Validator validator() {
        return new LocalValidatorFactoryBean();
    }
}
```

## Guidelines for Configuration Classes

### 1. Naming Convention
- Class name should end with `Config` (e.g., `DatabaseConfig`, `SecurityConfig`)
- Use descriptive names that indicate the feature being configured

### 2. Required Annotations
- `@Configuration` - Marks the class as a configuration class
- `@Bean` - Defines methods that return Spring-managed beans
- Additional annotations based on purpose:
  - `@EnableAsync` - For async support
  - `@EnableCaching` - For caching support
  - `@EnableScheduling` - For scheduled tasks
  - `@Import` - To import other configurations

### 3. Configuration Properties
- Use `@Value` for simple property injection
- Consider `@ConfigurationProperties` for grouped properties
- Provide sensible defaults using `${property:defaultValue}` syntax

### 4. Bean Definition Best Practices
- Use method names that clearly describe the bean
- Add JavaDoc comments explaining the bean's purpose
- Consider bean lifecycle (init/destroy methods) when needed
- Use `@Qualifier` when multiple beans of same type exist

### 5. Conditional Configuration
Use conditional annotations when appropriate:
```java
@ConditionalOnProperty(name = "feature.enabled", havingValue = "true")
@ConditionalOnClass(SomeClass.class)
@ConditionalOnMissingBean(SomeBean.class)
```

### 6. Profile-Specific Configuration
```java
@Configuration
@Profile("production")
public class ProductionConfig {
    // Production-specific beans
}
```

## Configuration Properties File

Add corresponding properties in `src/main/resources/application.properties`:

```properties
# [Feature Name] Configuration
[feature.name].enabled=true
[feature.name].property=value
[feature.name].timeout=30000

# Profile-specific properties can be in application-{profile}.properties
```

## Common Configuration Patterns

### Import External Configurations
```java
@Configuration
@Import({SecurityConfig.class, DatabaseConfig.class})
public class AppConfig {
}
```

### Conditional Bean Creation
```java
@Bean
@ConditionalOnProperty(name = "cache.enabled", havingValue = "true")
public CacheManager cacheManager() {
    return new ConcurrentMapCacheManager();
}
```

### Primary Bean Definition
```java
@Bean
@Primary
public DataSource primaryDataSource() {
    return new HikariDataSource();
}
```

## Testing Configuration Classes

Create test classes in `src/test/java/com/example/pgrown30/config/`:

```java
@SpringBootTest
class [FeatureName]ConfigTest {

    @Autowired
    private ApplicationContext context;

    @Test
    void shouldLoadConfiguration() {
        assertNotNull(context);
    }

    @Test
    void shouldCreateRequiredBeans() {
        assertNotNull(context.getBean([BeanType].class));
    }
}
```

## Security Considerations

1. Never hardcode sensitive values (passwords, API keys)
2. Use environment variables or secure vaults for secrets
3. Validate configuration values at startup
4. Use appropriate access modifiers for configuration methods
5. Consider encryption for sensitive configuration data

## Best Practices

1. **Single Responsibility**: Each config class should configure one feature area
2. **Externalize Configuration**: Use properties files for environment-specific values
3. **Documentation**: Add clear JavaDoc for all beans and configuration classes
4. **Fail Fast**: Validate required properties at startup
5. **Testability**: Make configurations testable with appropriate test profiles
6. **Modularity**: Split large configurations into smaller, focused classes
7. **Defaults**: Provide sensible defaults for optional properties

## Integration with Application

Configuration classes are automatically detected by Spring's component scanning:

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        // All @Configuration classes are automatically loaded
    }
}
```

---

**Note**: This template follows Spring Boot best practices and the patterns established in the existing codebase. Adapt specific implementations based on your application requirements and Spring Boot version.
