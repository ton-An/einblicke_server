import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/curator_authentication_local_data_source.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../database_mocks.dart';
import '../../../../../fixtures.dart';

void main() {
  late CuratorAuthLocalDataSourceImpl dataSource;
  late Database database;
  late CuratorTable userTable;
  late CuratorRefreshTokenTable userRefreshTokenTable;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await setUpMockCuratorsTable(database);
    await setUpMockUserRefreshTokenTable(database);

    userRefreshTokenTable = const CuratorRefreshTokenTable();
    userTable = const CuratorTable();
    dataSource = CuratorAuthLocalDataSourceImpl(
      sqliteDatabase: database,
      userTableNames: userTable,
      refreshTokenTableNames: userRefreshTokenTable,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group("createCurator", () {
    test("should write the user to the database and return it", () async {
      // act
      final result = await dataSource.createCurator(
        userId: tCurator.userId,
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // assert

      expect(result, tCurator);
    });
  });

  group("getCuratorFromCredentials", () {
    test("should return the user if it exists", () async {
      // arrange
      await dataSource.createCurator(
        userId: tCurator.userId,
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // act
      final result = await dataSource.getCuratorFromCredentials(
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // assert
      expect(result, tCurator);
    });

    test("should return null if the user does not exist", () async {
      // act
      final result = await dataSource.getCuratorFromCredentials(
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // assert
      expect(result, null);
    });
  });

  group("getCuratorFromId", () {
    test("should return the user if it exists", () async {
      // arrange
      await dataSource.createCurator(
        userId: tCurator.userId,
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // act
      final result = await dataSource.getUserFromId(userId: tCurator.userId);

      // assert
      expect(result, tCurator);
    });

    test("should return null if the user does not exist", () async {
      // act
      final result = await dataSource.getUserFromId(userId: tCurator.userId);

      // assert
      expect(result, null);
    });
  });

  group("isUserIdTaken", () {
    test("should return true if the user id is taken", () async {
      // arrange
      await dataSource.createCurator(
        userId: tCurator.userId,
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // act
      final result = await dataSource.isUserIdTaken(userId: tCurator.userId);

      // assert
      expect(result, true);
    });

    test("should return false if the user id is not taken", () async {
      // act
      final result = await dataSource.isUserIdTaken(userId: tCurator.userId);

      // assert
      expect(result, false);
    });
  });

  group("isUsernameTaken", () {
    test("should return true if the username is taken", () async {
      // arrange
      await dataSource.createCurator(
        userId: tCurator.userId,
        username: tCurator.username,
        passwordHash: tCurator.passwordHash,
      );

      // act
      final result =
          await dataSource.isUsernameTaken(username: tCurator.username);

      // assert
      expect(result, true);
    });

    test("should return false if the username is not taken", () async {
      // act
      final result =
          await dataSource.isUsernameTaken(username: tCurator.username);

      // assert
      expect(result, false);
    });
  });
}
