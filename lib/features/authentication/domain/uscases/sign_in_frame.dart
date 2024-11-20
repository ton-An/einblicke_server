import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/get_sign_in_tokens.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template sign_in_frame}
/// __Sign In Frame__ signs in a [Frame] and returns a [ServerTokenBundle].
///
/// Parameters:
/// - [frame]: The [Frame] to sign in
///
/// Returns:
/// - a [ServerTokenBundle] containing the access and refresh tokens
///
/// Failures:
/// = [DatabaseWriteFailure]
/// {@endtemplate}
class SignInFrame {
  /// {@macro sign_in_frame}
  const SignInFrame({
    required this.getSignInTokens,
  });

  /// Used to get the sign in tokens
  final GetSignInTokens<Frame, FrameAuthenticationRepository> getSignInTokens;

  /// {@macro sign_in_frame}
  Future<Either<Failure, ServerTokenBundle>> call({required Frame frame}) {
    return getSignInTokens(frame);
  }
}
