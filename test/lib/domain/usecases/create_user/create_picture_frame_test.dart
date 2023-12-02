// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_user/create_picture_frame.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late CreatePictureFrame createPictureFrame;
  late MockCreateUserWrapper<PictureFrame, FrameAuthenticationRepository>
      mockCreatePictureFrame;

  setUp(() {
    mockCreatePictureFrame = MockCreateUserWrapper();
    createPictureFrame =
        CreatePictureFrame(creaPictureFrame: mockCreatePictureFrame);
  });

  test("should call [MockCreateUserWrapper] and return a [PictureFrame]",
      () async {
    // arrange
    when(() => mockCreatePictureFrame(any(), any()))
        .thenAnswer((_) async => const Right(tPictureFrame));

    // act
    final result = await createPictureFrame(tUsername, tPassword);

    // assert
    expect(result, const Right(tPictureFrame));
    verify(() => mockCreatePictureFrame(tUsername, tPassword));
  });

  test("should relay [Failure]s", () async {
    // arrange
    when(() => mockCreatePictureFrame(any(), any()))
        .thenAnswer((_) async => const Left(InvalidPasswordFailure()));

    // act
    final result = await createPictureFrame(tUsername, tPassword);

    // assert
    expect(result, const Left(InvalidPasswordFailure()));
  });
}
