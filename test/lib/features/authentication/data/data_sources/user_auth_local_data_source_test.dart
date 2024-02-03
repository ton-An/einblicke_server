import 'package:dispatch_pi_dart/core/db_names.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../database_mocks.dart';
import '../../../../../fixtures.dart';

// ToDo: Need to clean up the database tests (especially the test query results)

void main() {
  late UserAuthenticationLocalDataSource dataSource;
  late Database database;
  late UserTable<Curator> userTable;
  late UserRefreshTokenTable<Curator> userRefreshTokenTable;

  late Curator tUser;
  late Curator tAnotherUser;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await setUpMockCuratorsTable(database);
    await setUpMockUserRefreshTokenTable(database);

    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    userRefreshTokenTable = const CuratorRefreshTokenTable();
    userTable = const CuratorTable();
    dataSource = UserAuthLocalDataSourceImpl<Curator>(
      sqliteDatabase: database,
      userTableNames: userTable,
      refreshTokenTableNames: userRefreshTokenTable,
    );

    tUser = const Curator(
      userId: tCuratorId,
      username: tUsername,
      passwordHash: tPasswordHash,
    );
    tAnotherUser = const Curator(
      userId: tAnotherCuratorId,
      username: tAnotherUsername,
      passwordHash: tAnotherPasswordHash,
    );
  });

  tearDown(() async {
    await database.close();
  });

  group("createUser", () {
    test("should write the user to the database and return it", () async {
      // act
      final result = await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // assert

      expect(result, tUser);
    });
  });

  group("doesUserWithIdExist", () {
    test("should return true if the user exists", () async {
      // arrange
      await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // act
      final result = await dataSource.doesUserWithIdExist(tUser.userId);

      // assert

      expect(result, true);
    });

    test("should return false if the user does not exist", () async {
      // act
      final result = await dataSource.doesUserWithIdExist(tUser.userId);

      // assert
      expect(result, false);
    });
  });

  group("getUser", () {
    test("should return the user if it exists", () async {
      // arrange
      await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // act
      final result = await dataSource.getUser(
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // assert
      expect(result, tUser);
    });

    test("should return null if the user does not exist", () async {
      // act
      final result = await dataSource.getUser(
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // assert
      expect(result, null);
    });
  });

  group("getUserFromId", () {
    test("should return the user if it exists", () async {
      // arrange
      await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // act
      final result = await dataSource.getUserFromId(tUser.userId);

      // assert
      expect(result, tUser);
    });

    test("should return null if the user does not exist", () async {
      // act
      final result = await dataSource.getUserFromId(tUser.userId);

      // assert
      expect(result, null);
    });
  });

  group("isRefreshTokenInUserDb", () {
    test("should return true if the token is in the database", () async {
      // arrange
      await dataSource.saveRefreshTokenToDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // act
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert

      expect(result, true);
    });

    test("should return false if the token is not in the database", () async {
      // act
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      expect(result, false);
    });
  });

  group("isUserIdTaken", () {
    test("should return true if the user id is taken", () async {
      // arrange
      await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // act
      final result = await dataSource.isUserIdTaken(tUser.userId);

      // assert
      expect(result, true);
    });

    test("should return false if the user id is not taken", () async {
      // act
      final result = await dataSource.isUserIdTaken(tUser.userId);

      // assert
      expect(result, false);
    });
  });

  group("isUsernameTaken", () {
    test("should return true if the username is taken", () async {
      // arrange
      await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // act
      final result = await dataSource.isUsernameTaken(tUser.username);

      // assert
      expect(result, true);
    });

    test("should return false if the username is not taken", () async {
      // act
      final result = await dataSource.isUsernameTaken(tUser.username);

      // assert
      expect(result, false);
    });
  });

  group("removeAllRefreshTokensFromDb", () {
    test("should remove all refresh tokens from the database", () async {
      // arrange
      await dataSource.saveRefreshTokenToDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );
      await dataSource.saveRefreshTokenToDb(
        userId: tAnotherUser.userId,
        refreshToken: tAnotherRefreshToken,
      );

      // act
      await dataSource.removeAllRefreshTokensFromDb(tUser.userId);

      // assert
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );
      final anotherResult = await dataSource.isRefreshTokenInUserDb(
        userId: tAnotherUser.userId,
        refreshToken: tAnotherRefreshToken,
      );

      expect(result, false);
      expect(anotherResult, true);
    });
  });

  group("removeRefreshTokenFromDb", () {
    test("should remove the refresh token from the database", () async {
      // arrange
      await dataSource.saveRefreshTokenToDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // act
      await dataSource.removeRefreshTokenFromDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );
      expect(result, false);
    });
  });

  group("saveRefreshTokenToDb", () {
    test("should save the refresh token to the database", () async {
      // act
      await dataSource.saveRefreshTokenToDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );
      expect(result, true);
    });
  });
}
