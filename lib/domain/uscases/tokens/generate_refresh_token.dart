import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token.dart';

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
    required this.generateEncryptedToken,
    required this.secrets,
  });

  /// Use case for generating an encrypted token
  final GenerateEncryptedToken generateEncryptedToken;

  /// Secrets for generating the token
  final Secrets secrets;

  /// {@macro generate_refresh_token}
  EncryptedToken call({required User user}) {
    final EncryptedToken encryptedToken = generateEncryptedToken(
      payload: {
        'userId': user.userId,
        'userType': user.runtimeType,
      },
      expiresIn: secrets.refreshTokenLifetime,
    );

    return encryptedToken;
  }
}
