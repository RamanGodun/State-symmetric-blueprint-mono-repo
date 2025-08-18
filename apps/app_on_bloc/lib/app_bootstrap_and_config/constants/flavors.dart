//
// ignore_for_file: public_member_api_docs

enum AppFlavor { development, staging }

final class FlavorConfig {
  static late final AppFlavor current;
  static String get name => switch (current) {
    AppFlavor.development => 'development',
    AppFlavor.staging => 'staging',
  };
}
