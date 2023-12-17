import 'package:clock/clock.dart';
import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/refresh_token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/crypto_repository.dart';

/// {@template generate_refresh_token}
/// Generates an refresh token for a given user
///
/// Parameters:
/// - [User] user
///
/// Returns:
/// - [EncryptedToken] refresh token
/// {@endtemplate}
class GenerateRefreshToken {
  /// {@macro generate_refresh_token}
  const GenerateRefreshToken({
    required this.basicAuthRepository,
    required this.secrets,
    required this.clock,
    required this.cryptoRepository,
  });

  /// Use case for generating an encrypted token
  final BasicAuthenticationRepository basicAuthRepository;

  final CryptoRepository cryptoRepository;

  /// Secrets for generating the token
  final Secrets secrets;

  final Clock clock;

  /// {@macro generate_refresh_token}
  EncryptedToken call({required User user}) {
    final DateTime issuedAt = clock.now();
    final DateTime expiresAt = issuedAt.add(secrets.refreshTokenLifetime);
    final String tokenId = cryptoRepository.generateUuid();

    final RefreshTokenClaims claims = RefreshTokenClaims(
      tokenId: tokenId,
      userId: user.userId,
      userType: user.runtimeType,
      issuedAt: issuedAt,
      expiresAt: expiresAt,
    );

    final String tokenString = basicAuthRepository.generateJWEToken(claims);

    final EncryptedToken token = EncryptedToken(
      token: tokenString,
      expiresAt: expiresAt,
    );

    return token;
  }
}
