import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/presentation/middleware/authentication_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(
    authenticationMiddleware<Frame, FrameAuthenticationRepository>(),
  );
}
