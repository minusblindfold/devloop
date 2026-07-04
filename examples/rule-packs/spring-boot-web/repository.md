---
keywords: [repository, data access, query]
---
# Repository Conventions

> How to structure Spring Data JPA repositories: interface design, query methods, and return types.

## Rules

- Every repository is an interface extending `JpaRepository<Entity, Long>`.
- Annotate with `@Repository`.
- Prefer Spring Data **derived query methods** (method name generates the query) over `@Query` annotations. Only use `@Query` when the method name would be unreadable or the query requires joins/aggregations that Spring Data can't express.
- Return `Optional<Entity>` for single-entity lookups by non-ID fields (e.g., `findByUsername`). The caller decides how to handle absence.
- Return `boolean` for existence checks: `existsByFieldIgnoreCase(String)`.
- Return `List<Entity>` for multi-result queries. Add ordering to the method name when relevant (e.g., `findByPartyOrderByCreatedAtDesc`).
- Keep repositories thin — no business logic, no default methods with logic. That belongs in the service layer.

## Bootstrap

Create a `UserRepository` with methods for credential lookups: find by username (returning Optional), and existence checks for username and email (case-insensitive). Follow the repository rules above.

## Example

```java
package com.example.app.repository;

import com.example.app.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    boolean existsByUsernameIgnoreCase(String username);

    boolean existsByEmailIgnoreCase(String email);
}
```
