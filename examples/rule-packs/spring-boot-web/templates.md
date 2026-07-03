---
keywords: [template, page, view, UI, thymeleaf]
---
# Thymeleaf Template Conventions

> How to structure templates: directory layout, fragment composition, Bootstrap 5, and role-based rendering.

## Rules

- Template directory structure mirrors controller packages:
  - `admin/` — admin-only pages
  - `<domain-role>/` — domain role pages (e.g., `player/`, `user/`)
  - `common/auth/` — login, register
  - `common/profile/` — profile view/edit
  - `error/` — error pages (403, 404, 500, generic)
- Shared fragments live in `fragments/`:
  - `fragments/common/head.html` — common `<head>` content (meta, CSS, JS CDN links, custom CSS)
  - `fragments/navbar/navbar.html` — main navbar that dispatches to role-specific fragments
  - `fragments/navbar/base.html` — nav items for all authenticated users (e.g., Dashboard)
  - `fragments/navbar/admin.html` — admin-specific nav items
  - `fragments/navbar/<role>.html` — domain role nav items
  - `fragments/footer/footer.html` — shared footer
- Fragment inclusion uses `th:replace="~{fragments/navbar/navbar :: navbar('pageName')}"`.
- **Never reimplement navigation, head, or footer inline in page templates.** Always include via fragments. This ensures a single source of truth — changes to navigation happen in one place, not across every page.
- Navbar accepts an `activePage` parameter to highlight the current nav item via `th:classappend`.
- Role-based visibility in templates: `sec:authorize="hasRole('ROLE_ADMIN')"` or `sec:authorize="isAuthenticated()"`.
- URL expressions: `th:href="@{/path}"` — never hardcode URLs.
- Frontend stack: Bootstrap 5 (CDN), FontAwesome (CDN), custom `main.css`.
- Responsive layout: Bootstrap grid (`.container`, `.row`, `.col-lg-*`).
- Flash messages displayed via `th:if="${successMessage}"` / `th:if="${errorMessage}"` with Bootstrap alert classes.
- Forms use `th:action="@{/path}"` with `method="post"`.
- Error pages include the navbar and footer fragments for consistent layout.

## Bootstrap

Create the fragment structure (head, navbar with role-based dispatch, footer) and initial pages: home/landing page with login form, login page, registration page, admin dashboard stub, admin user management page (list with role change and enable/disable), domain role dashboard stub, and error pages (403, 404, 500, generic). Include a minimal `main.css`. Follow the template rules above.

## Example

### Page template

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/extras/spring-security">
<head>
    <th:block th:replace="~{fragments/common/head :: common-head('Page Title')}"></th:block>
</head>
<body>
<div th:replace="~{fragments/navbar/navbar :: navbar('dashboard')}"></div>

<header class="dashboard-header">
    <div class="container">
        <h1 class="display-5 fw-bold">Dashboard</h1>
    </div>
</header>

<main class="container mb-5">
    <!-- Flash messages -->
    <div th:if="${successMessage}" class="alert alert-success" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        <span th:text="${successMessage}"></span>
    </div>
    <div th:if="${errorMessage}" class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        <span th:text="${errorMessage}"></span>
    </div>

    <!-- Page content -->
    <div class="row">
        <div class="col-lg-8">
            <!-- Content here -->
        </div>
    </div>
</main>

<div th:replace="~{fragments/footer/footer :: footer}"></div>
</body>
</html>
```

### Navbar fragment (main dispatcher)

```html
<nav class="navbar navbar-expand-lg navbar-dark bg-dark" th:fragment="navbar(activePage)">
    <div class="container">
        <a class="navbar-brand" th:href="@{/home}">AppName</a>
        <button class="navbar-toggler" data-bs-target="#navbarNav" data-bs-toggle="collapse" type="button">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <th:block sec:authorize="isAuthenticated()"
                          th:replace="~{fragments/navbar/base :: base(${activePage})}"></th:block>
                <th:block sec:authorize="hasRole('ROLE_ADMIN')"
                          th:replace="~{fragments/navbar/admin :: admin(${activePage})}"></th:block>
                <th:block sec:authorize="hasRole('ROLE_USER')"
                          th:replace="~{fragments/navbar/user :: user(${activePage})}"></th:block>
            </ul>
            <ul class="navbar-nav">
                <th:block sec:authorize="!isAuthenticated()">
                    <li class="nav-item">
                        <a class="nav-link" th:classappend="${activePage == 'login' ? 'active' : ''}"
                           th:href="@{/login}">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" th:classappend="${activePage == 'register' ? 'active' : ''}"
                           th:href="@{/register}">Register</a>
                    </li>
                </th:block>
                <th:block sec:authorize="isAuthenticated()">
                    <li class="nav-item">
                        <form th:action="@{/logout}" method="post">
                            <button type="submit" class="nav-link btn btn-link">Logout</button>
                        </form>
                    </li>
                </th:block>
            </ul>
        </div>
    </div>
</nav>
```
