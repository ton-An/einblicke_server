import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in_handle_tokens.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late SignInHandleTokens signInHandleTokens;
  late MockGenerateAccessToken mockGenerateAccessToken;
  late MockGenerateRefreshToken mockGenerateRefreshToken;
  late MockSaveRefreshToken<MockUser, MockUserAuthRepository>
      mockSaveRefreshToken;

  late MockUser tMockUser;

  setUp(() {
    mockGenerateAccessToken = MockGenerateAccessToken();
    mockGenerateRefreshToken = MockGenerateRefreshToken();
    mockSaveRefreshToken = MockSaveRefreshToken();

    tMockUser = MockUser();

    signInHandleTokens = SignInHandleTokens(
      generateAccessToken: mockGenerateAccessToken,
      generateRefreshToken: mockGenerateRefreshToken,
      saveRefreshToken: mockSaveRefreshToken,
    );

    registerFallbackValue(MockEncryptedToken());

    when(() => mockGenerateAccessToken(user: tMockUser))
        .thenReturn(tEncryptedAccessToken);
    when(() => mockGenerateRefreshToken(user: tMockUser))
        .thenReturn(tEncryptedRefreshToken);
    when(() => tMockUser.userId).thenReturn(tUserId);
    when(
      () => mockSaveRefreshToken(
        userId: any(named: "userId"),
        refreshToken: any(named: "refreshToken"),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  group("generate tokens", () {
    test("should generate an access token if the user is found", () async {
      // act
      await signInHandleTokens(tMockUser);

      // assert
      verify(() => mockGenerateAccessToken(user: tMockUser));
    });

    test("should generate a refresh token if the user is found", () async {
      // act
      await signInHandleTokens(tMockUser);

      // assert
      verify(() => mockGenerateRefreshToken(user: tMockUser));
    });
  });

  group("save the refresh token", () {
    test("should save the refresh token", () async {
      // act
      await signInHandleTokens(tMockUser);

      // assert
      verify(
        () => mockSaveRefreshToken(
          userId: tUserId,
          refreshToken: tEncryptedRefreshToken,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockSaveRefreshToken(
          userId: any(named: "userId"),
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseWriteFailure()));

      // act
      final result = await signInHandleTokens(tMockUser);

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });

    test("should return [ServerTokenBundle] if the user is found", () async {
      // act
      final result = await signInHandleTokens(
        tMockUser,
      );

      // assert
      expect(result, Right(tServerTokenBundle));
    });
  });
}
