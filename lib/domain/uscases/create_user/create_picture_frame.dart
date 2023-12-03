import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_username_failure.dart';
import 'package:dispatch_pi_dart/core/failures/username_taken_failure.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/create_user/create_user_wrapper.dart';

/// {@template create_picture_frame}
/// Creates a [PictureFrame] user with a given username and password
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [PictureFrame] if the user was created successfully
///
/// Failures:
/// - [InvalidUsernameFailure]
/// - [InvalidPasswordFailure]
/// - [UsernameTakenFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class CreatePictureFrame {
  /// {@macro create_picture_frame}
  CreatePictureFrame({
    required this.creaPictureFrame,
  });

  /// Used to create the record of the picture frame
  CreateUserWrapper<PictureFrame, FrameAuthenticationRepository>
      creaPictureFrame;

  /// {@macro create_picture_frame}
  Future<Either<Failure, PictureFrame>> call(
    String username,
    String password,
  ) async {
    return creaPictureFrame(username, password);
  }
}
