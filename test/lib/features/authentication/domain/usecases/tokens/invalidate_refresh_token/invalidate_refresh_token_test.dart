// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/invalidate_refresh_tokens/invalidate_refresh_token.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../../fixtures.dart';
import '../../../../../../../mocks.dart';

void main() {
  late InvalidateRefreshToken removeRefreshToken;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    removeRefreshToken = InvalidateRefreshToken(
      userAuthenticationRepository: mockUserAuthRepository,
    );

    when(() => mockUserAuthRepository.removeRefreshTokenFromDb(any(), any()))
        .thenAnswer((_) async => const Right(None()));
  });

  test("should remove the refresh token from the database and return [None]",
      () async {
    // act
    final result = await removeRefreshToken(
      userId: tUserId,
      refreshTokenString: tRefreshToken,
    );

    // assert
    expect(result, const Right(None()));
    verify(
      () => mockUserAuthRepository.removeRefreshTokenFromDb(
        tUserId,
        tRefreshToken,
      ),
    );
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockUserAuthRepository.removeRefreshTokenFromDb(any(), any()))
        .thenAnswer((_) async => const Left(DatabaseWriteFailure()));

    // act
    final result = await removeRefreshToken(
      userId: tUserId,
      refreshTokenString: tRefreshToken,
    );

    // assert
    expect(result, const Left(DatabaseWriteFailure()));
  });
}
