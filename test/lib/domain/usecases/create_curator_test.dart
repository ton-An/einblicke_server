import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_username_failure.dart';
import 'package:dispatch_pi_dart/core/failures/username_taken_failure.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_curator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late CreateCurator createCurator;
  late MockIsUsernameValid mockIsUsernameValid;
  late MockIsPasswordValid mockIsPasswordValid;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockIsUsernameValid = MockIsUsernameValid();
    mockIsPasswordValid = MockIsPasswordValid();
    mockAuthenticationRepository = MockAuthenticationRepository();
    createCurator = CreateCurator(
      isUsernameValid: mockIsUsernameValid,
      isPasswordValid: mockIsPasswordValid,
      repository: mockAuthenticationRepository,
    );
  });

  setUp(() {
    when(() => mockIsUsernameValid(any())).thenReturn(true);
    when(() => mockIsPasswordValid(any())).thenReturn(true);
    when(() => mockAuthenticationRepository.isCuratorUsernameTaken(any()))
        .thenAnswer((_) async => const Right(false));
    when(() => mockAuthenticationRepository.generatePasswordHash(any()))
        .thenReturn(tPasswordHash);
    when(() => mockAuthenticationRepository.createCurator(any(), any()))
        .thenAnswer((_) async => const Right(tCurator));
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
          () => mockAuthenticationRepository.isCuratorUsernameTaken(tUsername));
    });

    test(
        "should return a [UsernameTakenFailure] "
        "if the given username is taken", () async {
      // arrange
      when(() => mockAuthenticationRepository.isCuratorUsernameTaken(any()))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(UsernameTakenFailure()));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(() => mockAuthenticationRepository.isCuratorUsernameTaken(any()))
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
      verify(
          () => mockAuthenticationRepository.generatePasswordHash(tPassword));
    });
  });

  group("curator creation", () {
    test("should create a curator with the given username and password hash",
        () async {
      // act
      await createCurator(tUsername, tPassword);

      // assert
      verify(() => mockAuthenticationRepository.createCurator(
            tUsername,
            tPasswordHash,
          ));
    });

    test("should return a [Curator] if the curator is created", () async {
      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Right<Failure, Curator>(tCurator));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(() => mockAuthenticationRepository.createCurator(any(), any()))
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createCurator(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, Curator>(DatabaseReadFailure()));
    });
  });
}
