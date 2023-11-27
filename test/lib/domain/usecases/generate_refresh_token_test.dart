import 'package:dispatch_pi_dart/domain/uscases/generate_refresh_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';
import '../../../secrets_fixture.dart';

void main() {
  late GenerateRefreshToken generateRefreshToken;
  late MockGenerateEncryptedToken mockGenerateEncryptedToken;

  late MockUser tMockUser;

  setUp(() {
    mockGenerateEncryptedToken = MockGenerateEncryptedToken();
    generateRefreshToken = GenerateRefreshToken(
      generateEncryptedToken: mockGenerateEncryptedToken,
      secrets: tSecrets,
    );

    tMockUser = MockUser();

    when(() => tMockUser.userId).thenReturn(tUserId);
    when(
      () => mockGenerateEncryptedToken(
        payload: any(named: 'payload'),
        expiresIn: any(named: 'expiresIn'),
      ),
    ).thenReturn(tEncryptedToken);
  });

  // should generate an encrypted token with the user id and user type
  test('should generate an encrypted token with the user id and user type', () {
    // act
    generateRefreshToken(user: tMockUser);

    // assert
    verify(
      () => mockGenerateEncryptedToken(
        payload: {
          'userId': tUserId,
          'userType': tMockUser.runtimeType,
        },
        expiresIn: tSecrets.refreshTokenLifetime,
      ),
    );
  });

  test("should return an [EncryptedToken]", () {
    // act
    final result = generateRefreshToken(user: tMockUser);

    // assert
    expect(result, tEncryptedToken);
  });
}
