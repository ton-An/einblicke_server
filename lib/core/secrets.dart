/// {@template secrets}
/// Contract for the servers secrets
///
/// The secrets implementation file should not be committed to the repository.
/// Preferably the file name should be secrets_impl.dart
/// {@endtemplate}
abstract class Secrets {
  /// {@macro secrets}
  const Secrets();

  /// The secret used to authenticate the client
  String get clientSecret;

  /// The client id used to authenticate the client
  String get clientId;

  /// The lifetime of the access token
  int get accessTokenLifetime;

  /// The lifetime of the refresh token
  int get refreshTokenLifetime;
}
