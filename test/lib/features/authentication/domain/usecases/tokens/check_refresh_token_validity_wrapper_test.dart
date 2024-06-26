// ignore_for_file: inference_failure_on_instance_creation, inference_failure_on_function_invocation

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/check_refresh_token_validity.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../fixtures.dart';
import '../../../../../../mocks.dart';

void main() {
  late CheckRefreshTokenValidityWrapper<MockUser, MockUserAuthRepository>
      checkRefreshTokenValidityWrapper;
  late MockUserAuthRepository mockUserAuthenticationRepository;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockIsTokenExpired mockIsTokenExpired;
  late MockGetUserWithType mockGetUserWithType;

  late MockUser tMockUser;

  setUp(() {
    mockUserAuthenticationRepository = MockUserAuthRepository();
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockIsTokenExpired = MockIsTokenExpired();
    mockGetUserWithType = MockGetUserWithType();
    checkRefreshTokenValidityWrapper =
        CheckRefreshTokenValidityWrapper<MockUser, MockUserAuthRepository>(
      userAuthRepository: mockUserAuthenticationRepository,
      basicAuthRepository: mockBasicAuthRepository,
      isTokenExpiredUseCase: mockIsTokenExpired,
      getUserWithType: mockGetUserWithType,
    );

    tMockUser = MockUser();

    when(
      () => mockBasicAuthRepository.checkTokenSignatureValidity(
        any(),
      ),
    ).thenAnswer(
      (_) async => Right(tAccessTokenClaims),
    );

    when(
      () => mockIsTokenExpired(
        expiresAt: any(named: "expiresAt"),
      ),
    ).thenReturn(false);

    when(
      () => mockUserAuthenticationRepository.isRefreshTokenInUserDb(
        any(),
        any(),
      ),
    ).thenAnswer(
      (_) async => const Right(true),
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

  group("check token validity", () {
    test("should check if the refresh token is valid", () async {
      // act
      await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      verify(
        () => mockBasicAuthRepository.checkTokenSignatureValidity(
          tRefreshToken,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockBasicAuthRepository.checkTokenSignatureValidity(
          any(),
        ),
      ).thenAnswer((_) async => const Left(TokenVerificationFailure()));

      // act
      final result =
          await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      expect(result, const Left(TokenVerificationFailure()));
    });
  });

  group("expiration check", () {
    test("should check if the token is expired", () async {
      // act
      await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      verify(
        () => mockIsTokenExpired(
          expiresAt: tValidExpiresAt,
        ),
      );
    });

    test("should return a [TokenExpirationFailure] if the token is expired",
        () async {
      // arrange
      when(
        () => mockIsTokenExpired(
          expiresAt: any(named: "expiresAt"),
        ),
      ).thenReturn(true);

      // act
      final result =
          await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      expect(result, const Left(ExpiredTokenFailure()));
    });
  });

  group("re-use check", () {
    test("should check if the token is being re-used", () async {
      // act
      await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      verify(
        () => mockUserAuthenticationRepository.isRefreshTokenInUserDb(
          tUserId,
          tRefreshToken,
        ),
      );
    });

    test(
        "should return a [RefreshTokenReuseFailure] if the token is being re-used",
        () async {
      // arrange
      when(
        () => mockUserAuthenticationRepository.isRefreshTokenInUserDb(
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => const Right(false),
      );

      // act
      final result =
          await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      expect(result, const Left(RefreshTokenReuseFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockUserAuthenticationRepository.isRefreshTokenInUserDb(
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => const Left(
          DatabaseReadFailure(),
        ),
      );

      // act
      final result =
          await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("get user", () {
    test("should get the user with type", () async {
      // act
      await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      verify(
        () => mockGetUserWithType(
          userId: tUserId,
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
      final result =
          await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  test("should return a user if the token is valid", () async {
    // act
    final result =
        await checkRefreshTokenValidityWrapper(refreshToken: tRefreshToken);

    // assert
    expect(result, Right(tMockUser));
  });
}
