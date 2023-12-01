import 'package:equatable/equatable.dart';

/// {@template token_payload}
/// Contains the payload of a token
/// {@endtemplate}
class TokenPayload extends Equatable {
  /// {@macro token_payload}
  const TokenPayload({
    required this.userId,
    required this.issuedAt,
    required this.expiresAt,
  });

  /// The id of the user this payload belongs to
  final String userId;

  /// The time this token was issued at
  final DateTime issuedAt;

  /// The time this token expires at
  final DateTime expiresAt;

  @override
  List<Object?> get props => [userId, issuedAt, expiresAt];
}
