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
├─ features.dart                                 # 🌐 Root barrel (one extra API)
│
├─ features_barrels/                             # 🧰 Public barrels per feature
│  ├─ auth/
│  │   ├─ auth.dart                              #   Domain API: contracts + use cases
│  │   └─ auth_infra.dart                        #   Infra API: repo + remote DB
│  ├─ email_verification/
│  │   ├─ email_verification.dart                #   Domain API
│  │   └─ email_verification_infra.dart          #   Infra API
│  ├─ password_changing_or_reset/
│  │   ├─ password_changing_or_reset.dart        #   Domain API
│  │   └─ password_changing_or_reset_infra.dart  #   Infra API
│  └─ profile/
│      ├─ profile.dart                           #   Domain API
│      └─ profile_infra.dart                     #   Infra API
│
└─ src/                                          # 🧱 Internal sources (not for export)
   ├─ auth/
   │  ├─ domain/
   │  │   ├─ repo_contracts.dart                 #     Domain contracts
   │  │   └─ use_cases/
   │  │       ├─ sign_in.dart
   │  │       ├─ sign_out.dart
   │  │       └─ sign_up.dart
   │  └─ data/
   │      ├─ remote_database_contract.dart
   │      ├─ remote_database_impl.dart
   │      └─ auth_repo_implementations/
   │          ├─ sign_in_repo_impl.dart
   │          ├─ sign_out_repo_impl.dart
   │          └─ sign_up_repo_impl.dart
   │
   ├─ email_verification/
   │  ├─ domain/
   │  │   ├─ email_verification_use_case.dart
   │  │   └─ repo_contract.dart
   │  └─ data/
   │      ├─ remote_database_contract.dart
   │      ├─ remote_database_impl.dart
   │      └─ email_verification_repo_impl.dart
   │
   ├─ password_changing_or_reset/
   │  ├─ domain/
   │  │   ├─ password_actions_use_case.dart
   │  │   └─ repo_contract.dart
   │  └─ data/
   │      ├─ remote_database_contract.dart
   │      ├─ remote_database_impl.dart
   │      └─ password_actions_repo_impl.dart
   │
   └─ profile/
      ├─ domain/
      │   ├─ fetch_profile_use_case.dart
      │   └─ repo_contract.dart
      └─ data/
          ├─ remote_database_contract.dart
          ├─ remote_database_impl.dart
          └─ implementation_of_profile_fetch_repo.dart
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
