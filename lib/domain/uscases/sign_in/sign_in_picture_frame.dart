import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/sign_in/sign_in_wrapper.dart';

/// {@template sign_in_picture_frame}
/// Use case for signing in a [PictureFrame].
///
/// Parameters:
/// - [String] the picture frame's username
/// - [String] the picture frame's password
///
/// Returns:
/// - [AuthenticationCredentials] if the picture frame was successfully signed in
///
/// Failures:
/// - [UserNotFoundFailure] if the picture frame was not found
/// - [DatabaseReadFailure] if the database could not be read
/// {@endtemplate}
class SignInPictureFrame {
  /// {@macro sign_in_picture_frame}
  SignInPictureFrame({
    required this.signInPictureFrame,
  });

  /// The [SignInWrapper] for [PictureFrame]s.
  final SignInWrapper<PictureFrame, FrameAuthenticationRepository>
      signInPictureFrame;

  /// {@macro sign_in_picture_frame}
  Future<Either<Failure, AuthenticationCredentials>> call(
    String username,
    String password,
  ) {
    return signInPictureFrame(
      username: username,
      password: password,
    );
  }
}
