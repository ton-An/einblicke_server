import 'package:einblicke_server/core/db_names.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../database_mocks.dart';
import '../../../../../fixtures.dart';

// ToDo: Need to clean up the database tests (especially the test query results)

class FakeUserAuthLocalDataSourceImpl<U extends User>
    extends UserAuthenticationLocalDataSource<U>
    with UserAuthLocalDataSourceImpl<U> {
  FakeUserAuthLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.userTableNames,
    required this.refreshTokenTableNames,
  });

  @override
  final Database sqliteDatabase;

  @override
  final UserTable<U> userTableNames;

  @override
  final UserRefreshTokenTable<U> refreshTokenTableNames;

  @override
  Future<U?> getUserFromId({required String userId}) {
    // TODO: implement getUserFromId
    throw UnimplementedError();
  }
}

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

    userRefreshTokenTable = const CuratorRefreshTokenTable();
    userTable = const CuratorTable();
    dataSource = FakeUserAuthLocalDataSourceImpl<Curator>(
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
      await dataSource.removeAllRefreshTokensFromDb(userId: tUser.userId);

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
