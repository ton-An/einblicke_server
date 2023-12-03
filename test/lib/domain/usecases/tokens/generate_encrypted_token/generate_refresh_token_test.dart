import 'package:dispatch_pi_dart/domain/uscases/tokens/generate_encrypted_token/generate_refresh_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';
import '../../../../../secrets_fixture.dart';

void main() {
  late GenerateRefreshToken generateRefreshToken;
  late MockBasicAuthRepository mockBasicAuthRepository;
  late MockClock mockClock;

  late MockUser tMockUser;

  setUp(() {
    mockBasicAuthRepository = MockBasicAuthRepository();
    mockClock = MockClock();
    generateRefreshToken = GenerateRefreshToken(
      basicAuthRepository: mockBasicAuthRepository,
      secrets: tSecrets,
      clock: mockClock,
    );

    tMockUser = MockUser();

    registerFallbackValue(MockTokenClaims());

    when(() => mockClock.now()).thenReturn(tIssuedAt);
    when(() => mockBasicAuthRepository.generateTokenId()).thenReturn(tTokenId);
    when(() => mockBasicAuthRepository.generateJWEToken(any()))
        .thenReturn(tEncryptedRefreshToken.token);
    when(() => tMockUser.userId).thenReturn(tUserId);
  });

  // should get the current time
  test("should get the current time", () {
    // act
    generateRefreshToken(user: tMockUser);

    // assert
    verify(() => mockClock.now());
  });

  // should generate a token id
  test("should generate a token id", () {
    // act
    generateRefreshToken(user: tMockUser);

    // assert
    verify(() => mockBasicAuthRepository.generateTokenId());
  });

  test("should generate a jwe token", () {
    // act
    generateRefreshToken(user: tMockUser);

    // assert
    verify(() => mockBasicAuthRepository.generateJWEToken(tRefreshTokenClaims));
  });

  test("should return an [EncryptedToken]", () {
    // act
    final result = generateRefreshToken(user: tMockUser);

    // assert
    expect(result, tEncryptedRefreshToken);
  });
}
