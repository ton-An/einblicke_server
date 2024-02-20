import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template basic_auth_repository}
/// ___Basic Authentication Repository___ is a contract for the basic
/// authentication related repository operations.
///
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
  Future<Either<Failure, TokenClaims>> checkTokenSignatureValidity(
    String refreshToken,
  );

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
  Future<Either<Failure, String>> getUserIdFromToken(String token);
}
