# Overlay & Widget Animation Module Guide

_Last updated: 2025-07-31_

---

## 🎯 Goal

A **modular, extensible, and declarative animation system** for Flutter applications, designed to encapsulate all animation logic in a single, reusable module.

Currently, the module provides:

- **Overlay Animations:** Platform-adaptive entrance and exit animations for overlays (dialogs, snackbars, banners, etc.), powered by injectable `AnimationEngine`s.
- **Widget Animations:** Extension-based, DSL-like helpers for applying composable, local animations directly in the widget tree.

The system is architected for growth—new animation types and engines can be added without changing existing logic, following the open/close principle.
It is framework-agnostic, with no dependency on any state management solution, and is intended for use across projects.
All future animation logic and features should be encapsulated here to ensure consistency, scalability, and maintainability.

---

## 🧩 Animation's module Architecture-&-Flow

### 📦 Files current structure

> Files structure keeps module's codebase easy to maintain or extend.

```
├── Animation module readme.md
│
├── overlays_animation
│   ├── animation_engines
│   │   ├── _animation_engine.dart
│   │   ├── animation_base_engine.dart
│   │   ├── engine_configs.dart
│   │   ├── fallback_engine.dart
│   │   └── platform_based_engines
│   │       ├── _engine_mapper_x_on_context.dart
│   │       ├── android_animation_engine.dart
│   │       └── ios_animation_engine.dart
│   └── animation_wrapper
│       ├── animated_overlay_shell.dart
│       ├── animated_overlay_wrapper.dart
│       └── overlay_animation_x_for_widget.dart
│
└── widget_animation_x.dart
```

---

### Core Principles

- **Contract:** The animation engine contract is a sealed class defining the API that all animation engines must implement.
- **Base engine:** `AnimationBaseEngine` provides shared animation lifecycle logic.
- **Engine configs** — Centralizes animation parameters (duration, curves) by overlay/platform (for consistency and maintainability)
- **Platform aware Engines:** Platform-specific engines (`IOSAnimationEngine`, `AndroidAnimationEngine`) extend the base and provide native-like transitions.
  Right engine calls declaratively via `BuildContext` extension `_engine_mapper_x_on_context.dart`.
- **Fallback engine:** Ensures overlays always animate, even if a platform-specific engine is missing (to prevent errors if config fails).
- **Incapsulated animation lifecycle** The full animation lifecycle of overlays animations (controller initialization, playing 0f entry animation,
  manually or by timeout reverse/dismissal, and disposes as needed) manages by `animation_wrapper/`
- **Open for Extension:** To add new types/styles of animation, implement a new engine—existing code remains untouched (open/close principle).

---

### Overlay Animation FLOW (declarative)

When an overlay (e.g., dialog, snackbar, banner) is triggered using a DSL method like `context.showSnackbar()`, the flow is:

1. **Overlay Request**: The DSL method creates a platform-specific widget (e.g., `IOSAppDialog`, `AndroidSnackbar`)
   and wraps it in an `AnimatedOverlayWrapper`.
2. **Engine Injection**: The wrapper injects the appropriate `AnimationEngine` using the engine mapper (`getEngine(OverlayCategory)`),
   selecting the best-fit for the platform and overlay type.
3. **Animation Lifecycle**: `AnimatedOverlayWrapper` manages the entire animation lifecycle .
4. **Overlay Dispatcher**: Manages the overlay queue. On dismissal (manual or auto), it removes the entry,
   notifies listeners, and optionally triggers the next overlay.

### Simplified Flow

Overlay dispatcher coordinates all queue and lifecycle. When overlay triggered → `AnimatedOverlayWrapper` created,
injects animation engine, that are selected via mapper based on overlay category & platform.
All animation transitions (entry, reverse, dismiss) manages by engine.

---

## 🎬 WidgetAnimationX — Declarative Extension Animations

Provides syntactic sugar for concise, declarative API for animating any widget in place.
All animation helpers are lightweight, composable extension methods that can be chained for complex effects.

**Currently Supported animations:** (can be extended):

- `.fadeIn()` — Opacity fade-in
- `.scaleIn()` — Elastic scale-in
- `.slideInFromBottom()` — Slide up from bottom
- `.slideInFromLeft()` — Slide in from left
- `.rotateIn()` — Rotate in
- `.bounceIn()` — Bouncy scale-in
- `.withAnimatedSwitcherSize()` — Combines AnimatedSwitcher + AnimatedSize for smooth transitions
- `.withSimpleSwitcher()` — Simple AnimatedSwitcher with fade & scale

#### **Basic usage:**

```dart
import '../../core/base_modules/animation/widget_animation_x.dart';

// Fade in any widget
yourWidget.fadeIn();

// Combine multiple animations for complex effects
yourWidget.fadeIn().scaleIn();

// Slide in from bottom
Text('Hello').slideInFromBottom();
```

