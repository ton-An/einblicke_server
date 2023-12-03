import 'package:dispatch_pi_dart/domain/models/token_claims.dart';

/// {@template access_token_payload}
/// Contains the payload of an access token
/// {@endtemplate}
class AccessTokenClaims extends TokenClaims {
  /// {@macro access_token_payload}
  const AccessTokenClaims({
    required super.userId,
    required super.userType,
    required super.issuedAt,
    required super.expiresAt,
  });

  @override
  List<Object?> get props => [
        userId,
        userType,
        issuedAt,
        expiresAt,
      ];
}
