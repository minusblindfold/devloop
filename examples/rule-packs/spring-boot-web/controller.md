---
keywords: [controller, endpoint, route, handler]
---
# Controller Conventions

> How to structure Spring MVC controllers: package layout, authorization guards, redirect patterns, and flash messages.

## Rules

- Controller packages mirror roles: `controller/admin/`, `controller/<domain-role>/`, `controller/common/`, `controller/common/auth/`, `controller/common/error/`.
- Use `@RequiredArgsConstructor` for dependency injection — no `@Autowired` on fields.
- Get the current user via `@AuthenticationPrincipal UserDetails userDetails`, then look up the full User entity from the service.
- Every handler that operates on an owned or member-restricted resource starts with:
  1. Look up the entity (return redirect if not found).
  2. Check the current user has access (membership, ownership, or role).
  3. Redirect with an error flash attribute if access denied.
- **Never perform mutations (save, delete, update) before completing access checks.** All guards must pass before any state-changing work happens. This applies to both GET and POST handlers.
- Use `RedirectAttributes` for flash messages — `addFlashAttribute("successMessage", ...)` and `addFlashAttribute("errorMessage", ...)`.
- Redirect URLs are built inline: `"redirect:/player/things/" + thingId`.
- AJAX endpoints use `@ResponseBody` and return simple strings ("success", "error", "max-reached").
- When a controller bean name would conflict across packages (e.g., multiple `DashboardController`), use `@Controller("specificName")`.
- Use `@Slf4j` for logging. Log errors with context: `log.atError().log("Action failed for user: {}. Reason: {}", username, e.getMessage())`.

## Bootstrap

Create the controller package structure mirroring roles. Include: an `AuthController` (home, login, register flows), a `DashboardController` that redirects by role, a `CustomErrorController` for HTML + JSON error handling, a `GlobalControllerAdvice` for exception handling with flash messages, admin controllers for user management (list, toggle enabled, change role), and a stub dashboard controller for the domain role. Follow the controller rules above.

## Example

```java
// Pattern: guard-first handler — lookup, access check, then action.

@GetMapping("/{id}")
public String view(@PathVariable Long id,
                   @AuthenticationPrincipal UserDetails userDetails,
                   RedirectAttributes redirectAttributes, Model model) {
    // 1. Look up entity
    var entity = service.findById(id).orElse(null);
    if (entity == null) {
        redirectAttributes.addFlashAttribute("errorMessage", "Not found.");
        return "redirect:/dashboard";
    }

    // 2. Check access
    User user = userService.findByUsername(userDetails.getUsername()).orElseThrow();
    if (!entity.getOwner().equals(user)) {
        redirectAttributes.addFlashAttribute("errorMessage", "Access denied.");
        return "redirect:/dashboard";
    }

    // 3. Render
    model.addAttribute("entity", entity);
    return "role/entities/view";
}

@PostMapping("/{id}/delete")
public String delete(@PathVariable Long id,
                     @AuthenticationPrincipal UserDetails userDetails,
                     RedirectAttributes redirectAttributes) {
    // 1. Look up
    var entity = service.findById(id).orElse(null);
    if (entity == null) {
        redirectAttributes.addFlashAttribute("errorMessage", "Not found.");
        return "redirect:/dashboard";
    }

    // 2. Check access BEFORE any mutation
    User user = userService.findByUsername(userDetails.getUsername()).orElseThrow();
    if (!entity.getOwner().equals(user)) {
        redirectAttributes.addFlashAttribute("errorMessage", "Access denied.");
        return "redirect:/dashboard";
    }

    // 3. Now safe to mutate
    service.delete(entity);
    redirectAttributes.addFlashAttribute("successMessage", "Deleted.");
    return "redirect:/role/entities";
}
```
