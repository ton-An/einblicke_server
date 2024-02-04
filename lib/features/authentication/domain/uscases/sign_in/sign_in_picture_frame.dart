import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_bundle.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_wrapper.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template sign_in_picture_frame}
/// Use case for signing in a [Frame].
///
/// Parameters:
/// - [String] the picture frame's username
/// - [String] the picture frame's password
///
/// Returns:
/// - [TokenBundle] if the picture frame was successfully signed in
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

  /// The [SignInWrapper] for [Frame]s.
  final SignInWrapper<Frame, FrameAuthenticationRepository> signInPictureFrame;

  /// {@macro sign_in_picture_frame}
  Future<Either<Failure, TokenBundle>> call({
    required String username,
    required String password,
  }) {
    return signInPictureFrame(
      username: username,
      password: password,
    );
  }
}
