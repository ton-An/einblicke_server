import 'package:clock/clock.dart';
import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/access_token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';

/// {@template generate_access_token}
/// Generates an access token for a given user
///
/// Parameters:
/// - [User] user
///
/// Returns:
/// - [EncryptedToken] access token
/// {@endtemplate}
class GenerateAccessToken {
  /// {@macro generate_access_token}1
  const GenerateAccessToken({
    required this.basicAuthRepository,
    required this.secrets,
    required this.clock,
  });

  /// Use case for generating an encrypted token
  final BasicAuthenticationRepository basicAuthRepository;

  /// Secrets for generating the token
  final Secrets secrets;

  /// Clock for generating the token
  final Clock clock;

  /// {@macro generate_access_token}
  EncryptedToken call({required User user}) {
    final DateTime issuedAt = clock.now();
    final DateTime expiresAt = issuedAt.add(secrets.accessTokenLifetime);

    final AccessTokenClaims claims = AccessTokenClaims(
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
