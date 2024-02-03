import 'package:dispatch_pi_dart/core/db_names.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';

// ToDo: Need to clean up the database tests (especially the test query results)

void main() {
  late UserAuthenticationLocalDataSource dataSource;
  late Database database;
  late UserTable<Curator> userTable;
  late UserRefreshTokenTable<Curator> userRefreshTokenTable;

  late Curator tUser;

  setUp(() async {
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
  });

  group("createUser", () {
    setUp(() {
      when(
        () => database.execute(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tMockResultSet);
    });

    test("should write the user to the database and return it", () async {
      // act
      final result = await dataSource.createUser(
        userId: tUser.userId,
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // assert
      verify(
        () => database.execute(
          "INSERT INTO ${userTable.tableName} "
          "(${userTable.userId}, ${userTable.username}, ${userTable.passwordHash}) "
          "VALUES (?, ?, ?)",
          [
            tUser.userId,
            tUser.username,
            tUser.passwordHash,
          ],
        ),
      );
      expect(result, tUser);
    });
  });

  group("doesUserWithIdExist", () {
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          //  Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          //     ],
          //     [null],
          //     [
          //       [1],
          //     ],
          //   ),
          //   [1],
          // ),
          );
    });

    test("should return true if the user exists", () async {
      // act
      final result = await dataSource.doesUserWithIdExist(tUser.userId);

      // assert
      verify(
        () => database.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          [tUser.userId],
        ),
      );
      expect(result, true);
    });

    test("should return false if the user does not exist", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          //     ],
          //     [],
          //     [
          //       [0],
          //     ],
          //   ),
          //   [0],
          // ),
          );

      // act
      final result = await dataSource.doesUserWithIdExist(tUser.userId);

      // assert
      expect(result, false);
    });
  });

  group("getUser", () {
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tDbCuratorRow);
    });

    test("should return the user if it exists", () async {
      // act
      final result = await dataSource.getUser(
        username: tUser.username,
        passwordHash: tUser.passwordHash,
      );

      // assert
      verify(
        () => database.rawQuery(
          "SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.username} = ? AND ${userTable.passwordHash} = ?",
          [tUser.username, tUser.passwordHash],
        ),
      );
      expect(result, tUser);
    });

    test("should return null if the user does not exist", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => tEmptyDbRow,
      );

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
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tDbCuratorRow);
    });

    test("should return the user if it exists", () async {
      // act
      final result = await dataSource.getUserFromId(tUser.userId);

      // assert
      verify(
        () => database.rawQuery(
          "SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?",
          [tUser.userId],
        ),
      );
      expect(result, tUser);
    });

    test("should return null if the user does not exist", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => tEmptyDbRow,
      );

      // act
      final result = await dataSource.getUserFromId(tUser.userId);

      // assert
      expect(result, null);
    });
  });

  group("isRefreshTokenInUserDb", () {
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userRefreshTokenTable.tableName} WHERE ${userRefreshTokenTable.refreshToken} = ? AND ${userRefreshTokenTable.userId} = ?)",
          //     ],
          //     [],
          //     [
          //       [1],
          //     ],
          //   ),
          //   [1],
          // ),
          );
    });

    test("should return true if the token is in the databas", () async {
      // act
      final result = await dataSource.isRefreshTokenInUserDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      verify(
        () => database.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM "
          "${userRefreshTokenTable.tableName} "
          "WHERE ${userRefreshTokenTable.userId} = ? "
          "AND ${userRefreshTokenTable.refreshToken} = ?)",
          [tUser.userId, tRefreshToken],
        ),
      );
      expect(result, true);
    });

    test("should return false if the token is not in the database", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userRefreshTokenTable.tableName} WHERE ${userRefreshTokenTable.refreshToken} = ? AND ${userRefreshTokenTable.userId} = ?)",
          //     ],
          //     [],
          //     [
          //       [0],
          //     ],
          //   ),
          //   [0],
          // ),
          );

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
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          //     ],
          //     [],
          //     [
          //       [1],
          //     ],
          //   ),
          //   [1],
          // ),
          );
    });

    test("should return true if the user id is taken", () async {
      // act
      final result = await dataSource.isUserIdTaken(tUser.userId);

      // assert
      verify(
        () => database.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          [tUser.userId],
        ),
      );
      expect(result, true);
    });

    test("should return false if the user id is not taken", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.userId} = ?)",
          //     ],
          //     [],
          //     [
          //       [0],
          //     ],
          //   ),
          //   [0],
          // ),
          );

      // act
      final result = await dataSource.isUserIdTaken(tUser.userId);

      // assert
      expect(result, false);
    });
  });

  group("isUsernameTaken", () {
    setUp(() {
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.username} = ?)",
          //     ],
          //     [],
          //     [
          //       [1],
          //     ],
          //   ),
          //   [1],
          // ),
          );
    });

    test("should return true if the username is taken", () async {
      // act
      final result = await dataSource.isUsernameTaken(tUser.username);

      // assert
      verify(
        () => database.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} "
          "WHERE ${userTable.username} = ?)",
          [tUser.username],
        ),
      );
      expect(result, true);
    });

    test("should return false if the username is not taken", () async {
      // arrange
      when(
        () => database.rawQuery(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => []
          // Row(
          //   ResultSet(
          //     [
          //       "SELECT EXISTS(SELECT 1 FROM ${userTable.tableName} WHERE ${userTable.username} = ?)",
          //     ],
          //     [],
          //     [
          //       [0],
          //     ],
          //   ),
          //   [0],
          // ),
          );

      // act
      final result = await dataSource.isUsernameTaken(tUser.username);

      // assert
      expect(result, false);
    });
  });

  group("removeAllRefreshTokensFromDb", () {
    setUp(() {
      when(
        () => database.execute(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tMockResultSet);
    });

    test("should remove all refresh tokens from the database", () async {
      // act
      await dataSource.removeAllRefreshTokensFromDb(tUser.userId);

      // assert
      verify(
        () => database.execute(
          "DELETE FROM ${userRefreshTokenTable.tableName} "
          "WHERE ${userRefreshTokenTable.userId} = ?",
          [tUser.userId],
        ),
      );
    });
  });

  group("removeRefreshTokenFromDb", () {
    setUp(() {
      when(
        () => database.execute(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tMockResultSet);
    });

    test("should remove the refresh token from the database", () async {
      // act
      await dataSource.removeRefreshTokenFromDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      verify(
        () => database.execute(
          "DELETE FROM ${userRefreshTokenTable.tableName} "
          "WHERE ${userRefreshTokenTable.userId} = ? "
          "AND ${userRefreshTokenTable.refreshToken} = ?",
          [tUser.userId, tRefreshToken],
        ),
      );
    });
  });

  group("saveRefreshTokenToDb", () {
    setUp(() {
      when(
        () => database.execute(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => tMockResultSet);
    });

    test("should save the refresh token to the database", () async {
      // act
      await dataSource.saveRefreshTokenToDb(
        userId: tUser.userId,
        refreshToken: tRefreshToken,
      );

      // assert
      verify(
        () => database.execute(
          "INSERT INTO ${userRefreshTokenTable.tableName} "
          "(${userRefreshTokenTable.userId}, ${userRefreshTokenTable.refreshToken}) "
          "VALUES (?, ?)",
          [tUser.userId, tRefreshToken],
        ),
      );
    });
  });
}
