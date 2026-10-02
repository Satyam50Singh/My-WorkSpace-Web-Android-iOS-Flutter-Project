# my_worksphere_web

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Command to bypass the CORS Policy

```
open -na "Google Chrome" --args --disable-web-security --user-data-dir="/tmp/chrome-dev"
```


## Questions or Concepts (Interview Preparation)

### 1. Flutter Navigation & GoRouter
- **Future vs Stream**: Where and why would you use a `Future` vs a `Stream` in Flutter?
- **`go()` vs `push()` in GoRouter**: What is the difference between `context.go()` and `context.push()`, and how do they affect the route history stack?
- **`goNamed()` vs `pushNamed()`**: What are the advantages of using named routes with path/query parameters over raw URL string paths?
- **Returning Data with `pop()`**: How do you pass data back from a popped page to its parent (`context.pop(data)`), and how does the parent handle `await context.push<T>()`?
- **`context.pop()` vs `Navigator.of(context).pop()`**: Why can `context.canPop()` return `false` inside a `ShellRoute`, and when should `Navigator.of(context).canPop()` / `Navigator.of(context).pop()` be used (e.g. dialogs, root navigator pop)?
- **`ShellRoute` in GoRouter**: How does `ShellRoute` enable persistent UI elements like a Web Sidebar / Drawer while navigating child routes?

### 2. State Management (BLoC & Cubit)
- **`BlocBuilder` vs `BlocListener` vs `BlocConsumer`**: When should you use each, and why is `BlocConsumer` best suited when combining UI rendering with side-effects (like showing snackbars or progress dialogs)?
- **`buildWhen` & `listenWhen`**: How do `buildWhen` and `listenWhen` optimize widget rebuilds and side-effect executions?
- **`Bloc` vs `Cubit`**: What is the difference between an event-driven `Bloc` and a function-driven `Cubit`, and when should you choose one over the other?
- **Handling Global Progress Loaders in BLoC**: How do you manage showing and hiding a global loading modal (`showDialog` with `useRootNavigator: true`) during BLoC state changes without breaking screen pop navigation on success?

### 3. Architecture & Dependency Injection (Clean Architecture, GetIt, Dartz)
- **Clean Architecture Layers**: How are Data (DataSources, Models), Domain (Entities, Repositories, UseCases), and Presentation (Pages, BLoCs) layers organized in this project?
- **Functional Error Handling with `dartz`**: How does `Either<Failure, Success>` prevent unhandled exceptions across repository and presentation layers?
- **Dependency Injection with `get_it`**: What is the difference between `registerFactory`, `registerLazySingleton`, and `registerSingleton` in GetIt, and when should each be used?

### 4. Cross-Platform Development (Flutter Web vs Native Mobile)
- **Platform-Specific Logic (`kIsWeb`)**: How do you handle code that behaves differently on Web vs Native Mobile without triggering platform import crashes (e.g., `dart:io` vs `Uint8List`)?
- **Cross-Platform File & Image Uploads**: How do image selection and multipart request payloads differ on Mobile (`File` path) vs Web (`Uint8List` bytes), and how does `FormData` / `AppMultipartFile` bridge this difference?
- **Responsive Web & Mobile Layouts**: How do `MediaQuery.sizeOf(context).width`, `LayoutBuilder`, and `Constraints` help build adaptive UIs for Mobile, Tablet, and Desktop?

### 5. Networking & Utilities (Dio, Permissions, File Export)
- **Dio Interceptors & Environment Security**: How do Dio interceptors manage headers, auth tokens, and logging, and how is environment configuration managed via `flutter_dotenv`?
- **Excel Data Export**: How do you construct and export Excel files on Web and Mobile using packages like `syncfusion_flutter_xlsio`?
- **Runtime Permissions**: How do you request Camera and Storage/Gallery permissions dynamically using `permission_handler` before accessing hardware APIs?

# GoRouter Navigation Cheat Sheet

## Navigation Methods

