import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/domain/uscases/save_refresh_token.dart';
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

    when(() => mockUserAuthRepository.saveRefreshToken(any(), any()))
        .thenAnswer((_) async => const Right(None()));
  });

  // should save the token in the database and return None
  // should relay [Failure]s

  test("should save the refresh token in the database and return [None]", () {
    // act
    final result = saveRefreshToken(
      userId: tUserId,
      refreshToken: tEncryptedRefreshToken,
    );

    // assert
    expect(result, const Right(None()));
    verify(
      () => mockUserAuthRepository.saveRefreshToken(
        tUserId,
        tRefreshToken,
      ),
    );
  });

  test("should relay [Failure]s", () {
    // arrange
    when(() => mockUserAuthRepository.saveRefreshToken(any(), any()))
        .thenAnswer((_) async => const Left(DatabaseWriteFailure()));

    // act
    final result = saveRefreshToken(
      userId: tUserId,
      refreshToken: tEncryptedRefreshToken,
    );

    // assert
    expect(result, Left(DatabaseWriteFailure()));
  });
}
