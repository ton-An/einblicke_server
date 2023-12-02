// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/repositories/curator_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/sign_in/sign_in_curator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late SignInCurator signInCurator;
  late MockSignInWrapper<Curator, CuratorAuthenticationRepository>
      mockSignInCurator;

  setUp(() {
    mockSignInCurator = MockSignInWrapper();
    signInCurator = SignInCurator(signInCurator: mockSignInCurator);

    when(
      () => mockSignInCurator(
        username: any(named: "username"),
        password: any(named: "password"),
      ),
    ).thenAnswer((_) async => const Right(tAuthenticationCredentials));
  });

  test(
      "should call [MockSignInWrapper] and return the [AuthenticationCredentials]",
      () async {
    // arrange

    // act
    final result = await signInCurator(tUsername, tPassword);

    // assert
    expect(result, const Right(tAuthenticationCredentials));
    verify(() => mockSignInCurator(username: tUsername, password: tPassword));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(
      () => mockSignInCurator(
        username: any(named: "username"),
        password: any(named: "password"),
      ),
    ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

    // act
    final result = await signInCurator(tUsername, tPassword);

    // assert
    expect(result, const Left(UserNotFoundFailure()));
  });
}
