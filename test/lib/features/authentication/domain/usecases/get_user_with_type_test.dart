// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_user_role_failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/get_user_with_type.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GetUserWithType<MockUser, MockUserAuthRepository> getUserWithType;
  late MockUserAuthRepository mockUserAuthRepository;

  late MockUser tMockUser;

  setUp(() {
    mockUserAuthRepository = MockUserAuthRepository();
    getUserWithType = GetUserWithType(
      userAuthenticationRepository: mockUserAuthRepository,
    );

    tMockUser = MockUser();

    when(
      () => mockUserAuthRepository.getUserFromId(
        any(),
      ),
    ).thenAnswer(
      (_) async => Right(tMockUser),
    );
  });

  test("should get the user and return it", () async {
    // act
    final result = await getUserWithType(
      userId: tUserId,
      userType: MockUser,
    );

    // assert
    expect(result, Right(tMockUser));
    verify(
      () => mockUserAuthRepository.getUserFromId(
        tAccessTokenClaims.userId,
      ),
    );
  });

  test("should return a [InvalidUserTypeFailure] if the user type is invalid",
      () async {
    // act
    final result = await getUserWithType(
      userId: tUserId,
      userType: InvalidUserType,
    );

    // assert
    expect(result, const Left(InvalidUserTypeFailure()));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(
      () => mockUserAuthRepository.getUserFromId(
        any(),
      ),
    ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

    // act
    final result = await getUserWithType(
      userId: tUserId,
      userType: MockUser,
    );

    // assert
    expect(result, const Left(UserNotFoundFailure()));
  });
}
