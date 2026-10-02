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


## Questions or Concepts

- Future vs Stream - where to use ?
- goNamed vs pushNamed with GoRouter

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
