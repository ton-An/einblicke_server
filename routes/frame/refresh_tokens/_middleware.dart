import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/presentation/middleware/refresh_tokens_middleware.dart';

Handler middleware(Handler handler) {
  handler.use(
    refreshTokensMiddleware<PictureFrame, FrameAuthenticationRepository>(),
  );

  return handler;
}
