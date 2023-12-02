// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/invalidate_all_refresh_tokens.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  // should delete all refresh tokens from the database and return None
  // should relay [Failure]s

  late InvalidateAllRefreshTokens invalidateAllRefreshTokens;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    invalidateAllRefreshTokens = InvalidateAllRefreshTokens(
      userAuthenticationRepository: mockUserAuthRepository,
    );

    when(() => mockUserAuthRepository.removeAllRefreshTokensFromDb(any()))
        .thenAnswer((_) async => const Right(None()));
  });

  test("should delete all refresh tokens from the database and return [None]",
      () async {
    // act
    final result = await invalidateAllRefreshTokens(
      userId: tUserId,
    );

    // assert
    expect(result, const Right(None()));
    verify(
      () => mockUserAuthRepository.removeAllRefreshTokensFromDb(
        tUserId,
      ),
    );
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockUserAuthRepository.removeAllRefreshTokensFromDb(any()))
        .thenAnswer((_) async => const Left(DatabaseWriteFailure()));

    // act
    final result = await invalidateAllRefreshTokens(
      userId: tUserId,
    );

    // assert
    expect(result, const Left(DatabaseWriteFailure()));
  });
}
