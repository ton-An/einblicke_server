import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_user.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late CreateUserWrapper<User, UserAuthenticationRepository<User>> createUser;
  late MockIsUsernameValid mockIsUsernameValid;
  late MockIsPasswordValid mockIsPasswordValid;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockUserAuthRepository mockUserAuthRepository;
  late MockCryptoRepository mockCryptoRepository;

  late MockUser tMockUser;

  setUp(() {
    mockIsUsernameValid = MockIsUsernameValid();
    mockIsPasswordValid = MockIsPasswordValid();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockUserAuthRepository = MockUserAuthRepository();
    mockCryptoRepository = MockCryptoRepository();

    createUser = CreateUserWrapper(
      isUsernameValid: mockIsUsernameValid,
      isPasswordValid: mockIsPasswordValid,
      userAuthRepository: mockUserAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
      cryptoRepository: mockCryptoRepository,
    );

    tMockUser = MockUser();

    when(() => mockIsUsernameValid(any())).thenReturn(true);
    when(() => mockIsPasswordValid(any())).thenReturn(true);
    when(() => mockUserAuthRepository.isUsernameTaken(any()))
        .thenAnswer((_) async => const Right(false));
    when(() => mockCryptoRepository.generateUuid()).thenReturn(tUserId);
    when(() => mockUserAuthRepository.isUserIdTaken(any()))
        .thenAnswer((_) async => const Right(false));
    when(() => mockBasicAuthRepository.generatePasswordHash(any()))
        .thenReturn(tPasswordHash);
    when(() => mockUserAuthRepository.createUser(any(), any(), any()))
        .thenAnswer((_) async => Right(tMockUser));
  });

  group("username validity", () {
    test("should check if username is valid", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockIsUsernameValid(tUsername));
    });

    test(
        "should return a [InvalidUsernameFailure] "
        "if the given username is invalid", () async {
      // arrange
      when(() => mockIsUsernameValid(any())).thenReturn(false);

      // act
      final result = await createUser(tInvalidUsername, tPassword);

      // assert
      expect(result, const Left<Failure, User>(InvalidUsernameFailure()));
    });
  });

  group("password validity", () {
    test("should check if password is valid", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockIsPasswordValid(tPassword));
    });

    test(
        "should return a [InvalidPasswordFailure] "
        "if the given password is invalid", () async {
      // arrange
      when(() => mockIsPasswordValid(any())).thenReturn(false);

      // act
      final result = await createUser(tUsername, tInvalidPassword);

      // assert
      expect(result, const Left<Failure, User>(InvalidPasswordFailure()));
    });
  });

  group("is username taken check", () {
    test("should check if username is taken", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockUserAuthRepository.isUsernameTaken(tUsername));
    });

    test(
        "should return a [UsernameTakenFailure] "
        "if the given username is taken", () async {
      // arrange
      when(() => mockUserAuthRepository.isUsernameTaken(any()))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await createUser(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, User>(UsernameTakenFailure()));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(() => mockUserAuthRepository.isUsernameTaken(any()))
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createUser(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, User>(DatabaseReadFailure()));
    });
  });

  // generate user id
  // check user id

  group("user id generation", () {
    test("should generate a user id", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockCryptoRepository.generateUuid());
    });
  });

  group("check user id", () {
    test("should check if user id is taken", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockUserAuthRepository.isUserIdTaken(tUserId));
    });

    // should generate another user id if the first one is taken
    // should return a [UserIdGenerationFailure] if the user id generation fails after 5 attempts

    test("should generate another user id if the first one is taken", () async {
      // arrange
      final List<bool> isUserIdTakenAnswers = [true, false];

      when(() => mockUserAuthRepository.isUserIdTaken(any()))
          .thenAnswer((_) async => Right(isUserIdTakenAnswers.removeAt(0)));

      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockCryptoRepository.generateUuid()).called(2);
    });

    test(
        "should return a [UserIdGenerationFailure] "
        "if the user id generation fails 5 times", () async {
      // arrange
      when(() => mockUserAuthRepository.isUserIdTaken(any()))
          .thenAnswer((_) async => const Right(true));

      // act
      final result = await createUser(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, User>(UserIdGenerationFailure()));
      verify(() => mockCryptoRepository.generateUuid()).called(5);
    });
  });

  group("password hash generation", () {
    test("should generate a hash of the given password", () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockBasicAuthRepository.generatePasswordHash(tPassword));
    });
  });

  group("user creation", () {
    test("should create a user with the given username and password hash",
        () async {
      // act
      await createUser(tUsername, tPassword);

      // assert
      verify(() => mockUserAuthRepository.createUser(
            tUserId,
            tUsername,
            tPasswordHash,
          ));
    });

    test("should return a [User] if the user is created", () async {
      // act
      final result = await createUser(tUsername, tPassword);

      // assert
      expect(result, Right<Failure, User>(tMockUser));
    });

    test("should relay a [Failure] if the repository returns one", () async {
      // arrange
      when(() => mockUserAuthRepository.createUser(any(), any(), any()))
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await createUser(tUsername, tPassword);

      // assert
      expect(result, const Left<Failure, User>(DatabaseReadFailure()));
    });
  });
}
