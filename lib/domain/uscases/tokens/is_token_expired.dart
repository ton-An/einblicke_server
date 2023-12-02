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
  const IsTokenExpired();

  /// {@macro is_token_expired}
  bool call({required DateTime expiresAt}) {
    // TODO: implement check for expired token
    throw UnimplementedError();
  }
}
