import 'package:einblicke_server/features/authentication/domain/models/token_claims/token_claims.dart';

/// {@template refresh_token_payload}
/// __RefreshTokenClaims__ is a container for the claims specific to a refresh
/// token.
///
/// It contains the [tokenId] of the token (refresh token specific),
/// the [userId] of the user, the [userType] of the user,
/// the [issuedAt] time of the token, and the [expiresAt] time of the token.
/// {@endtemplate}
class RefreshTokenClaims extends TokenClaims {
  /// {@macro refresh_token_payload}
  const RefreshTokenClaims({
    required this.tokenId,
    required super.userId,
    required super.userType,
    required super.issuedAt,
    required super.expiresAt,
  });

  /// The id of the token this payload belongs to
  final String tokenId;

  @override
  List<Object?> get props => [
        tokenId,
        userId,
        userType,
        issuedAt,
        expiresAt,
      ];
}
