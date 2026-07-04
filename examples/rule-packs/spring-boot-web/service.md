---
keywords: [service, business logic, validation]
---
# Service Layer Conventions

> How to structure business logic: interface + implementation, transactions, validation, and exception handling.

## Rules

- Every service has an interface and a separate implementation class.
- Interface lives in the `service` package. Impl lives in the same package, suffixed with `Impl`.
- Interface methods have JavaDoc with `@param` and `@return` tags.
- Impl is annotated `@Service @RequiredArgsConstructor`. Dependencies are `private final` fields injected via constructor (Lombok generates it).
- Mutating methods: `@Transactional`.
- Read-only methods: `@Transactional(readOnly = true)`.
- Input validation lives in private `validate*()` methods inside the impl — never in controllers.
- Missing entity lookups throw `EntityNotFoundException` with a descriptive message.
- Validation failures throw `IllegalArgumentException` with a user-facing message.
- Use `@Slf4j` (Lombok) for logging. Use `log.atInfo().log(...)` or `log.info(...)` style.
- Entity creation uses the Builder pattern.
- Usernames and emails are normalized to lowercase before storing.

## Bootstrap

Create a `UserService` interface and implementation covering: user registration (with validation, BCrypt encoding, lowercase normalization), lookups by username and ID, existence checks, and admin operations (find all, toggle enabled, update role). Also create a `CustomUserDetailsService` per the security conventions. Follow the service rules above.

## Example

```java
// --- Interface (pattern: JavaDoc with @param/@return on every method) ---

public interface ThingService {

    /** @return the created entity */
    Thing create(ThingDto dto);

    /** @return the entity, or empty if not found */
    Optional<Thing> findById(Long id);

    /** @return true if the name is already taken */
    boolean isNameTaken(String name);
}

// --- Implementation (pattern: @Service + @RequiredArgsConstructor, validation in private methods) ---

@Service
@RequiredArgsConstructor
@Slf4j
public class ThingServiceImpl implements ThingService {

    private final ThingRepository thingRepository;

    @Override
    @Transactional
    public Thing create(ThingDto dto) {
        validateInput(dto);

        Thing thing = Thing.builder()
                .name(dto.getName().trim().toLowerCase())
                .build();

        log.atInfo().log("Creating thing: {}", thing.getName());
        return thingRepository.save(thing);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Thing> findById(Long id) {
        return thingRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isNameTaken(String name) {
        return thingRepository.existsByNameIgnoreCase(name);
    }

    private void validateInput(ThingDto dto) {
        if (dto.getName() == null || dto.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Name is required");
        }
        if (isNameTaken(dto.getName().trim())) {
            throw new IllegalArgumentException("Name is already taken");
        }
    }
}
```
