import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/curator_auth_repository_impl.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CuratorAuthenticationRepositoryImpl curatorAuthRepositoryImpl;
  late MockCuratorAuthLocalDataSource mockCuratorAuthLocalDataSource;

  setUp(() {
    mockCuratorAuthLocalDataSource = MockCuratorAuthLocalDataSource();
    curatorAuthRepositoryImpl = CuratorAuthenticationRepositoryImpl(
      userAuthLocalDataSource: mockCuratorAuthLocalDataSource,
    );
  });

  group("createCurator", () {
    setUp(() {
      when(
        () => mockCuratorAuthLocalDataSource.createCurator(
          userId: any(named: "userId"),
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => tCurator);
    });

    test("should get a [Curator] from the local data source and return it",
        () async {
      // act
      final result = await curatorAuthRepositoryImpl.createCurator(
        userId: tUserId,
        username: tUsername,
        passwordHash: tPasswordHash,
      );

      // assert
      verify(
        () => mockCuratorAuthLocalDataSource.createCurator(
          userId: tUserId,
          username: tUsername,
          passwordHash: tPasswordHash,
        ),
      );
      expect(result, const Right(tCurator));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source throws a [DatabaseException]",
        () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.createCurator(
          userId: any(named: "userId"),
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await curatorAuthRepositoryImpl.createCurator(
        userId: tUserId,
        username: tUsername,
        passwordHash: tPasswordHash,
      );

      // assert
      expect(result, equals(const Left(DatabaseWriteFailure())));
    });
  });

  group("getCuratorFromCredentials", () {
    setUp(() {
      when(
        () => mockCuratorAuthLocalDataSource.getCuratorFromCredentials(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => tCurator);
    });

    test("should get a [Curator] from the local data source and return it",
        () async {
      // act
      final result = await curatorAuthRepositoryImpl.getCuratorFromCredentials(
        username: tUsername,
        passwordHash: tPasswordHash,
      );

      // assert
      verify(
        () => mockCuratorAuthLocalDataSource.getCuratorFromCredentials(
          username: tUsername,
          passwordHash: tPasswordHash,
        ),
      );
      expect(result, const Right(tCurator));
    });

    test(
        "should return a [UserNotFoundFailure] if the data source returns null "
        "instead of a curator", () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.getCuratorFromCredentials(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => null);

      // act
      final result = await curatorAuthRepositoryImpl.getCuratorFromCredentials(
        username: tUsername,
        passwordHash: tPasswordHash,
      );

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.getCuratorFromCredentials(
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await curatorAuthRepositoryImpl.getCuratorFromCredentials(
        username: tUsername,
        passwordHash: tPasswordHash,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("getUserFromId", () {
    setUp(() {
      when(
        () => mockCuratorAuthLocalDataSource.getUserFromId(
          userId: any(named: "userId"),
        ),
      ).thenAnswer((_) async => tCurator);
    });

    test("should get a [Curator] from the local data source and return it",
        () async {
      // act
      final result = await curatorAuthRepositoryImpl.getUserFromId(
        userId: tCuratorId,
      );

      // assert
      verify(
        () => mockCuratorAuthLocalDataSource.getUserFromId(
          userId: tCuratorId,
        ),
      );
      expect(result, const Right(tCurator));
    });

    test(
        "should return a [UserNotFoundFailure] if the local data source "
        "returns null instead of a curator", () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.getUserFromId(
          userId: any(named: "userId"),
        ),
      ).thenAnswer((_) async => null);

      // act
      final result = await curatorAuthRepositoryImpl.getUserFromId(
        userId: tCuratorId,
      );

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.getUserFromId(
          userId: any(named: "userId"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await curatorAuthRepositoryImpl.getUserFromId(
        userId: tCuratorId,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("isUsernameTaken", () {
    setUp(() {
      when(
        () => mockCuratorAuthLocalDataSource.isUsernameTaken(
          username: any(named: "username"),
        ),
      ).thenAnswer((_) async => true);
    });

    test(
        "should check if the username is taken using the local data source "
        "and return a [bool] with the result ", () async {
      // act
      final result = await curatorAuthRepositoryImpl.isUsernameTaken(
        username: tCuratorUsername,
      );

      // assert
      verify(
        () => mockCuratorAuthLocalDataSource.isUsernameTaken(
          username: tCuratorUsername,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseReadFailure] when the local data source "
        "throws a [DatabaseException]", () async {
      // arrange
      when(
        () => mockCuratorAuthLocalDataSource.isUsernameTaken(
          username: any(named: "username"),
        ),
      ).thenThrow(MockDatabaseException());

      // act
      final result = await curatorAuthRepositoryImpl.isUsernameTaken(
        username: tCuratorUsername,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });
}
