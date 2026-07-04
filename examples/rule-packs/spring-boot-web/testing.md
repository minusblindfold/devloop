---
keywords: [test, testing, unit test, integration test, e2e, mock, assert]
---
# Testing Conventions

> How to test Spring Boot applications: unit tests with mocks, integration tests with H2 + Liquibase, controller tests with MockMvc, and E2E tests with full server.

## Test Profiles

Two test profiles, selected by annotation:

- **Unit tests** — no Spring context. Fast, isolated, mock all dependencies. Default for service and utility tests.
- **Integration / E2E tests** — `@ActiveProfiles("test")` with `application-test.properties`. Spring context loads, Liquibase runs against H2, seed data is available.

### application-test.properties

```properties
spring.datasource.url=jdbc:h2:mem:testdb;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE
spring.datasource.driver-class-name=org.h2.Driver
spring.jpa.hibernate.ddl-auto=none
spring.liquibase.change-log=classpath:db/changelog/db.changelog-master.yaml
spring.docker.compose.enabled=false
```

Key difference from current stack convention: `ddl-auto=none` and Liquibase **enabled**. Migrations run against H2 in PostgreSQL compatibility mode, validating changelogs and providing seed data for integration tests.

## Unit Tests

- Use `@ExtendWith(MockitoExtension.class)` — no Spring context.
- `@Mock` for dependencies, `@InjectMocks` for the class under test.
- Test file naming: `<ClassName>Test.java` in the matching package under `src/test/java/`.
- Focus on: business logic branches, validation rules, edge cases, exception paths.
- Do not test: getters/setters, framework wiring, delegation-only methods.
- One assert concept per test. Multiple asserts are fine if they verify the same behavior.
- Test method naming: `shouldDoExpectedThing_whenCondition` — describes the behavior, not the method name.

## Integration Tests

- Use `@DataJpaTest` for repository tests — loads JPA slice, runs Liquibase, rolls back after each test.
- Use `@WebMvcTest(ControllerName.class)` for controller tests — loads MVC slice, mock services with `@MockBean`.
- Add `@ActiveProfiles("test")` so the test properties load.
- Seed data from Liquibase migrations is available in `@DataJpaTest` — no need to re-insert users or reference data.
- Test file naming: `<ClassName>IntegrationTest.java`.
- Repository tests focus on: custom query methods, constraint violations, relationship cascades.
- Controller tests focus on: HTTP status codes, redirects, security annotations (anonymous vs authenticated vs role-specific), flash attributes, model attributes.

### Controller Security Tests

Use `@WithMockUser(roles = "ADMIN")` or `@WithAnonymousUser` from spring-security-test to verify access control:

```java
@WebMvcTest(AdminUserController.class)
@ActiveProfiles("test")
class AdminUserControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    @Test
    @WithAnonymousUser
    void shouldRedirectToLogin_whenAnonymous() throws Exception {
        mockMvc.perform(get("/admin/users"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void shouldReturnUserList_whenAdmin() throws Exception {
        when(userService.findAll()).thenReturn(List.of());
        mockMvc.perform(get("/admin/users"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/users/list"));
    }
}
```

## E2E Tests

- Use `@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)` with `@ActiveProfiles("test")`.
- Use `TestRestTemplate` (auto-injected) for full HTTP round-trips.
- Test file naming: `<FeatureName>E2ETest.java`.
- Focus on: critical user flows (register → login → access protected page), multi-step operations, cross-controller interactions.
- Keep the E2E suite small — cover happy paths and critical error paths. Leave edge cases to unit and integration tests.

## Test Data Builders

Create builder helpers in a `testutil` package under `src/test/java/` to reduce boilerplate:

```java
package com.example.app.testutil;

import com.example.app.model.Role;
import com.example.app.model.User;

public class TestDataBuilders {

    public static User.UserBuilder aUser() {
        return User.builder()
                .username("testuser")
                .password("encoded-password")
                .email("test@example.com")
                .role(Role.PLAYER)
                .enabled(true);
    }

    public static User.UserBuilder anAdmin() {
        return aUser()
                .username("admin")
                .email("admin@example.com")
                .role(Role.ADMIN);
    }
}
```

Usage: `TestDataBuilders.aUser().username("custom").build()` — override only what matters for the test.

## What to Test at Each Layer

| Layer | Unit test | Integration test | E2E test |
|---|---|---|---|
| Service | Validation logic, business rules, exception paths | — | — |
| Repository | — | Custom queries, constraints, cascades | — |
| Controller | — | Status codes, security, redirects, model attrs | — |
| Migrations | — | Liquibase runs without error (implicit) | — |
| User flows | — | — | Register, login, full CRUD paths |

## Bootstrap

Create a `testutil/TestDataBuilders.java` with `aUser()` and `anAdmin()` builders matching the bootstrapped User entity. Create a `UserServiceTest.java` unit test covering: registration validates input, duplicate username throws, password is encoded. Create an `AdminUserControllerIntegrationTest.java` verifying admin-only access. Update test `application.properties` to enable Liquibase with H2 in PostgreSQL mode per the test profile above.

## Rules

- Never test framework behavior — trust Spring annotations work.
- Never test private methods directly — test through the public API.
- Unit tests must run without Spring context or database.
- Integration tests use `@ActiveProfiles("test")` — never connect to a real database.
- Keep E2E tests minimal — they are slow and brittle. Only test flows that cross multiple layers.
- Test builders live in `testutil/` — never in production source sets.
