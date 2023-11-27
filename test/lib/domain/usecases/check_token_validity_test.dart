import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/token_decryption_failure.dart';
import 'package:dispatch_pi_dart/domain/uscases/check_token_validity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late CheckTokenValidity checkTokenValidity;
  late MockBasicAuthRepository mockBasicAuthRepository;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    checkTokenValidity = CheckTokenValidity(
      basicAuthRepository: mockBasicAuthRepository,
    );

    when(
      () => mockBasicAuthRepository.decryptToken(any()),
    ).thenReturn(const Right(tTokenString));

    when(
      () => mockBasicAuthRepository.isTokenValid(any()),
    ).thenReturn(const Right(tUserId));
  });

  group("should decrypt the token", () {
    test("should decrypt the token string", () {
      // act
      checkTokenValidity(tEncryptedTokenString);

      // assert
      verify(() => mockBasicAuthRepository.decryptToken(tEncryptedTokenString));
    });

    test("should relay failures", () async {
      // arrange
      when(
        () => mockBasicAuthRepository.decryptToken(any()),
      ).thenReturn(
        const Left(TokenDecryptionFailure()),
      );

      // act
      final result = checkTokenValidity(tEncryptedTokenString);

      // assert
      expect(result, const Left(TokenDecryptionFailure()));
    });
  });

  group("check if signature is valid", () {
    test("should check if the token is valid", () {
      // act
      checkTokenValidity(tEncryptedTokenString);

      // assert
      verify(() => mockBasicAuthRepository.isTokenValid(tTokenString));
    });

    test("should relay failures", () async {
      // arrange
      when(
        () => mockBasicAuthRepository.isTokenValid(any()),
      ).thenReturn(
        const Left(ExpiredTokenFailure()),
      );

      // act
      final result = checkTokenValidity(tEncryptedTokenString);

      // assert
      expect(result, const Left(ExpiredTokenFailure()));
    });

    test("should return the userId if the token is valid", () async {
      // arrange
      when(
        () => mockBasicAuthRepository.isTokenValid(any()),
      ).thenReturn(
        const Right(tUserId),
      );

      // act
      final result = checkTokenValidity(tEncryptedTokenString);

      // assert
      expect(result, const Right(tUserId));
    });
  });
}
