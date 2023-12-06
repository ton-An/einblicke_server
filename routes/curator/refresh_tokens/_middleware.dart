import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/presentation/middleware/refresh_tokens_middleware.dart';

Handler middleware(Handler handler) {
  handler.use(
    refreshTokensMiddleware<Curator, CuratorAuthenticationRepository>(),
  );

  return handler;
}
