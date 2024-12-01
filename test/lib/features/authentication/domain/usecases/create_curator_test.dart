import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_curator.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CreateCurator createCurator;
  late MockIsUsernameValid mockIsUsernameValid;
  late MockIsPasswordValid mockIsPasswordValid;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockCuratorAuthRepository mockCuratorAuthRepository;
  late MockGenerateUserId mockGenerateUserId;

  setUp(() {
    mockIsUsernameValid = MockIsUsernameValid();
    mockIsPasswordValid = MockIsPasswordValid();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockCuratorAuthRepository = MockCuratorAuthRepository();
    mockGenerateUserId = MockGenerateUserId();

    createCurator = CreateCurator(
      isUsernameValid: mockIsUsernameValid,
      isPasswordValid: mockIsPasswordValid,
      curatorAuthRepository: mockCuratorAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
      generateUserId: mockGenerateUserId,
    );

    when(() => mockIsUsernameValid(any())).thenReturn(true);
    when(() => mockIsPasswordValid(any())).thenReturn(true);
    when(
      () => mockCuratorAuthRepository.isUsernameTaken(
        username: any(named: "username"),
      ),
    ).thenAnswer((_) async => const Right(false));
    when(() => mockGenerateUserId())
        .thenAnswer((_) async => const Right(tUserId));
    when(
      () => mockCuratorAuthRepository.isUserIdTaken(
        userId: any(named: "userId"),
      ),
    ).thenAnswer((_) async => const Right(false));
    when(() => mockBasicAuthRepository.generatePasswordHash(any()))
        .thenReturn(tPasswordHash);
    when(
      () => mockCuratorAuthRepository.createCurator(
        userId: any(named: "userId"),
        username: any(named: "username"),
        passwordHash: any(named: "passwordHash"),
      ),
    ).thenAnswer((_) async => const Right(tCurator));
  });

  group("username validity", () {
    test("should check if username is valid", () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(() => mockIsUsernameValid(tUsername));
    });

    test(
        "should return a [InvalidUsernameFailure] "
        "if the given username is invalid", () async {
      // arrange
      when(() => mockIsUsernameValid(any())).thenReturn(false);

      // act
      final result = await createCurator(tInvalidUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(InvalidUsernameFailure()));
    });
  });

  group("password validity", () {
    test("should check if password is valid", () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(() => mockIsPasswordValid(tPassword));
    });

    test(
        "should return a [InvalidPasswordFailure] "
        "if the given password is invalid", () async {
      // arrange
      when(() => mockIsPasswordValid(any())).thenReturn(false);

      // act
      final result = await createCurator(tUsername, tInvalidPassword);

      // assert
      expect(result, const Left<Failure, Curator>(InvalidPasswordFailure()));
    });
  });

  group("is username taken check", () {
    test("should check if username is taken", () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(
          () => mockCuratorAuthRepository.isUsernameTaken(username: tUsername));
    });

    test(
        "should return a [UsernameTakenFailure] "
        "if the given username is taken", () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.isUsernameTaken(
          username: any(named: "username"),
        ),
      ).thenAnswer((_) async => const Right(true));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(UsernameTakenFailure()));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.isUsernameTaken(
          username: any(named: "username"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(DatabaseReadFailure()));
    });
  });

  group("user id generation", () {
    test("should generate a user id", () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(() => mockGenerateUserId());
    });

    test("should relay a [Failure] if the user id generation fails", () async {
      // arrange
      when(() => mockGenerateUserId())
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(DatabaseReadFailure()));
    });
  });

  group("password hash generation", () {
    test("should generate a hash of the given password", () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(() => mockBasicAuthRepository.generatePasswordHash(tPassword));
    });
  });

  group("curator creation", () {
    test("should create a curator with the given username and password hash",
        () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(
        () => mockCuratorAuthRepository.createCurator(
          userId: tUserId,
          username: tUsername,
          passwordHash: tPasswordHash,
        ),
      );
    });

    test("should return a [Curator] if the curator is created", () async {
      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Right<Failure, Curator>(tCurator));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(
        () => mockCuratorAuthRepository.createCurator(
          userId: any(named: "userId"),
          username: any(named: "username"),
          passwordHash: any(named: "passwordHash"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(DatabaseReadFailure()));
    });
  });
}
