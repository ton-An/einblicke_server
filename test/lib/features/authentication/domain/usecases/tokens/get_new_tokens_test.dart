// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/refresh_token_reuse_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/get_new_tokens.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../fixtures.dart';
import '../../../../../../mocks.dart';

void main() {
  late GetNewTokens getNewTokens;
  late MockCheckRefreshTokenValidityWrapper
      mockCheckRefreshTokenValidityWrapper;
  late MockGenerateAccessToken mockGenerateAccessToken;
  late MockGenerateRefreshToken mockGenerateRefreshToken;
  late MockInvalidateRefreshToken mockInvalidateRefreshToken;
  late MockInvalidateAllRefreshTokens mockInvalidateAllRefreshTokens;
  late MockSaveRefreshToken mockSaveRefreshToken;
  late MockUserAuthRepository mockUserAuthRepository;
  late MockBasicAuthRepository mockBasicAuthRepository;

  late MockUser tMockUser;

  setUp(() {
    mockCheckRefreshTokenValidityWrapper =
        MockCheckRefreshTokenValidityWrapper();
    mockGenerateAccessToken = MockGenerateAccessToken();
    mockGenerateRefreshToken = MockGenerateRefreshToken();
    mockInvalidateRefreshToken = MockInvalidateRefreshToken();
    mockInvalidateAllRefreshTokens = MockInvalidateAllRefreshTokens();
    mockSaveRefreshToken = MockSaveRefreshToken();
    mockUserAuthRepository = MockUserAuthRepository();
    mockBasicAuthRepository = MockBasicAuthRepository();

    getNewTokens = GetNewTokens(
      checkRefreshTokenValidityWrapper: mockCheckRefreshTokenValidityWrapper,
      generateAccessToken: mockGenerateAccessToken,
      generateRefreshToken: mockGenerateRefreshToken,
      invalidateRefreshToken: mockInvalidateRefreshToken,
      invalidateAllRefreshTokens: mockInvalidateAllRefreshTokens,
      saveRefreshTokenUsecase: mockSaveRefreshToken,
      userAuthRepository: mockUserAuthRepository,
      basicAuthRepository: mockBasicAuthRepository,
    );

    tMockUser = MockUser();

    registerFallbackValue(MockUser());
    registerFallbackValue(MockEncryptedToken());

    when(
      () => mockCheckRefreshTokenValidityWrapper(
        refreshToken: any(named: "refreshToken"),
      ),
    ).thenAnswer((_) async => Right(tMockUser));
    when(() => tMockUser.userId).thenReturn(tUserId);
    when(
      () => mockInvalidateAllRefreshTokens(
        userId: any(named: "userId"),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(() => mockGenerateAccessToken(user: tMockUser))
        .thenAnswer((_) => tEncryptedAccessToken);
    when(() => mockGenerateRefreshToken(user: any(named: "user")))
        .thenAnswer((_) => tEncryptedRefreshToken);
    when(
      () => mockInvalidateRefreshToken(
        userId: any(named: "userId"),
        refreshTokenString: any(named: "refreshTokenString"),
      ),
    ).thenAnswer((_) async => const Right(None()));
    when(
      () => mockSaveRefreshToken(
        userId: any(named: "userId"),
        refreshToken: any(named: "refreshToken"),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  group("check validity of the refresh token", () {
    test("should check if the refresh token is valid", () async {
      // act
      await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      verify(
        () => mockCheckRefreshTokenValidityWrapper(
          refreshToken: tRefreshToken,
        ),
      );
    });

    group("if the token has been re-used", () {
      setUp(() {
        when(() => mockBasicAuthRepository.getUserIdFromToken(any()))
            .thenAnswer((_) async => const Right(tUserId));
        when(
          () => mockCheckRefreshTokenValidityWrapper(
            refreshToken: any(named: "refreshToken"),
          ),
        ).thenAnswer((_) async => const Left(RefreshTokenReuseFailure()));
      });

      test("should get the user id from the token", () async {
        // act
        await getNewTokens(oldRefreshToken: tRefreshToken);

        // assert
        verify(
          () => mockBasicAuthRepository.getUserIdFromToken(tRefreshToken),
        );
      });

      test(
          "should invalidate all refresh tokens if the refresh token has "
          "been reused and return a [Failure]", () async {
        // act
        final result = await getNewTokens(oldRefreshToken: tRefreshToken);

        // assert
        expect(result, const Left(RefreshTokenReuseFailure()));
        verify(
          () => mockInvalidateAllRefreshTokens(
            userId: tUserId,
          ),
        );
      });
    });

    test("should relay other [Failure]s", () async {
      // arrange
      when(
        () => mockCheckRefreshTokenValidityWrapper(
          refreshToken: any(named: "refreshToken"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("generate new access token", () {
    test("should generate a new access token", () async {
      // act
      await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      verify(
        () => mockGenerateAccessToken(
          user: tMockUser,
        ),
      );
    });
  });

  group("generate new refresh token", () {
    test("should generate a new refresh token", () async {
      // act
      await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      verify(
        () => mockGenerateRefreshToken(
          user: tMockUser,
        ),
      );
    });
  });

  group("remove refresh token from database", () {
    test("should remove the refresh token from the database", () async {
      // act
      await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      verify(
        () => mockInvalidateRefreshToken(
          userId: tUserId,
          refreshTokenString: tRefreshToken,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockInvalidateRefreshToken(
          userId: any(named: "userId"),
          refreshTokenString: any(named: "refreshTokenString"),
        ),
      ).thenAnswer(
        (_) async => const Left(DatabaseWriteFailure()),
      );

      // act
      final result = await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("save new refresh token to database", () {
    test("should save the new refresh token to the database", () async {
      // act
      await getNewTokens(oldRefreshToken: tRefreshToken);

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
      ).thenAnswer(
        (_) async => const Left(DatabaseWriteFailure()),
      );

      // act
      final result = await getNewTokens(oldRefreshToken: tRefreshToken);

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  test("should return the [AuthenticationCredentials]", () async {
    // act
    final result = await getNewTokens(oldRefreshToken: tRefreshToken);

    // assert
    expect(result, Right(tAuthenticationCredentials));
  });
}
