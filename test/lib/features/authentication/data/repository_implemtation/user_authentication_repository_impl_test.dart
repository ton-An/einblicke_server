// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late UserAuthenticationRepositoryImpl repository;
  late MockUserAuthenticationLocalDataSource mockUserAuthLocalDataSource;
  late MockUser tMockUser;

  setUp(() {
    mockUserAuthLocalDataSource = MockUserAuthenticationLocalDataSource();
    repository = UserAuthenticationRepositoryImpl(
      userAuthLocalDataSource: mockUserAuthLocalDataSource,
    );

    tMockUser = MockUser();
  });

  group("createUser", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.createUser(
          userId: any(named: "userId"),
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => tMockUser);
    });

    test("should get a [User] from the local data source and return it",
        () async {
      // act
      final result = await repository.createUser(
        tUserId,
        tUsername,
        tPasswordHash,
      );

      // assert
      verify(
        () => mockUserAuthLocalDataSource.createUser(
          userId: tUserId,
          username: tUsername,
          passwordHash: tPasswordHash,
        ),
      );
      expect(result, Right(tMockUser));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source throws a [DatabaseException]",
        () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.createUser(
          userId: any(named: "userId"),
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.createUser(
        tUserId,
        tUsername,
        tPasswordHash,
      );

      // assert
      expect(result, equals(const Left(DatabaseWriteFailure())));
    });
  });

  group("getUser", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.getUser(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => tMockUser);
    });

    test("should get a [User] from the local data source and return it",
        () async {
      // act
      final result = await repository.getUser(
        tUsername,
        tPasswordHash,
      );

      // assert
      verify(
        () => mockUserAuthLocalDataSource.getUser(
          username: tUsername,
          passwordHash: tPasswordHash,
        ),
      );
      expect(result, Right(tMockUser));
    });

    test(
        "should return a [UserNotFoundFailure] if the data source returns null "
        "instead of a user", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.getUser(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => null);

      // act
      final result = await repository.getUser(
        tUsername,
        tPasswordHash,
      );

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.getUser(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.getUser(
        tUsername,
        tPasswordHash,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("getUserFromId", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.getUserFromId(
          any(),
        ),
      ).thenAnswer((_) async => tMockUser);
    });

    test("should get a [User] from the local data source and return it",
        () async {
      // act
      final result = await repository.getUserFromId(tUserId);

      // assert
      verify(
        () => mockUserAuthLocalDataSource.getUserFromId(
          tUserId,
        ),
      );
      expect(result, Right(tMockUser));
    });

    test(
        "should return a [UserNotFoundFailure] if the local data source "
        "returns null instead of a user", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.getUserFromId(
          any(),
        ),
      ).thenAnswer((_) async => null);

      // act
      final result = await repository.getUserFromId(tUserId);

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.getUserFromId(
          any(),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.getUserFromId(tUserId);

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("isRefreshTokenInUserDb", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.isRefreshTokenInUserDb(
          refreshToken: any(named: "refreshToken"),
          userId: any(named: "userId"),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
        "should check if the refresh token is in the user db using the local data source "
        "and return a [bool] with the result ", () async {
      // act
      final result = await repository.isRefreshTokenInUserDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      verify(
        () => mockUserAuthLocalDataSource.isRefreshTokenInUserDb(
          refreshToken: tRefreshToken,
          userId: tUserId,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.isRefreshTokenInUserDb(
          refreshToken: any(named: "refreshToken"),
          userId: any(named: "userId"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.isRefreshTokenInUserDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("isUserIdTaken", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.isUserIdTaken(
          any(),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
        "should check if the user id is taken using the local data source "
        "and return a [bool] with the result ", () async {
      // act
      final result = await repository.isUserIdTaken(tUserId);

      // assert
      verify(
        () => mockUserAuthLocalDataSource.isUserIdTaken(
          tUserId,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseReadFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.isUserIdTaken(
          any(),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.isUserIdTaken(tUserId);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("isUsernameTaken", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.isUsernameTaken(
          any(),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
        "should check if the username is taken using the local data source "
        "and return a [bool] with the result ", () async {
      // act
      final result = await repository.isUsernameTaken(tUsername);

      // assert
      verify(
        () => mockUserAuthLocalDataSource.isUsernameTaken(
          tUsername,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseReadFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.isUsernameTaken(
          any(),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.isUsernameTaken(tUsername);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("removeAllRefreshTokensFromDb", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.removeAllRefreshTokensFromDb(
          any(),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test(
        "should remove all refresh tokens from the db using "
        "the local data source", () async {
      // act
      final result = await repository.removeAllRefreshTokensFromDb(tUserId);

      // assert
      verify(
        () => mockUserAuthLocalDataSource.removeAllRefreshTokensFromDb(
          tUserId,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.removeAllRefreshTokensFromDb(
          any(),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.removeAllRefreshTokensFromDb(tUserId);

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("removeRefreshTokenFromDb", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.removeRefreshTokenFromDb(
          userId: any(named: "userId"),
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test(
        "should remove the refresh token from the db using "
        "the local data source", () async {
      // act
      final result = await repository.removeRefreshTokenFromDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      verify(
        () => mockUserAuthLocalDataSource.removeRefreshTokenFromDb(
          userId: tUserId,
          refreshToken: tRefreshToken,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.removeRefreshTokenFromDb(
          userId: any(named: "userId"),
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.removeRefreshTokenFromDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("saveRefreshTokenToDb", () {
    setUp(() {
      when(
        () => mockUserAuthLocalDataSource.saveRefreshTokenToDb(
          userId: any(named: "userId"),
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test(
        "should save the refresh token to the db using "
        "the local data source", () async {
      // act
      final result = await repository.saveRefreshTokenToDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      verify(
        () => mockUserAuthLocalDataSource.saveRefreshTokenToDb(
          userId: tUserId,
          refreshToken: tRefreshToken,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockUserAuthLocalDataSource.saveRefreshTokenToDb(
          userId: any(named: "userId"),
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await repository.saveRefreshTokenToDb(
        tUserId,
        tRefreshToken,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });
}
