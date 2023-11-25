/// {@template secrets}
/// Contract for the servers secrets
///
/// The secrets implementation file should not be committed to the repository.
/// Preferably the file name should be secrets_impl.dart
/// {@endtemplate}
abstract class Secrets {
  /// The secret used to authenticate the client
  String get clientSecret;
}
