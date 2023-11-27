import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/uscases/generate_encrypted_token.dart';

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
    required this.generateEncryptedToken,
    required this.secrets,
  });

  /// Use case for generating an encrypted token
  final GenerateEncryptedToken generateEncryptedToken;

  /// Secrets for generating the token
  final Secrets secrets;

  /// {@macro generate_access_token}
  EncryptedToken call({required User user}) {
    final EncryptedToken encryptedToken = generateEncryptedToken(
      payload: {
        'userId': user.userId,
        'userType': user.runtimeType,
      },
      expiresIn: secrets.accessTokenLifetime,
    );

    return encryptedToken;
  }
}
