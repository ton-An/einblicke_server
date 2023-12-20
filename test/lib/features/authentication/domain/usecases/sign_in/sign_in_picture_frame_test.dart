// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_picture_frame.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../../fixtures.dart';
import '../../../../../../mocks.dart';

void main() {
  late SignInPictureFrame signInPictureFrame;
  late MockSignInWrapper<PictureFrame, FrameAuthenticationRepository>
      mockSignInPictureFrame;

  setUp(() {
    mockSignInPictureFrame = MockSignInWrapper();
    signInPictureFrame = SignInPictureFrame(
      signInPictureFrame: mockSignInPictureFrame,
    );

    when(
      () => mockSignInPictureFrame(
        username: any(named: "username"),
        password: any(named: "password"),
      ),
    ).thenAnswer((_) async => Right(tAuthenticationCredentials));
  });

  test(
      "should call [MockSignInWrapper] and return the [AuthenticationCredentials]",
      () async {
    // act
    final result =
        await signInPictureFrame(username: tUsername, password: tPassword);

    // assert
    expect(result, Right(tAuthenticationCredentials));
    verify(
        () => mockSignInPictureFrame(username: tUsername, password: tPassword));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(
      () => mockSignInPictureFrame(
        username: any(named: "username"),
        password: any(named: "password"),
      ),
    ).thenAnswer((_) async => const Left(UserNotFoundFailure()));

    // act
    final result =
        await signInPictureFrame(username: tUsername, password: tPassword);

    // assert
    expect(result, const Left(UserNotFoundFailure()));
  });
}
