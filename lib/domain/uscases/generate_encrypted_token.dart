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
    required Map payload,
    required int expiresIn,
  }) {
    final String tokenString =
        basicAuthRepository.generateJWEToken(payload, expiresIn);

    final EncryptedToken encryptedToken = EncryptedToken(
      token: tokenString,
      expiresIn: expiresIn,
    );

    return encryptedToken;
  }
}
