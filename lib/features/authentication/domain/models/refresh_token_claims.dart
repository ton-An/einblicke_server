import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims.dart';

/// {@template refresh_token_payload}
/// Contains the payload of a refresh token
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
