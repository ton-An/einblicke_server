import 'package:equatable/equatable.dart';

/// {@template encrypted_token}
/// Model for an encrypted token which is used for authentication
///
/// It includes the [token] and the [expiresAt] time
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
