// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/save_refresh_token.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

void main() {
  late SaveRefreshToken saveRefreshToken;
  late MockUserAuthRepository mockUserAuthRepository;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    saveRefreshToken = SaveRefreshToken(
      userAuthenticationRepository: mockUserAuthRepository,
    );

    when(() => mockUserAuthRepository.saveRefreshTokenToDb(any(), any()))
        .thenAnswer((_) async => const Right(None()));
  });

  // should save the token in the database and return None
  // should relay [Failure]s

  test("should save the refresh token in the database and return [None]",
      () async {
    // act
    final result = await saveRefreshToken(
      userId: tUserId,
      refreshToken: tEncryptedRefreshToken,
    );

    // assert
    expect(result, const Right(None()));
    verify(
      () => mockUserAuthRepository.saveRefreshTokenToDb(
        tUserId,
        tRefreshToken,
      ),
    );
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockUserAuthRepository.saveRefreshTokenToDb(any(), any()))
        .thenAnswer((_) async => const Left(DatabaseWriteFailure()));

    // act
    final result = await saveRefreshToken(
      userId: tUserId,
      refreshToken: tEncryptedRefreshToken,
    );

    // assert
    expect(result, Left(DatabaseWriteFailure()));
  });
}
