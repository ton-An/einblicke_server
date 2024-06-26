// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late SignInWrapper<User, UserAuthenticationRepository<User>> signInWrapper;
  late MockUserAuthRepository mockUserAuthRepository;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockGenerateAccessToken mockGenerateAccessToken;
  late MockGenerateRefreshToken mockGenerateRefreshToken;
  late MockSaveRefreshToken mockSaveRefreshToken;

  late MockUser tMockUser;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockGenerateAccessToken = MockGenerateAccessToken();
    mockGenerateRefreshToken = MockGenerateRefreshToken();
    mockSaveRefreshToken = MockSaveRefreshToken();

    signInWrapper = SignInWrapper(
      userAuthRepository: mockUserAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
      generateAccessToken: mockGenerateAccessToken,
      generateRefreshToken: mockGenerateRefreshToken,
      saveRefreshTokenUsecase: mockSaveRefreshToken,
    );

    tMockUser = MockUser();

    registerFallbackValue(MockEncryptedToken());

    when(() => mockBasicAuthRepository.generatePasswordHash(any()))
        .thenReturn(tPasswordHash);
    when(
      () => mockUserAuthRepository.getUser(
        any(),
        any(),
      ),
    ).thenAnswer((_) async => Right(tMockUser));
    when(() => mockGenerateAccessToken(user: tMockUser))
        .thenReturn(tEncryptedAccessToken);
    when(() => mockGenerateRefreshToken(user: tMockUser))
        .thenReturn(tEncryptedRefreshToken);
    when(() => tMockUser.userId).thenReturn(tUserId);
    when(
      () => mockSaveRefreshToken(
        userId: any(named: "userId"),
        refreshToken: any(named: "refreshToken"),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  group("get hashed version of password", () {
    test("should get hashed version of the password", () async {
      // act
      await signInWrapper(
        username: tUsername,
        password: tPassword,
      );

      // assert
      verify(() => mockBasicAuthRepository.generatePasswordHash(tPassword));
    });
  });

  group("get user with username and hashed password", () {
    test("should get user with the  username and hashed password", () async {
      // act
      await signInWrapper(
        username: tUsername,
        password: tPassword,
      );

      // assert
      verify(
        () => mockUserAuthRepository.getUser(
          tUsername,
          tPasswordHash,
        ),
      );
    });

    test("should relay Failures if getting the user fails", () async {
      // arrange
      when(
        () => mockUserAuthRepository.getUser(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

      // act
      final result = await signInWrapper(
        username: tUsername,
        password: tPassword,
      );

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });
  });

  group("if the user exists", () {
    group("generate access token", () {
      test("should generate an access token if the user is found", () async {
        // act
        await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        verify(() => mockGenerateAccessToken(user: tMockUser));
      });
    });

    group("generate refresh token", () {
      test("should generate a refresh token if the user is found", () async {
        // act
        await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        verify(() => mockGenerateRefreshToken(user: tMockUser));
      });
    });

    group("save the refresh token", () {
      test("should save the refresh token", () async {
        // act
        await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        verify(
          () => mockSaveRefreshToken(
            userId: tUserId,
            refreshToken: tEncryptedRefreshToken,
          ),
        );
      });

      test("should relay [Failure]s", () async {
        // arrange
        when(
          () => mockSaveRefreshToken(
            userId: any(named: "userId"),
            refreshToken: any(named: "refreshToken"),
          ),
        ).thenAnswer((_) async => const Left(DatabaseWriteFailure()));

        // act
        final result = await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        expect(result, const Left(DatabaseWriteFailure()));
      });
    });

    group("return AuthenticationCredentials", () {
      test("should return AuthenticationCredentials if the user is found",
          () async {
        // act
        final result = await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        expect(result, Right(tAuthenticationCredentials));
      });
    });
  });
}
