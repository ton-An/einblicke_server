// ignore_for_file: inference_failure_on_instance_creation, inference_failure_on_function_invocation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
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
  late MockGetUserWithType mockGetUserWithType;

  late MockUser tMockUser;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockIsTokenExpired = MockIsTokenExpired();
    mockUserAuthRepository = MockUserAuthRepository();
    mockGetUserWithType = MockGetUserWithType();
    checkAccessTokenValidity =
        CheckAccessTokenValidityWrapper<MockUser, MockUserAuthRepository>(
      basicAuthRepository: mockBasicAuthRepository,
      isTokenExpiredUseCase: mockIsTokenExpired,
      userAuthenticationRepository: mockUserAuthRepository,
      getUserWithType: mockGetUserWithType,
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

    when(
      () => mockGetUserWithType(
        userId: any(named: "userId"),
        userType: any(named: "userType"),
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
    test("should get the user with type", () async {
      // act
      await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      verify(
        () => mockGetUserWithType(
          userId: tAccessTokenClaims.userId,
          userType: MockUser,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockGetUserWithType(
          userId: any(named: "userId"),
          userType: any(named: "userType"),
        ),
      ).thenAnswer(
        (_) async => const Left(
          DatabaseReadFailure(),
        ),
      );

      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  test("should return a user", () async {
    // act
    final result = await checkAccessTokenValidity(accessToken: tAccessToken);

    // assert
    expect(result, Right(tMockUser));
  });
}
