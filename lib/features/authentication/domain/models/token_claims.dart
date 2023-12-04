import 'package:equatable/equatable.dart';

/// {@template token_payload}
/// Contains the payload of a token
/// {@endtemplate}
abstract class TokenClaims extends Equatable {
  /// {@macro token_payload}
  const TokenClaims({
    required this.userId,
    required this.userType,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// The id of the user this payload belongs to
  final String userId;

  /// The type of user this payload belongs to
  final Type userType;

  /// The time this token was issued at
  final DateTime issuedAt;

  /// The time this token expires at
  final DateTime expiresAt;
}
