import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template curator_authentication_local_data_source}
/// __Curator Authentication Local Data Source__ is a contract for [Curator]
/// related local data source operations.
/// {@endtemplate}
abstract class CuratorAuthenticationLocalDataSource
    extends UserAuthenticationLocalDataSource<Curator> {
  /// {@macro curator_authentication_local_data_source}
  const CuratorAuthenticationLocalDataSource();

  /// Creates a record of a curator with the given user id and curator id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] curatorId
  /// - [String] username
  ///
  /// Returns:
  /// - [Curator] object representing the user
  ///
  /// Throws:
  /// - [DatabaseException]
  Future<Curator> createCurator({
    required String userId,
    required String username,
    required String passwordHash,
  });

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
  Future<bool> isUsernameTaken({required String username});

  /// Gets the [Curator] with the given username and password hash
  /// from the database
  ///
  /// Parameters:
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - [Curator] object representing the user
  ///
  /// Throws:
  /// - [DatabaseException]
  Future<Curator?> getCuratorFromCredentials({
    required String username,
    required String passwordHash,
  });
}

/// {@template curator_auth_local_data_source_impl}
/// __Curator Authentication Local Data Source Implementation__ is a
/// concrete implementation of [CuratorAuthenticationLocalDataSource].
/// {@endtemplate}
class CuratorAuthLocalDataSourceImpl
    extends CuratorAuthenticationLocalDataSource
    with UserAuthLocalDataSourceImpl {
  /// {@macro curator_auth_local_data_source_impl}
  const CuratorAuthLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.userTableNames,
    required this.refreshTokenTableNames,
  });

  @override
  final Database sqliteDatabase;

  @override
  final CuratorTable userTableNames;

  @override
  final UserRefreshTokenTable<Curator> refreshTokenTableNames;

  @override
  Future<Curator> createCurator({
    required String userId,
    required String username,
    required String passwordHash,
  }) async {
    final Curator curator = Curator(
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
        curator.userId,
        curator.username,
        curator.passwordHash,
      ],
    );

    return curator;
  }

  @override
  Future<bool> isUsernameTaken({required String username}) async {
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
  Future<Curator?> getCuratorFromCredentials({
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

    final Curator curator = Curator(
      userId: queryResult.first[userTableNames.userId]! as String,
      username: queryResult.first[userTableNames.username]! as String,
      passwordHash: queryResult.first[userTableNames.passwordHash]! as String,
    );

    return curator;
  }

  @override
  Future<Curator?> getUserFromId({required String userId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT ${userTableNames.userId},  ${userTableNames.username},  "
      "${userTableNames.passwordHash} FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?",
      [userId],
    );

    if (queryResult.isEmpty ||
        queryResult.first[userTableNames.userId] == null ||
        queryResult.first[userTableNames.username] == null ||
        queryResult.first[userTableNames.passwordHash] == null) {
      return null;
    }

    final Curator curator = Curator(
      userId: queryResult.first[userTableNames.userId] as String,
      username: queryResult.first[userTableNames.username] as String,
      passwordHash: queryResult.first[userTableNames.passwordHash] as String,
    );

    return curator;
  }
}