**Real project usage:**

```dart
// Animated button with smooth loader/text switch and padding
FilledButton(
  onPressed: isEnabled ? onPressed : null,
  child: (isLoading
      ? AppLoader(size: 20)
      : TextWidget(label, ...)
    )
    .withAnimatedSwitcherSize(),
).withPaddingTop(AppSpacing.l);
```

      Widget-level animations are:
      * Stateless
      * Composable (can be chained)
      * Work with any widget tree

---

## ❓ FAQ

> **How do I add a new overlay animation type (for a new overlay category or platform style)?**

1. **(If needed) Extend `ShowAs`** — Add a new overlay category to the `ShowAs` enum:

   ```dart
   enum ShowAs { dialog, banner, snackbar, toast, ... }
   ```

2. **Add config to platform engine** — Register a new config for your overlay type in the appropriate platform engine (e.g., Android/iOS):

   ```dart
   ShowAs.toast => const AndroidOverlayAnimationConfig(...)
   ```

3. **That's it:** Use `.getEngine(OverlayCategory)` — the new animation will be injected automatically based on the new category.

---

> **How do I customize or tweak existing overlay animation behavior?**

- Modify values in `IOSOverlayAnimationConfig` or `AndroidOverlayAnimationConfig` for your overlay type.
- For example:

  ```dart
  IOSOverlayAnimationConfig(
    duration: Duration(milliseconds: 700),
    opacityCurve: Curves.easeIn,
    scaleBegin: 0.85,
    // ... other params
  );
  ```

- You can also tweak engine configs directly for fine-tuned control.

---

> **How can I add or extend widget-level animation extensions?**

- Add a new extension method to `WidgetAnimationX` in `widget_animation_x.dart`.
- For new animation behaviors, implement as a standalone extension (stateless, composable) so it can be chained with others.

---

> **Should I ever modify core/base classes?**

- **No:** Follow the open/close principle — extend, do not modify. Add new engines, configs, or extensions rather than changing base abstractions.

---

## 💡 Tips & Best Practices

- **Usage** Simply copy the animation module folder into your Flutter 😉😎
- **Encapsulate all animation logic:** Never mix animation code with business/UI logic. Use this module as the single source of truth for all app animations.
- **Favor declarative patterns:** Always use extension-based helpers and platform-agnostic configs for readability and reusability.
- **Platform-awareness by default:** Rely on `getEngine(...)` for overlays engines and configs are auto-injected for the current platform.
- **Immutable configs:** Keep animation configs (`engine_configs.dart`) immutable and never hardcode animation values inside engines. This ensures consistency, maintainability, and easier testing.
- **Consistency:** Follow existing code style for all custom engines/configs to keep usage ergonomic and predictable.
- **Follow Open/Close Principle:** To add or modify behavior, create new engine/config/extension files. Never edit the core abstractions or existing engines.
- **Composability:** Chain widget animation extensions (e.g., `.fadeIn().scaleIn()`) for richer effects with clean code.
- **Consistent naming & style:** Stick to the naming conventions already used in this module (e.g., `WidgetAnimationX`, `*Engine`, `*Config`, `getEngine`) to keep the codebase ergonomic and predictable.
- **Unit-test engines/configs in isolation:** Since engines and configs are decoupled, write unit tests for new engines or configs without depending on overlays/widgets.
- **Document new animation behaviors:** Always update the module-level README and engine/config docs for new features or usage patterns.
- **Prefer composition over inheritance:** When extending widget animations, use extensions and composition, not deep widget hierarchies.
- **Combine widget animation extensions:** You can combine multiple animations for more complex effects
- **Keep platform-specific logic isolated:** All platform checks and logic should stay inside engines/configs—not leak into UI/widget code.

---

## ✅ Final Notes

- Single entrypoint for overlay animations: `getEngine(...)`
- One place for platform configs: `engine_configs.dart`
- Lifecycle fully managed via: `AnimatedOverlayWrapper`
- Widget-level animation: `WidgetAnimationX`
- Engines, wrappers, and configs are all fully modular and testable
- Simple to extend, override, or unit-test any animation logic
- Architecture is scalable, decoupled, and DDD/SOLID-compliant

### 🏆 Key Advantages

- **Declarative & config-driven** usage everywhere
- **SOLID-compliant** and clean separation of concerns
- **Native experience** (Android/iOS)
- **Easy extension** for new overlay types, platforms, or widget effects
- **Reusable & fully testable** components
- **Minimal boilerplate** for new features
- **Immutable configs** for safe maintainability
- **Chained, stateless widget animations** for UI clarity

> **Happy coding! 🎬✨**
> Build clean, beautiful, and truly native-feeling animations — declarative by design, scalable by architecture.\*\*

---
