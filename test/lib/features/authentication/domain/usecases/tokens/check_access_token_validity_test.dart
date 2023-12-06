// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_user_role_failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../fixtures.dart';
import '../../../../../../mocks.dart';

void main() {
  late CheckAccessTokenValidityWrapper checkAccessTokenValidity;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockIsTokenExpired mockIsTokenExpired;
  late MockUserAuthRepository mockUserAuthRepository;

  late MockUser tMockUser;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockIsTokenExpired = MockIsTokenExpired();
    mockUserAuthRepository = MockUserAuthRepository();
    checkAccessTokenValidity =
        CheckAccessTokenValidityWrapper<MockUser, MockUserAuthRepository>(
      basicAuthRepository: mockBasicAuthRepository,
      isTokenExpiredUseCase: mockIsTokenExpired,
      userAuthenticationRepository: mockUserAuthRepository,
    );

    tMockUser = MockUser();

    when(
      () => mockBasicAuthRepository.checkTokenSignatureValidity(
        any(),
      ),
    ).thenAnswer(
      (_) => Right(tAccessTokenClaims),
    );

    when(
      () => mockIsTokenExpired(
        expiresAt: any(named: "expiresAt"),
      ),
    ).thenReturn(false);

    when(
      () => mockUserAuthRepository.getUserFromId(
        any(),
      ),
    ).thenAnswer(
      (_) async => Right(tMockUser),
    );
  });

  group("check signature ", () {
    test("should check if the access token signature is valid", () async {
      // act
      await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      verify(
        () => mockBasicAuthRepository.checkTokenSignatureValidity(
          tAccessToken,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockBasicAuthRepository.checkTokenSignatureValidity(
          any(),
        ),
      ).thenAnswer(
        (_) => const Left(InvalidTokenFailure()),
      );

      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Left(InvalidTokenFailure()));
    });
  });

  group("check expiration", () {
    test("should check if the access token is expired", () async {
      // act
      await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      verify(
        () => mockIsTokenExpired(
          expiresAt: tAccessTokenClaims.expiresAt,
        ),
      );
    });

    test("should return a [ExpiredTokenFailure] if the token is expired",
        () async {
      // arrange
      when(
        () => mockIsTokenExpired(
          expiresAt: any(named: "expiresAt"),
        ),
      ).thenReturn(true);

      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Left(ExpiredTokenFailure()));
    });
  });

  group("get user", () {
    test("should get the user and return it", () async {
      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, Right(tMockUser));
      verify(
        () => mockUserAuthRepository.getUserFromId(
          tAccessTokenClaims.userId,
        ),
      );
    });

    test("should return a [InvalidUserTypeFailure] if the user type is invalid",
        () async {
      // arrange
      when(() => mockBasicAuthRepository.checkTokenSignatureValidity(any()))
          .thenAnswer(
        (_) => Right(tInvalidUserTypeAccessTokenClaims),
      );

      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Left(InvalidUserTypeFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockUserAuthRepository.getUserFromId(
          any(),
        ),
      ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Left(UserNotFoundFailure()));
    });
  });
}
