import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template frame_authentication_local_data_source}
/// __Frame Authentication Local Data Source__ is a contract for [Frame] related
/// local data source operations.
/// {@endtemplate}
abstract class FrameAuthenticationLocalDataSource
    extends UserAuthenticationLocalDataSource<Frame> {
  /// {@macro frame_authentication_local_data_source}
  const FrameAuthenticationLocalDataSource();

  /// Creates a record of a frame with the given user id and curator id
  ///
  /// Parameters:
  /// - [String] userId
  /// - [String] curatorId
  ///
  /// Returns:
  /// - [Frame] object representing the user
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Frame> createFrame({
    required String userId,
    required String ownerId,
    required String name,
  });
}

/// {@template frame_auth_local_data_source_impl}
/// __Frame Authentication Local Data Source Implementation__ is the concrete
/// implementation of the [UserAuthenticationLocalDataSource] contract
/// and handles the [Frame] related local data source operations.
/// {@endtemplate}
class FrameAuthenticationLocalDataSourceImpl
    extends FrameAuthenticationLocalDataSource
    with UserAuthLocalDataSourceImpl<Frame> {
  /// {@macro frame_auth_local_data_source_impl}
  const FrameAuthenticationLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.userTableNames,
    required this.refreshTokenTableNames,
  });

  @override
  final Database sqliteDatabase;

  @override
  final FrameTable userTableNames;

  @override
  final FrameRefreshTokenTable refreshTokenTableNames;

  @override
  Future<Frame> createFrame({
    required String userId,
    required String ownerId,
    required String name,
  }) async {
    final Frame frame = Frame(
      userId: userId,
      ownerId: ownerId,
      name: name,
    );

    await sqliteDatabase.execute(
      "INSERT INTO ${userTableNames.tableName} "
      "(${userTableNames.userId}, ${userTableNames.ownerId}, "
      "${userTableNames.name})"
      "VALUES (?, ?, ?)",
      [
        frame.userId,
        frame.ownerId,
        frame.name,
      ],
    );

    return frame;
  }

  @override
  Future<Frame?> getUserFromId({required String userId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT ${userTableNames.userId},  ${userTableNames.ownerId},  "
      "${userTableNames.name} FROM ${userTableNames.tableName} "
      "WHERE ${userTableNames.userId} = ?",
      [userId],
    );

    if (queryResult.isEmpty ||
        queryResult.first[userTableNames.userId] == null ||
        queryResult.first[userTableNames.ownerId] == null ||
        queryResult.first[userTableNames.name] == null) {
      return null;
    }

    final Frame frame = Frame(
      userId: queryResult.first[userTableNames.userId]! as String,
      ownerId: queryResult.first[userTableNames.ownerId]! as String,
      name: queryResult.first[userTableNames.name]! as String,
    );

    return frame;
  }
}
