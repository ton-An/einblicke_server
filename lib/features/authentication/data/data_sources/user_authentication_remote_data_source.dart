import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:sqlite3/sqlite3.dart';

/// {@template user_authentication_remote_data_source}
/// Remote data source for user authentication
/// {@endtemplate}
abstract class UserAuthenticationLocalDataSource<U extends User> {
  /// {@macro user_authentication_remote_data_source}
  const UserAuthenticationLocalDataSource();

  /// Checks if the given username is already in
  /// the database
  ///
  /// Parameters:
  /// - [String] username
  ///
  /// Returns:
  /// - [bool] indicating if the username is taken
  ///
  /// Throws:
  /// - [SqliteException]
  Future<bool> isUsernameTaken(String username);

  /// Checks if the given user id is already in
  /// the database
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - [bool] indicating if the user id is taken
  ///
  /// Throws:
  /// - [SqliteException]
  Future<bool> isUserIdTaken(String userId);

  /// Creates a record of a user with the given username and password hash
  /// in the database
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [U] object representing the created user
  ///
  /// Throws:
  /// - [SqliteException]
  Future<U> createUser({
    required String userId,
    required String username,
    required String passwordHash,
  });

  /// Gets the user with the given username and password hash
  /// from the database
  ///
  /// Parameters:
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [U] object representing the user
  ///
  /// Throws:
  /// - [SqliteException]
  Future<U> getUser({
    required String username,
    required String passwordHash,
  });

  /// Saves a refresh token to the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Throws:
  /// - [SqliteException]
  Future<void> saveRefreshTokenToDb({
    required String userId,
    required String refreshToken,
  });

  /// Removes a refresh token from the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Throws:
  /// - [SqliteException]
  Future<void> removeRefreshTokenFromDb({
    required String userId,
    required String refreshToken,
  });

  /// Removes all refresh tokens from the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Throws:
  /// - [SqliteException]
  Future<void> removeAllRefreshTokensFromDb(String userId);

  /// Checks if the given refresh token is in the database
  /// for the given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Returns:
  /// - [bool] indicating if the refresh token is in the database
  ///
  /// Throws:
  /// - [SqliteException]
  Future<bool> isRefreshTokenInUserDb({
    required String userId,
    required String refreshToken,
  });

  /// Gets the user with the given user id from the database
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - a [U] object representing the user
  ///
  /// Throws:
  /// - [SqliteException]
  Future<U> getUserFromId(String userId);

  /// Checks if a user with the given user id exists in the database
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - [bool] indicating if the user exists
  ///
  /// Throws:
  /// - [SqliteException]
  Future<bool> doesUserWithIdExist(String userId);
}
