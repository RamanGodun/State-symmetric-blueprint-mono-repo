# 🧠 Overlay Conflict Resolution & Interaction Policy

This document explains the **Overlay Conflict Strategy**, **Dismissal Policy**, and **Interaction Behavior** used
in the current Flutter application. It reflects the latest implementation of the overlay system,
built with centralized dispatching, animation engines, and debounced queuing.

---

## 🧩 System Architecture Overview

The overlay flow is orchestrated through these layers:

- `OverlayDispatcher`: manages queue, conflict resolution, entry lifecycle
- `OverlayUIEntry`: abstract entry (Dialog/Banner/Snackbar), describes strategy, dismissibility
- `AnimatedOverlayWrapper`: handles animation and auto-dismiss
- `TapThroughOverlayBarrier`: enables interaction pass-through
- `OverlayStatuscubit`: provides `isOverlayActive` signal for UI logic

Each overlay request is enqueued and inserted via `context.addOverlayRequest(...)`. Final rendering passes through:

```dart
OverlayEntry(
  builder: (context) => TapThroughOverlayBarrier(
    enablePassthrough: true | false,
    onTapOverlay: () => dismiss(),
    child: AnimatedOverlayWrapper(...),
  ),
);
```

---

## 🧭 Conflict Strategy Resolution

Each `OverlayUIEntry` defines a `OverlayConflictStrategy`, which controls whether it:

- **Replaces** the current overlay
- **Waits** until the current one is dismissed
- **Is ignored** if duplicate

### `OverlayConflictStrategy`

```dart
OverlayConflictStrategy(
  priority: OverlayPriority.high,
  policy: OverlayReplacePolicy.forceIfLowerPriority,
  category: OverlayCategory.dialog,
);
```

### 🔺 `OverlayPriority`

| Priority     | Purpose                       |
| ------------ | ----------------------------- |
| `userDriven` | Voluntary actions (e.g. info) |
| `normal`     | Default UX overlays           |
| `high`       | Errors, required user actions |
| `critical`   | Blocking critical UI          |

### 🔁 `OverlayReplacePolicy`

| Policy                 | Behavior Description                                          |
| ---------------------- | ------------------------------------------------------------- |
| `forceReplace`         | Always replaces any active overlay                            |
| `forceIfSameCategory`  | Replaces current if both are same category (e.g. two dialogs) |
| `forceIfLowerPriority` | Replaces only if new overlay has **higher** priority          |
| `dropIfSameType`       | Silently skips if same overlay type already visible           |
| `waitQueue`            | Queues until current one is dismissed                         |

---

## 🔄 Queue Management Logic

1. New overlay request arrives via `dispatcher.enqueueRequest(...)`
2. If no active overlay → it’s shown immediately
3. If active overlay exists → conflict policy is checked
4. Based on result:
   - ✅ Replaced immediately (force)
   - ⏳ Debounced & queued
   - 🚫 Dropped silently

---

## 🧼 Dismissal Policy

Dismiss control is defined via `OverlayDismissPolicy`:

| Policy        | Description                                 |
| ------------- | ------------------------------------------- |
| `dismissible` | User can tap outside to close the overlay   |
| `persistent`  | Overlay can only be closed programmatically |

### Mapping

```dart
OverlayPolicyResolver.resolveDismissPolicy(bool isDismissible)
```

Used consistently in Dialog/Banner/Snackbar APIs.

---

## 🫥 Tap-Through Barrier Support (`TapThroughOverlayBarrier`)

All overlays are wrapped inside `TapThroughOverlayBarrier`, which allows or blocks user interaction
with the UI beneath, based on `tapPassthroughEnabled`:

```dart
@override
bool get tapPassthroughEnabled => true; // for banners/snackbars
```

| Component | Passthrough | Use Case                 |
| --------- | ----------- | ------------------------ |
| Banner    | ✅          | User can continue typing |
| Snackbar  | ✅          | Non-blocking info        |
| Dialog    | ❌          | Blocks interaction       |

When `tapPassthroughEnabled = true`, interaction (e.g., button clicks) **is allowed through** the overlay layer.
Otherwise, overlay acts as modal.

---

## ⏱️ Debounce Mechanism

Debouncing ensures overlays aren’t spammed too frequently. Applied per category via `OverlayPolicyResolver.getDebouncer(...)`:

| Category   | Debounce Duration |
| ---------- | ----------------- |
| `banner`   | 500 ms            |
| `snackbar` | 400 ms            |
| `dialog`   | 0 ms (instant)    |

Each category has its own `Debouncer` instance to avoid race conditions across unrelated overlay types.

---

## 🔁 AutoDismiss Behavior

- Handled inside `AnimatedOverlayWrapper`
- Configurable via `displayDuration`
- On timeout: calls `OverlayDispatcher.dismissCurrent()`
- `OverlayUIEntry.onAutoDismissed()` can be overridden for cleanup

---

## 📶 UI Interaction With OverlayStatuscubit

To block actions (like form submission) while an overlay is active:

```dart
final isOverlayActive = context.select<OverlayStatuscubit, bool>((c) => c.state);
```

This is especially useful for disabling buttons (e.g. `SignUp`) during transitions.

---

## ✅ Summary

| Feature             | Behavior                                                    |
| ------------------- | ----------------------------------------------------------- |
| Conflict resolution | Centralized per overlay type via strategy                   |
| Dismissibility      | Controlled via policy, passed from API to overlay entry     |
| Debounce            | Ensures overlays aren’t triggered too frequently            |
| Tap-through         | Enabled selectively (banners/snackbars), blocked in dialogs |
| Auto-dismiss        | Declarative timeout via AnimatedOverlayWrapper              |
| Status sync         | `OverlayStatuscubit` used to reflect visibility in UI logic |

---

## 🧪 Recommendation

> This architecture supports high modularity, platform adaptation, animation decoupling, and consistent UX behavior.
> All new overlays must define a conflict strategy and be wrapped in `AnimatedOverlayWrapper` for lifecycle consistency.
