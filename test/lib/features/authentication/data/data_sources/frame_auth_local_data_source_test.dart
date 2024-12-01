import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/frame_authentication_local_data_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../database_mocks.dart';
import '../../../../../fixtures.dart';

void main() {
  late FrameAuthenticationLocalDataSourceImpl dataSource;
  late Database database;
  late FrameTable userTable;
  late FrameRefreshTokenTable userRefreshTokenTable;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await setUpMockFramesTable(database);
    await setUpMockUserRefreshTokenTable(database);

    userRefreshTokenTable = const FrameRefreshTokenTable();
    userTable = const FrameTable();
    dataSource = FrameAuthenticationLocalDataSourceImpl(
      sqliteDatabase: database,
      userTableNames: userTable,
      refreshTokenTableNames: userRefreshTokenTable,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group("createFrame", () {
    test("should write the user to the database", () async {
      // act
      await dataSource.createFrame(
        userId: tPictureFrame.userId,
        ownerId: tPictureFrame.ownerId,
        name: tPictureFrame.name,
      );

      // assert
      final databaseTable = await database.query(
        userTable.tableName,
        where: "${userTable.userId} = ?",
        whereArgs: [tPictureFrame.userId],
      );
      expect(databaseTable, isNotEmpty);
    });

    test("should return the user", () async {
      // act
      final result = await dataSource.createFrame(
        userId: tPictureFrame.userId,
        ownerId: tPictureFrame.ownerId,
        name: tPictureFrame.name,
      );

      // assert
      expect(result, tPictureFrame);
    });
  });

  group("getFrameFromId", () {
    test("should return the user if it exists", () async {
      // arrange
      await dataSource.createFrame(
        userId: tPictureFrame.userId,
        ownerId: tPictureFrame.ownerId,
        name: tPictureFrame.name,
      );

      // act
      final result = await dataSource.getUserFromId(
        userId: tPictureFrame.userId,
      );

      // assert
      expect(result, tPictureFrame);
    });

    test("should return null if the user does not exist", () async {
      // act
      final result =
          await dataSource.getUserFromId(userId: tPictureFrame.userId);

      // assert
      expect(result, isNull);
    });
  });
}
