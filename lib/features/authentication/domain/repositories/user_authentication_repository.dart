import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';

/// {@template user_auth_repository}
/// Repository for user authentication
/// {@endtemplate}
abstract class UserAuthenticationRepository<U extends User> {
  /// {@macro user_auth_repository}
  const UserAuthenticationRepository();

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

  /// Checks if the given user id is taken
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - a [bool] indicating if the user id is taken
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> isUserIdTaken(String userId);

  /// Creates a record of a user with the given username and password hash
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [U] object representing the created user
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, U>> createUser(
    String userId,
    String username,
    String passwordHash,
  );

  /// Gets the user with the given username and password hash
  ///
  /// Parameters:
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [U] object representing the user
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  /// - [UserNotFoundFailure]
  Future<Either<Failure, U>> getUser(
    String username,
    String passwordHash,
  );

  /// Saves the refresh token in the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> saveRefreshTokenToDb(
    String userId,
    String refreshToken,
  );

  /// Removes the refresh token from the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> removeRefreshTokenFromDb(
    String userId,
    String refreshToken,
  );

  /// Removes all refresh tokens from the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> removeAllRefreshTokensFromDb(
    String userId,
  );

  /// Checks if the given refresh token is in the database for the given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Returns:
  /// - a [bool] indicating if the token is in the database
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> isRefreshTokenInUserDb(
    String userId,
    String refreshToken,
  );

  /// Gets the user from the database for the given user id
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - a [U] user
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  /// - [UserNotFoundFailure]
  Future<Either<Failure, U>> getUserFromId(String userId);

  /// Checks if the user with the given user id exists
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - a [bool] indicating if the user exists
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> doesUserWithIdExist(String userId);
}
