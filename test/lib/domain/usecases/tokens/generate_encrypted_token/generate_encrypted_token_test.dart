import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token/generate_encrypted_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GenerateEncryptedToken generateEncryptedToken;
  late MockBasicAuthRepository mockBasicAuthRepository;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    generateEncryptedToken = GenerateEncryptedToken(
      basicAuthRepository: mockBasicAuthRepository,
    );

    when(() => mockBasicAuthRepository.generateJWEToken(any(), any()))
        .thenReturn(tTokenString);
  });

  test("should generate a signed token", () async {
    // act
    generateEncryptedToken(payload: tPayload, expiresIn: tExpiresAt);

    // assert
    verify(
      () => mockBasicAuthRepository.generateJWEToken(tPayload, tExpiresAt),
    );
  });

  test("should return the encrypted token", () async {
    // act
    final result =
        generateEncryptedToken(payload: tPayload, expiresIn: tExpiresAt);

    // assert
    expect(result, tEncryptedToken);
  });
}
