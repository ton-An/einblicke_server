import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';

/// {@template basic_auth_repository}
/// Repository for basic authentication related operations
/// {@endtemplate}
abstract class BasicAuthenticationRepository {
  /// {@macro basic_auth_repository}
  const BasicAuthenticationRepository();

  /// Generates a hash of the given password
  ///
  /// Parameters:
  /// - [String] password
  ///
  /// Returns:
  /// - a [String] containing the hash of the given password
  String generatePasswordHash(String password);

  /// Generates a unique user id for the given username
  ///
  /// Technically, this is not necessary atm, as the username is already unique.
  /// But, it in the future, not having a unique user id could be an issue.
  ///
  /// Returns:
  /// - a [String] containing the unique user id
  String generateUserId();

  /// Generates a signed token with the given payload
  ///
  /// Parameters:
  /// - [String] payload
  ///
  /// Returns:
  /// - a [String] containing the signed token
  String generateSignedToken(Map payload);

  /// Encrypts the given token
  ///
  /// Parameters:
  /// - [String] token
  ///
  /// Returns:
  /// - a [String] containing the encrypted token
  String encryptToken(String token);

  /// Decrypts the given token
  ///
  /// Parameters:
  /// - [String] encrypted token
  ///
  /// Returns:
  /// - [String] containing the decrypted token
  ///
  /// Failures:
  /// - [DecryptionFailure]
  Either<Failure, String> decryptToken(String encryptedToken);

  /// Checks if the given token is valid
  ///
  /// Parameters:
  /// - [String] token
  ///
  /// Returns:
  /// - [String] containing the userId if the token is valid
  ///
  /// Failures:
  /// - [InvalidTokenFailure]
  /// - [ExpiredTokenFailure]
  Either<Failure, String> isTokenValid(String token);
}