| Method                          | Meaning                       | Use When                                                      | Example                        |
| ------------------------------- | ----------------------------- | ------------------------------------------------------------- | ------------------------------ |
| `context.go()`                  | **Jump to a route**           | Moving between main/top-level pages                           | `context.go('/dashboard')`     |
| `context.goNamed()`             | **Jump to a named route**     | Same as `go()`, but using a route name                        | `context.goNamed('dashboard')` |
| `context.push()`                | **Open a new page on top**    | List → Details, Parent → Child                                | `context.push('/details')`     |
| `context.pushNamed()`           | **Push a named route**        | Same as `push()`, with named routes/parameters                | `context.pushNamed('details')` |
| `context.pop()`                 | **Go back one route**         | Returning from a page opened with `push()`                    | `context.pop()`                |
| `context.pop(value)`            | **Go back + return data**     | Child needs to tell the parent something happened             | `context.pop(true)`            |
| `Navigator.pop()`               | **Close a Navigator route**   | Mainly dialogs, bottom sheets, or legacy Navigator navigation | `Navigator.of(context).pop()`  |
| `Navigator.pop(context, value)` | **Close route + return data** | Dialog needs to return a result                               | `Navigator.pop(context, true)` |

---

## 🧠 Easy Rule to Remember

```text
GO     = JUMP
PUSH   = OPEN
POP    = BACK
```

---

## Typical App Navigation

```text
Sidebar
   │
   │ context.goNamed()
   ▼
My Actions
   │
   │ context.pushNamed()
   ▼
Ticket Details
   │
   │ context.pop()
   ▼
My Actions
```

### Example

```dart
// Navigate from My Actions → Ticket Details
context.pushNamed(
  'view-ticket-details',
  pathParameters: {
    'ticketId': ticketId,
  },
);

// Go back from Ticket Details → My Actions
context.pop();
```

---

## `go()` vs `push()`

### Use `go()` for top-level navigation

```dart
context.goNamed('dashboard');
```

Think:

```text
Login
  ↓
Dashboard
  ↓
My Tickets
  ↓
My Actions
```

These are independent **top-level destinations**.

---

### Use `push()` for child/detail navigation

```dart
context.pushNamed('view-ticket-details');
```

Think:

```text
My Actions
    ↓
Ticket Details
```

The previous page remains underneath the detail page.

---

## Returning Data with `pop()`

A child page can send a result back to its parent.

### Child

```dart
context.pop(true);
```

### Parent

```dart
final shouldRefresh = await context.pushNamed<bool>(
  'view-ticket-details',
);

if (shouldRefresh == true) {
  _fetchTicketDetails();
}
```

This is useful when:

* A ticket was updated
* A record was deleted
* A form was submitted
* A profile was edited
* The parent list needs to refresh

---

## `context.pop()` vs `Navigator.pop()`

### Use `context.pop()` for GoRouter pages

```dart
context.pushNamed('ticket-details');

// Later
context.pop();
```

### Use `Navigator.pop()` mainly for dialogs

```dart
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Delete Ticket'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  },
);
```

Think:

```text
GoRouter
    │
    ├── My Actions
    │
    └── Ticket Details
            │
            └── Dialog
                  │
                  └── Navigator.pop()
```

---

# ⭐ Golden Rule

> **If you used `push` to open it, use `pop` to come back.**

```dart
// OPEN
context.pushNamed('view-ticket-details');

// GO BACK
context.pop();
```

And:

> **Don't use `go()` as a replacement for `pop()`.**

```text
go()  → "Take me to this route"
pop() → "Take me back to where I came from"
```

---

## Quick Decision Table

| Situation                           | Use                             |
| ----------------------------------- | ------------------------------- |
| Open Dashboard from Sidebar         | `go()` / `goNamed()`            |
| Open My Tickets from Sidebar        | `go()` / `goNamed()`            |
| Open Ticket Details from My Tickets | `push()` / `pushNamed()`        |
| Go back from Ticket Details         | `pop()`                         |
| Return data from Ticket Details     | `pop(value)`                    |
| Close a Dialog                      | `Navigator.pop()`               |
| Return data from a Dialog           | `Navigator.pop(context, value)` |

---

## One-Line Memory Trick

```text
GO = JUMP TO A DESTINATION
PUSH = OPEN A CHILD PAGE
POP = RETURN TO PREVIOUS PAGE
NAVIGATOR.POP = CLOSE A DIALOG / NAVIGATOR ROUTE
```
