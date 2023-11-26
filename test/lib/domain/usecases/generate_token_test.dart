// should generate a token and sign it
// should encrypt the token
// should return the encrypted token

import 'package:dispatch_pi_dart/domain/uscases/generate_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late GenerateEncryptedToken generateEncryptedToken;
  late MockBasicAuthRepository mockBasicAuthRepository;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    generateEncryptedToken = GenerateEncryptedToken(
      basicAuthRepository: mockBasicAuthRepository,
    );

    when(() => mockBasicAuthRepository.generateSignedToken(any()))
        .thenReturn(tToken);
    when(() => mockBasicAuthRepository.encryptToken(any()))
        .thenReturn(tEncryptedTokenString);
  });

  test("should generate a signed token", () async {
    // act
    generateEncryptedToken(payload: tPayload, expiresIn: tExpiresIn);

    // assert
    verify(() => mockBasicAuthRepository.generateSignedToken(tPayload));
  });

  test("should encrypt the token", () async {
    // act
    generateEncryptedToken(payload: tPayload, expiresIn: tExpiresIn);

    // assert
    verify(() => mockBasicAuthRepository.encryptToken(tToken));
  });

  test("should return the encrypted token", () async {
    // act
    final result =
        generateEncryptedToken(payload: tPayload, expiresIn: tExpiresIn);

    // assert
    expect(result, tEncryptedToken);
  });
}
