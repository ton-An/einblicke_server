import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/token_claims.dart';

/// {@template access_token_payload}
/// __AccessTokenClaims__ is a container for the claims specific to an access
/// token.
///
/// It contains the [userId] of the user, the [userType] of the user,
/// the [issuedAt] time of the token, and the [expiresAt] time of the token.
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
