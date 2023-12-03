import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token/generate_access_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';
import '../../../../../secrets_fixture.dart';

void main() {
  late GenerateAccessToken generateAccessToken;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockClock mockClock;

  late MockUser tMockUser;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockClock = MockClock();
    generateAccessToken = GenerateAccessToken(
      basicAuthRepository: mockBasicAuthRepository,
      clock: mockClock,
      secrets: tSecrets,
    );

    tMockUser = MockUser();

    registerFallbackValue(MockTokenClaims());

    when(() => mockClock.now()).thenReturn(tIssuedAt);
    when(() => mockBasicAuthRepository.generateJWEToken(any()))
        .thenReturn(tEncryptedToken.token);
    when(() => tMockUser.userId).thenReturn(tUserId);
  });

  // should get the current time
  test("should get the current time", () {
    // act
    generateAccessToken(user: tMockUser);

    // assert
    verify(() => mockClock.now());
  });

  test("should generate a jwe token", () {
    // act
    generateAccessToken(user: tMockUser);

    // assert
    verify(() => mockBasicAuthRepository.generateJWEToken(tAccessTokenClaims));
  });

  test("should return an [EncryptedToken]", () {
    // act
    final result = generateAccessToken(user: tMockUser);

    // assert
    expect(result, tEncryptedToken);
  });
}
