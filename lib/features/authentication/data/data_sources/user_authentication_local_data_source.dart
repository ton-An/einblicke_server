import 'package:dispatch_pi_dart/core/db_names.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite_async/sqlite_async.dart';

/// {@template user_authentication_local_data_source}
/// Local data source for user authentication
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
  Future<U?> getUserFromId(String userId);

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

/// {@template user_auth_local_data_source}
/// Local data source for handling the authentication of users
/// {@endtemplate}
class UserAuthLocalDataSourceImpl<U extends User>
    extends UserAuthenticationLocalDataSource<U> {
  /// {@macro user_auth_local_data_source}
  const UserAuthLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.userTableNames,
    required this.refreshTokenTableNames,
  });

  /// Sqlite database
  final SqliteDatabase sqliteDatabase;

  /// Names for the user table
  final UserTable userTableNames;

  /// Names for the refresh token table
  final UserRefreshTokenTable refreshTokenTableNames;

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
  Future<bool> doesUserWithIdExist(String userId) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT EXISTS(SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?)",
      [userId],
    );

    final bool doesUserWithIdExist = queryResult.containsValue(1);

    return doesUserWithIdExist;
  }

  @override
  Future<U?> getUser({
    required String username,
    required String passwordHash,
  }) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.username} = ? "
      "AND ${userTableNames.passwordHash} = ?",
      [username, passwordHash],
    );

    if (queryResult.isEmpty) {
      return null;
    }

    final U user = _instanciateUser(
      userId: queryResult[userTableNames.userId] as String,
      username: queryResult[userTableNames.username] as String,
      passwordHash: queryResult[userTableNames.passwordHash] as String,
    );

    return user;
  }

  @override
  Future<U?> getUserFromId(String userId) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?",
      [userId],
    );

    if (queryResult.isEmpty) {
      return null;
    }

    final U user = _instanciateUser(
      userId: queryResult[userTableNames.userId] as String,
      username: queryResult[userTableNames.username] as String,
      passwordHash: queryResult[userTableNames.passwordHash] as String,
    );

    return user;
  }

  @override
  Future<bool> isRefreshTokenInUserDb({
    required String userId,
    required String refreshToken,
  }) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT EXISTS(SELECT 1 FROM "
      "${refreshTokenTableNames.tableName} "
      "WHERE ${refreshTokenTableNames.userId} = ? "
      "AND ${refreshTokenTableNames.refreshToken} = ?)",
      [userId, refreshToken],
    );

    final bool isRefreshTokenInUserDb = queryResult.containsValue(1);

    return isRefreshTokenInUserDb;
  }

  @override
  Future<bool> isUserIdTaken(String userId) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT EXISTS(SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?)",
      [userId],
    );

    final bool isUserIdTaken = queryResult.containsValue(1);

    return isUserIdTaken;
  }

  @override
  Future<bool> isUsernameTaken(String username) async {
    final Row queryResult = await sqliteDatabase.get(
      "SELECT EXISTS(SELECT 1 FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.username} = ?)",
      [username],
    );

    final bool isUsernameTaken = queryResult.containsValue(1);

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
      case PictureFrame:
        return PictureFrame(
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

/// {@macro user_authentication_local_data_source}
typedef CuratorAuthLocalDataSource = UserAuthLocalDataSourceImpl<Curator>;

/// {@macro user_authentication_local_data_source}
typedef FrameAuthLocalDataSource = UserAuthLocalDataSourceImpl<PictureFrame>;
