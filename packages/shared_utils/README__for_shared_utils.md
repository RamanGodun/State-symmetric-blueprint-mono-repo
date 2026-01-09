# 🛠️ Shared Utils

_Last updated: 2025-08-01_

---

## 🎯 Purpose

This package provides **shared utility functions and helpers** for all applications in the monorepo. It contains common utilities, extensions, helpers, and pure functions that are reusable across multiple apps, promoting code reuse and consistency.

---

## 📦 Package Structure

```
shared_utils/
├── lib/
│   ├── shared_utils.dart                # Main library export file
│   └── src/                             # Source directory for utilities
│       ├── extensions/                  # Dart extension methods
│       │   ├── string_extensions.dart   # String utilities
│       │   ├── list_extensions.dart     # List/Collection utilities
│       │   ├── date_extensions.dart     # DateTime utilities
│       │   └── num_extensions.dart      # Number utilities
│       ├── helpers/                     # Helper functions
│       │   ├── date_helpers.dart        # Date formatting & parsing
│       │   ├── file_helpers.dart        # File operations
│       │   └── platform_helpers.dart    # Platform detection
│       ├── validators/                  # Validation utilities
│       │   ├── email_validator.dart     # Email validation
│       │   ├── phone_validator.dart     # Phone validation
│       │   └── text_validators.dart     # Generic text validation
│       └── constants/                   # Shared constants
│           ├── regex_patterns.dart      # Regular expressions
│           └── app_constants.dart       # Application constants
│
├── test/                                # Unit tests
├── pubspec.yaml                         # Package configuration
├── README.md                            # This file
└── analysis_options.yaml                # Linting rules

```

---

## 🚀 Getting Started

### Installation

This package is part of the monorepo and can be used by adding it to your package's `pubspec.yaml`:

```yaml
dependencies:
  shared_utils:
    path: ../shared_utils # Or ../../packages/shared_utils from apps
```

### Usage

Import the package in your Dart files:

```dart
import 'package:shared_utils/shared_utils.dart';
```

---

## 🧩 Architecture

This package follows Clean Architecture principles and provides:

- **Pure functions** - Side-effect-free utility functions
- **Extension methods** - Convenient extensions on Dart core types
- **Validators** - Input validation utilities
- **Helpers** - Common helper functions for date, file, platform operations
- **Constants** - Shared constants and regex patterns
- **Platform-agnostic** - Works on all Flutter platforms (mobile, web, desktop)

---

## 📝 Example Usage

```dart
// String extensions
final email = 'user@example.com';
if (email.isValidEmail) {
  print('Valid email');
}

// Date helpers
final formattedDate = DateHelpers.formatDate(DateTime.now(), 'dd/MM/yyyy');

// List extensions
final list = [1, 2, 3, 4, 5];
final evenNumbers = list.whereIndexed((index, item) => item.isEven);

// Validators
final isValid = EmailValidator.validate('user@example.com');
```

---

## 💡 Best Practices

- Keep all utilities pure and side-effect-free
- Write comprehensive unit tests for all utilities
- Use descriptive names for functions and extensions
- Document all public APIs with dartdoc comments
- Avoid platform-specific code (use conditional imports if needed)
- Keep utilities generic and reusable
- Group related utilities in appropriate subdirectories

---

## 📝 Adding New Utilities

When adding a new utility:

1. Create the utility file in appropriate category folder under `lib/src/`
2. Export the utility in `lib/shared_utils.dart`
3. Write unit tests in `test/`
4. Document usage in this README
5. Update CHANGELOG.md

---

## ✅ Dependencies

This package has minimal dependencies to keep it lightweight:

- `test` - For unit testing
- `very_good_analysis` - For code quality

Optional dependencies (uncomment in pubspec.yaml if needed):

- `fpdart` - Functional programming utilities
- `intl` - Internationalization utilities

---

## ⚠️ Avoid Pitfalls

- Do not add Flutter-specific code here (use `shared_widgets` instead)
- Do not add state management logic (use appropriate packages)
- Do not add business logic (utilities should be generic)
- Avoid external dependencies when possible
- Keep utilities pure and testable

---

## ✅ Final Notes

- **Pure Dart package** - No Flutter dependencies (works everywhere)
- **Fully testable** - All utilities are pure functions
- **Lightweight** - Minimal dependencies
- **Reusable** - Generic utilities for all apps
- **Well-organized** - Clear categorization of utilities

---

> **Happy coding! 🛠️✨**
> Build robust, reusable utilities — DRY principle in action.

---
