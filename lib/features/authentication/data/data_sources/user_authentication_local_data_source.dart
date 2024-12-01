import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template user_authentication_local_data_source}
/// __User Authentication Local Data Source__ is a contract and wrapper for [U]
/// user related local data source operations.
/// {@endtemplate}
abstract class UserAuthenticationLocalDataSource<U extends User> {
  /// {@macro user_authentication_local_data_source}
  const UserAuthenticationLocalDataSource();

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
  /// - [DatabaseException]
  Future<bool> isUserIdTaken({required String userId});

  /// Saves a refresh token to the database for a given user id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] refreshToken
  ///
  /// Throws:
  /// - [DatabaseException]
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
  /// - [DatabaseException]
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
  /// - [DatabaseException]
  Future<void> removeAllRefreshTokensFromDb({required String userId});

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
  /// - [DatabaseException]
  Future<bool> isRefreshTokenInUserDb({
    required String userId,
    required String refreshToken,
  });

  /// Gets the [U] object with the given user id
  /// from the database
  ///
  /// Parameters:
  /// - [String] userId
  ///
  /// Returns:
  /// - [U] object representing the user
  ///
  /// Throws:
  /// - [DatabaseException]
  Future<U?> getUserFromId({required String userId});
}

/// {@template user_auth_local_data_source_impl}
/// __User Authentication Local Data Source Implementation__ is the concrete
/// implementation of the [UserAuthenticationLocalDataSource] contract and a
/// wrapper for [U] user related local data source operations.
/// {@endtemplate}
mixin UserAuthLocalDataSourceImpl<U extends User>
    on UserAuthenticationLocalDataSource<U> {
  /// Sqlite database
  abstract final Database sqliteDatabase;

  /// Names for the user table
  abstract final UserTable<U> userTableNames;

  /// Names for the refresh token table
  abstract final UserRefreshTokenTable<U> refreshTokenTableNames;

  @override
  Future<bool> isRefreshTokenInUserDb({
    required String userId,
    required String refreshToken,
  }) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM "
      "${refreshTokenTableNames.tableName} "
      "WHERE ${refreshTokenTableNames.userId} = ? "
      "AND ${refreshTokenTableNames.refreshToken} = ?)",
      [userId, refreshToken],
    );

    final bool isRefreshTokenInUserDb = queryResult.first.containsValue(1);

    return isRefreshTokenInUserDb;
  }

  @override
  Future<bool> isUserIdTaken({required String userId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?)",
      [userId],
    );

    final bool isUserIdTaken = queryResult.first.containsValue(1);

    return isUserIdTaken;
  }

  @override
  Future<void> removeAllRefreshTokensFromDb({required String userId}) async {
    await sqliteDatabase.execute(
      "DELETE FROM ${refreshTokenTableNames.tableName} "
      "WHERE ${refreshTokenTableNames.userId} = ?",
      [userId],
    );
  }

  @override
  Future<void> removeRefreshTokenFromDb({
    required String userId,
    required String refreshToken,
  }) async {
    await sqliteDatabase.execute(
      "DELETE FROM ${refreshTokenTableNames.tableName} "
      "WHERE ${refreshTokenTableNames.userId} = ? "
      "AND ${refreshTokenTableNames.refreshToken} = ?",
      [userId, refreshToken],
    );
  }

  @override
  Future<void> saveRefreshTokenToDb({
    required String userId,
    required String refreshToken,
  }) async {
    await sqliteDatabase.execute(
      "INSERT INTO ${refreshTokenTableNames.tableName} "
      "(${refreshTokenTableNames.userId}, "
      "${refreshTokenTableNames.refreshToken}) "
      "VALUES (?, ?)",
      [userId, refreshToken],
    );
  }
}
