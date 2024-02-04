import 'package:equatable/equatable.dart';

/// {@template encrypted_token}
/// __EncryptedToken__ is a container for an encrypted token which used for
/// authentication.
///
/// It contains the [token] string and the [expiresAt] time of the token.
/// {@endtemplate}
class EncryptedToken extends Equatable {
  /// {@macro encrypted_token}
  const EncryptedToken({
    required this.token,
    required this.expiresAt,
  });

  /// Is the token string used for authentication
  final String token;

  /// Is the time in seconds that the token will be valid for
  final DateTime expiresAt;

  @override
  List<Object?> get props => [
        token,
        expiresAt,
      ];
}
