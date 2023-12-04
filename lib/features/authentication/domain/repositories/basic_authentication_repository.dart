import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims.dart';

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
  /// - [Map] payload
  ///
  /// Returns:
  /// - a [String] containing the signed token
  String generateJWEToken(TokenClaims claims);

  /// Checks if the given token is valid
  ///
  /// Parameters:
  /// - [String] refreshToken
  ///
  /// Returns:
  /// - a [TokenClaims] containing the payload of the token
  ///
  /// Failures:
  /// - [InvalidTokenFailure]
  Either<Failure, TokenClaims> checkTokenSignatureValidity(
    String refreshToken,
  );

  /// Generates a unique id for a token
  ///
  /// Returns:
  /// - a [String] containing the unique token id
  ///
  /// Failures:
  /// - ... TBD ...
  String generateTokenId();

  /// Gets the user id from a given token
  ///
  /// Parameters:
  /// - [String] token
  ///
  /// Returns:
  /// - a [String] containing the user id
  ///
  /// Failures:
  /// - ... TBD ...
  Either<Failure, String> getUserIdFromToken(String token);
}
