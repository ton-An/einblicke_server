import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_frame_access_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/presentation/middleware/authentication_middleware.dart';

Handler middleware(Handler handler) {
  handler.use(
    authenticationMiddleware<PictureFrame, FrameAuthenticationRepository,
        CheckFrameAccessTokenValidity>(),
  );

  return handler;
}
