import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user/create_user_wrapper.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

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
