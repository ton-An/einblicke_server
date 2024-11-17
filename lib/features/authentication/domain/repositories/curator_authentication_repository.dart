import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template curator_auth_repository}
/// ___Curator Authentication Repository___ is a contract for [Curator] related
/// authentication repository operations.
/// {@endtemplate}
abstract class CuratorAuthenticationRepository
    extends UserAuthenticationRepository<Curator> {
  /// {@macro curator_auth_repository}
  const CuratorAuthenticationRepository();

  /// Checks if the given username is taken
  ///
  /// Parameters:
  /// - [String] username
  ///
  /// Returns:
  /// - a [bool] indicating if the username is taken
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> isUsernameTaken(String username);

  /// Creates a record of a curator with the given username and password hash
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - [Curator] object representing the user
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, Curator>> createCurator(
    String userId,
    String username,
    String passwordHash,
  );

  /// Gets the curator with the given username and password hash
  ///
  /// Parameters:
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [Curator] object representing the user
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  /// - [UserNotFoundFailure]
  Future<Either<Failure, Curator>> getCuratorFromCredentials(
    String username,
    String passwordHash,
  );
}
