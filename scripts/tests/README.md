# Test Scripts

Scripts for running tests and generating coverage reports in the monorepo.

## Available Scripts

### `run_tests.sh`

Runs Flutter tests for apps and packages.

**Usage:**

```bash
# Run tests for all packages and apps
./scripts/tests/run_tests.sh all

# Run tests for all apps only
./scripts/tests/run_tests.sh apps

# Run tests for all packages only
./scripts/tests/run_tests.sh packages

# Run tests for specific app
./scripts/tests/run_tests.sh cubit
./scripts/tests/run_tests.sh riverpod

# Run tests for specific package
./scripts/tests/run_tests.sh shared_layers
./scripts/tests/run_tests.sh features_dd_layers
```

### `run_coverage.sh`

Runs Flutter tests with coverage and generates HTML reports.

**Usage:**

```bash
# Generate coverage for all apps
./scripts/tests/run_coverage.sh all

# Generate coverage for specific app
./scripts/tests/run_coverage.sh cubit
./scripts/tests/run_coverage.sh riverpod

# Generate coverage for specific package
./scripts/tests/run_coverage.sh shared_layers
```

The HTML coverage report will be automatically opened in your default browser.
Report location: `<package>/coverage/html/index.html`

## Melos Commands

Use these convenient melos commands instead of calling scripts directly:

### Running Tests

```bash
# Run all tests
melos run test

# Run tests for apps only
melos run test:apps

# Run tests for packages only
melos run test:packages

# Run tests for specific app
melos run test:cubit
melos run test:riverpod

# VeryGood test (with coverage and randomization)
melos run vg:test
```

### Generating Coverage

```bash
# Generate coverage for all apps
melos run coverage

# Generate coverage for specific app
melos run coverage:cubit
melos run coverage:riverpod
```

## Notes

- Tests run with `--no-pub` flag (assumes dependencies are already installed)
- Test concurrency is set to 4 for faster execution
- Coverage reports require `lcov` tool to be installed for HTML generation
- Coverage is typically generated for apps, not packages
