import 'package:clock/clock.dart';

/// {@template is_token_expired}
/// A wrapper for checking if a token is expired
///
/// Parameters:
/// - [int] issuedAt in Unix time
/// - [int] expiresIn in seconds
///
/// Returns:
/// - [bool] indicating if the token is expired
/// {@endtemplate}
class IsTokenExpired {
  /// {@macro is_token_expired}
  const IsTokenExpired({required this.clock});

  /// Used to get the current time.
  final Clock clock;

  /// {@macro is_token_expired}
  bool call({required DateTime expiresAt}) {
    final DateTime now = clock.now();
    final bool isTokenExpired = expiresAt.isAfter(now);

    return isTokenExpired;
  }
}
