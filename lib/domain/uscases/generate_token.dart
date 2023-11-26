import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/repositories/basic_authentication_repository.dart';

/// {@template generate_encrypted_token}
/// Generates an encrypted and signed token
///
/// Parameters:
/// - [String] payload
/// - [int] expiresIn
///
/// Returns:
/// - an [EncryptedToken] containing the signed and encrypted token
/// and the seconds until expiration
/// {@endtemplate}
class GenerateEncryptedToken {
  /// {@macro generate_encrypted_token}
  GenerateEncryptedToken({
    required this.basicAuthRepository,
  });

  /// Repository for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// {@macro generate_encrypted_token}
  EncryptedToken call({
    required String payload,
    required int expiresIn,
  }) {
    final String tokenString = basicAuthRepository.generateSignedToken(payload);
    final String encryptedTokenString =
        basicAuthRepository.encryptToken(tokenString);

    final EncryptedToken encryptedToken = EncryptedToken(
      token: encryptedTokenString,
      expiresIn: expiresIn,
    );

    return encryptedToken;
  }
}
