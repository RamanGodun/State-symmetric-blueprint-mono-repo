/// Test helper functions for async operations
library;

/// Wait for a specified duration
///
/// This is a simple helper to make tests more readable when waiting for
/// async operations to complete.
Future<void> wait(Duration duration) async {
  await Future<void>.delayed(duration);
}
