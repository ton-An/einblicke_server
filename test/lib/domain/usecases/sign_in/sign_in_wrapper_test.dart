// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/sign_in/sign_in_wrapper.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late SignInWrapper<User, UserAuthenticationRepository<User>> signInWrapper;
  late MockUserAuthRepository mockUserAuthRepository;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockGenerateAccessToken mockGenerateAccessToken;
  late MockGenerateRefreshToken mockGenerateRefreshToken;

  late MockUser tMockUser;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockGenerateAccessToken = MockGenerateAccessToken();
    mockGenerateRefreshToken = MockGenerateRefreshToken();

    signInWrapper = SignInWrapper(
      userAuthRepository: mockUserAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
      generateAccessToken: mockGenerateAccessToken,
      generateRefreshToken: mockGenerateRefreshToken,
    );

    tMockUser = MockUser();

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

    group("return AuthenticationCredentials", () {
      test("should return AuthenticationCredentials if the user is found",
          () async {
        // act
        final result = await signInWrapper(
          username: tUsername,
          password: tPassword,
        );

        // assert
        expect(result, const Right(tAuthenticationCredentials));
      });
    });
  });
}
