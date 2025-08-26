# Features

**Features** is the shared package for **domain** and **data** layers of app features.
It provides reusable repositories, use cases, and contracts for multiple apps in the monorepo.

- ✅ **State-agnostic** — works with Riverpod, cubit/BLoC, or any state manager.
- ✅ **Clean architecture ready** — each feature is split into **data** and **domain**.
- ✅ **Composable & scalable** — add new features without coupling.

This package currently includes a few sample features (`auth`, `email_verification`, `password_changing_or_reset`, `profile`)
but is designed to expand.

---

## Installation

Add `features` to your app via local path:

```yaml
# apps/<your_app>/pubspec.yaml
dependencies:
  features:
    path: ../../packages/features
```

Import via the public barrel:

```dart
import 'package:features/features_barrel.dart';
```

> **Import rule:** Always use barrels (`*_feature_barrel.dart`, `features_barrel.dart`).
> Never import internal files directly in apps.

---

## Public API & Structure

- `lib/features_barrel.dart` — main entry point re-exporting all features.
- Each feature has its own barrel exposing only domain & data layer contracts and implementations.

```
features/lib
├─ README (this file)
│
├─ features_barrel.dart
│
├─ auth/
│   └─ auth_feature_barrel.dart
│
├─ email_verification/
│   └─ email_verification_feature_barrel.dart
│
├─ password_changing_or_reset/
│   └─ password_changing_or_reset_feature_barrel.dart
│
└─ profile/
    └─ profile_feature_barrel.dart
```

---

## Features Catalog

| Feature                       | Domain Layer                            | Data Layer                                 |
| ----------------------------- | --------------------------------------- | ------------------------------------------ |
| **Auth**                      | `SignIn`, `SignOut`, `SignUp` use cases | Firebase-based repo implementations        |
| **Email Verification**        | `EmailVerificationUseCase`              | Repo with error mapping, remote datasource |
| **Password Changing / Reset** | `PasswordRelatedUseCases`               | Repo + Firebase remote database            |
| **Profile**                   | `FetchProfileUseCase`                   | Repo with caching + remote database impl   |

---

## Example Usage

### Auth Feature

```dart
import 'package:features/auth/auth_feature_barrel.dart';

final useCase = SignInUseCase(repo);
final result = await useCase('email', 'password');
```

### Email Verification Feature

```dart
import 'package:features/email_verification/email_verification_feature_barrel.dart';

final useCase = EmailVerificationUseCase(repo, gateway);
await useCase.sendVerificationEmail();
```

### Profile Feature

```dart
import 'package:features/profile/profile_feature_barrel.dart';

final profile = await FetchProfileUseCase(repo)('uid-123');
```

---

## Conventions

- **Domain layer** defines contracts & use cases.
- **Data layer** provides repo implementations & remote database contracts.
- **Barrels only** are public. Inside features, prefer relative imports.
- **Extensible** — add new feature modules following the same pattern.

---

## Development

This repository uses [Melos](https://melos.invertase.dev/) to manage all packages.

### Common workflows (from repo root):

```bash
# Bootstrap all packages
melos bootstrap

# Analyze & test
melos exec --scope="features" -- flutter analyze
melos exec --scope="features" -- flutter test
```

---

## Roadmap

- [ ] Add more feature modules (e.g., settings, notifications, payments).
- [ ] Expand repo contracts with local caching layer.
- [ ] Provide integration examples for Riverpod and BLoC.

---

## License

This package is licensed under the same terms as the [root LICENSE](../../LICENSE) of this monorepo.
