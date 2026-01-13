# Contributing to State-Symmetric Blueprint Monorepo

🎉 Thank you for your interest in contributing! This document provides guidelines for contributing to this Flutter monorepo.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Commit Message Guidelines](#commit-message-guidelines)

## 📜 Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct. Be respectful, inclusive, and constructive in all interactions.

## 🚀 Getting Started

### Prerequisites

- **Flutter**: >= 3.24.0
- **Dart**: >= 3.5.0
- **Melos**: Latest version (`dart pub global activate melos`)
- **Git**: Latest version

### Development Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/RamanGodun/State-symmetric-blueprint-mono-repo.git
   cd State-symmetric-blueprint-mono-repo
   ```

2. **Install Melos globally**

   ```bash
   dart pub global activate melos
   ```

3. **Bootstrap the workspace**

   ```bash
   melos bootstrap
   ```

4. **Verify setup**
   ```bash
   melos run verify
   ```

## 📁 Monorepo Structure

```
.
├── apps/
│   ├── app_on_cubit/          # Demo app using Bloc/Cubit
│   └── app_on_riverpod/       # Demo app using Riverpod
├── packages/
│   ├── features_dd_layers/    # Domain & Data layers for features
│   ├── shared_core_modules/   # Form fields, validation, localization
│   ├── shared_layers/         # Presentation layer shared code
│   ├── shared_widgets/        # Reusable UI components
│   ├── shared_utils/          # Utility functions
│   ├── adapters_for_bloc/     # Bloc/Cubit adapters
│   ├── adapters_for_riverpod/ # Riverpod adapters
│   └── adapters_for_firebase/ # Firebase adapters
├── ADR/                       # Architecture Decision Records
└── melos.yaml                 # Monorepo configuration
```

## 🤝 How to Contribute

### Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.yaml):

1. Choose correct **Scope** (package affected)
2. Provide clear **reproduction steps**
3. Include **environment details**
4. Add **logs/screenshots** if applicable

### Suggesting Features

Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.yaml):

1. Describe the **user need**
2. Provide **acceptance criteria**
3. Consider **impact and metrics**

### Improving Documentation

Use the [Documentation template](.github/ISSUE_TEMPLATE/documentation.yaml):

- README updates
- API documentation
- ADR (Architecture Decision Records)
- Code comments

## 💻 Coding Standards

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

```bash
# Format code
melos run format

# Analyze code
melos run analyze
```

### Code Organization

- **Feature-first structure**: Group by feature, not by layer
- **Clean Architecture**: Domain ← Data ← Presentation
- **State-symmetric approach**: Reusable state models across state managers

### Best Practices

1. **Keep it simple**: Avoid over-engineering
2. **DRY principle**: Don't repeat yourself
3. **SOLID principles**: Follow OOP best practices
4. **Functional core, imperative shell**: Pure functions + side effects at boundaries

### File Naming

- `snake_case.dart` for all files
- `PascalCase` for classes
- `camelCase` for variables/functions

## 🧪 Testing

### Running Tests

```bash
# Run all tests
melos run test

# Run tests for specific package
cd packages/shared_core_modules
flutter test

# Run tests with coverage
melos run coverage
```

### Test Guidelines

1. **Unit tests**: Test business logic in isolation
2. **Widget tests**: Test UI components
3. **Integration tests**: Test user flows (in apps/)
4. **Coverage**: Aim for > 80% (not enforced, but encouraged)

### Test Structure

```dart
void main() {
  group('FeatureName', () {
    setUp(() {
      // Setup
    });

    tearDown(() {
      // Cleanup
    });

    test('should do something when condition', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

## 📝 Pull Request Process

### Before Submitting

1. **Create a branch**

   ```bash
   git checkout -b feat/your-feature-name
   # or
   git checkout -b fix/issue-description
   ```

2. **Make your changes**
   - Write tests
   - Update documentation
   - Follow coding standards

3. **Run quality checks**

   ```bash
   melos run format:check
   melos run analyze
   melos run test
   ```

4. **Commit your changes**
   - Follow [commit message guidelines](#commit-message-guidelines)
   - Make atomic commits (one logical change per commit)

5. **Push and create PR**
   ```bash
   git push origin feat/your-feature-name
   ```

### PR Template

Use the [Pull Request template](.github/PULL_REQUEST_TEMPLATE.md):

- **Status**: READY / IN DEVELOPMENT / HOLD
- **Description**: What and why
- **Type of Change**: Feature / Bug fix / Breaking / Refactor / etc.
- **Checklist**: CI passes, docs updated

### PR Title Format

**REQUIRED**: `type(scope): subject (VAGO-123)`

Examples:

- `feat(auth): add biometric authentication (VAGO-42)`
- `fix(profile): resolve avatar upload issue (VAGO-17)`
- `docs(readme): update setup instructions (VAGO-99)`

### Review Process

1. **Automated checks**: CI must pass (format, analyze, tests)
2. **Code review**: At least 1 approval required
3. **Discussions**: Address all review comments
4. **Merge**: Squash and merge (keep history clean)

## 📋 Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format

```
type(scope): subject (VAGO-123)

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding/updating tests
- `build`: Build system changes
- `ci`: CI configuration changes
- `chore`: Maintenance tasks

### Scopes

Use package names:

- `features_dd_layers`
- `shared_core_modules`
- `shared_layers`
- `shared_widgets`
- `adapters_for_bloc`
- `adapters_for_riverpod`
- `app_on_cubit`
- `app_on_riverpod`
- `monorepo`

### Examples

```bash
feat(auth): implement email verification (VAGO-42)
fix(profile): resolve null pointer exception in avatar (VAGO-17)
docs(readme): add melos setup instructions (VAGO-99)
refactor(shared_widgets): extract common button logic (VAGO-55)
```

## 🔍 Melos Commands

Common commands for development:

```bash
# Bootstrap workspace
melos bootstrap

# Run all quality checks
melos run verify

# Format code
melos run format
melos run format:check

# Analyze code
melos run analyze

# Run tests
melos run test
melos run test:coverage

# Clean workspace
melos clean
```

## 🎯 Areas for Contribution

### High Priority

- 🐛 Bug fixes
- 📚 Documentation improvements
- ✅ Test coverage
- ♿ Accessibility improvements

### Nice to Have

- 🎨 UI/UX enhancements
- ⚡ Performance optimizations
- 🌍 Localization (i18n)
- 🔧 DevTools improvements

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Melos Documentation](https://melos.invertase.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [ADR Templates](./ADR/README.md)

## 🙋 Questions?

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Email**: [Your contact email]

## 🎖️ Recognition

Contributors will be:

- Listed in README acknowledgments
- Mentioned in release notes
- Credited in relevant ADRs

---

Thank you for contributing! 🚀

_Last updated: January 2026_
