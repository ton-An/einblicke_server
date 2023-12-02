// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/check_access_token_validity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late CheckAccessTokenValidity checkAccessTokenValidity;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockIsTokenExpired mockIsTokenExpired;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockIsTokenExpired = MockIsTokenExpired();
    checkAccessTokenValidity = CheckAccessTokenValidity(
      basicAuthRepository: mockBasicAuthRepository,
      isTokenExpiredUseCase: mockIsTokenExpired,
    );

    when(
      () => mockBasicAuthRepository.checkTokenSignatureValidity(
        any(),
      ),
    ).thenAnswer(
      (_) => Right(tTokenPayload),
    );

    when(
      () => mockIsTokenExpired(
        expiresAt: any(named: "expiresAt"),
      ),
    ).thenReturn(false);
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
          expiresAt: tTokenPayload.expiresAt,
        ),
      );
    });

    test("should return the userId if the token is valid", () async {
      // act
      final result = await checkAccessTokenValidity(accessToken: tAccessToken);

      // assert
      expect(result, const Right(tUserId));
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
}
