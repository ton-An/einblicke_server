import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// __Curator Authentication Local Data Source__ is a contract for [Curator]
/// related local data source operations.
typedef CuratorAuthLocalDataSource = UserAuthenticationLocalDataSource<Curator>;

/// __Frame Authentication Local Data Source__ is a contract for [Frame] related
/// local data source operations.
typedef FrameAuthLocalDataSource = UserAuthenticationLocalDataSource<Frame>;

/// __Curator Authentication Local Data Source Implementation__ is the concrete
/// implementation of the [UserAuthenticationLocalDataSource] contract
/// and handles the [Curator] related local data source operations.
typedef CuratorAuthLocalDataSourceImpl = UserAuthLocalDataSourceImpl<Curator>;

/// __Frame Authentication Local Data Source Implementation__ is the concrete
/// implementation of the [UserAuthenticationLocalDataSource] contract
/// and handles the [Frame] related local data source operations.
typedef FrameAuthLocalDataSourceImpl = UserAuthLocalDataSourceImpl<Frame>;

/// {@template user_authentication_local_data_source}
/// __User Authentication Local Data Source__ is a contract and wrapper for [U]
/// user related local data source operations.
/// {@endtemplate}
abstract class UserAuthenticationLocalDataSource<U extends User> {
  /// {@macro user_authentication_local_data_source}
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
  /// - [DatabaseException]
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
  /// - [DatabaseException]
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
  /// - [DatabaseException]
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
  /// - [DatabaseException]
  Future<U?> getUser({
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
  /// - [DatabaseException]
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
  /// - [DatabaseException]
  Future<U?> getUserFromId(String userId);
}

/// {@template user_auth_local_data_source_impl}
/// __User Authentication Local Data Source Implementation__ is the concrete
/// implementation of the [UserAuthenticationLocalDataSource] contract and a
/// wrapper for [U] user related local data source operations.
/// {@endtemplate}
class UserAuthLocalDataSourceImpl<U extends User>
    extends UserAuthenticationLocalDataSource<U> {
  /// {@macro user_auth_local_data_source_impl}
  const UserAuthLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.userTableNames,
    required this.refreshTokenTableNames,
  });

  /// Sqlite database
  final Database sqliteDatabase;

  /// Names for the user table
  final UserTable<U> userTableNames;

  /// Names for the refresh token table
  final UserRefreshTokenTable<U> refreshTokenTableNames;

  @override
  Future<U> createUser({
    required String userId,
    required String username,
    required String passwordHash,
  }) async {
    final U user = _instanciateUser(
      userId: userId,
      username: username,
      passwordHash: passwordHash,
    );

    await sqliteDatabase.execute(
      "INSERT INTO ${userTableNames.tableName} "
      "(${userTableNames.userId}, ${userTableNames.username}, "
      "${userTableNames.passwordHash}) "
      "VALUES (?, ?, ?)",
      [
        user.userId,
        user.username,
        user.passwordHash,
      ],
    );

    return user;
  }

  @override
  Future<U?> getUser({
    required String username,
    required String passwordHash,
  }) async {
    final List<Map<String, Object?>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT  ${userTableNames.userId},  ${userTableNames.username},  ${userTableNames.passwordHash} FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.username} = ? "
      "AND ${userTableNames.passwordHash} = ?",
      [username, passwordHash],
    );

    if (queryResult.isEmpty ||
        queryResult.first[userTableNames.userId] == null ||
        queryResult.first[userTableNames.username] == null ||
        queryResult.first[userTableNames.passwordHash] == null) {
      return null;
    }

    final U user = _instanciateUser(
      userId: queryResult.first[userTableNames.userId]! as String,
      username: queryResult.first[userTableNames.username]! as String,
      passwordHash: queryResult.first[userTableNames.passwordHash]! as String,
    );

    return user;
  }

  @override
  Future<U?> getUserFromId(String userId) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT ${userTableNames.userId},  ${userTableNames.username},  ${userTableNames.passwordHash} FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?",
      [userId],
    );

    if (queryResult.isEmpty ||
        queryResult.first[userTableNames.userId] == null ||
        queryResult.first[userTableNames.username] == null ||
        queryResult.first[userTableNames.passwordHash] == null) {
      return null;
    }
    final U user = _instanciateUser(
      userId: queryResult.first[userTableNames.userId] as String,
      username: queryResult.first[userTableNames.username] as String,
      passwordHash: queryResult.first[userTableNames.passwordHash] as String,
    );

    return user;
  }

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
  Future<bool> isUserIdTaken(String userId) async {
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
  Future<bool> isUsernameTaken(String username) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.username} = ?)",
      [username],
    );

    final bool isUsernameTaken = queryResult.first.containsValue(1);

    return isUsernameTaken;
  }

  @override
  Future<void> removeAllRefreshTokensFromDb(String userId) async {
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

  U _instanciateUser<P extends User>({
    required String userId,
    required String username,
    required String passwordHash,
  }) {
    switch (U) {
      case Curator:
        return Curator(
          userId: userId,
          username: username,
          passwordHash: passwordHash,
        ) as U;
      case Frame:
        return Frame(
          userId: userId,
          username: username,
          passwordHash: passwordHash,
        ) as U;

      default:
        throw ArgumentError(
          "The type parameter U must be either Curator or PictureFrame",
        );
    }
  }
}
