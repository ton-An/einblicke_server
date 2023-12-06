import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_curator_access_token_validity.dart';
import 'package:dispatch_pi_dart/features/authentication/presentation/middleware/authentication_middleware.dart';

Handler middleware(Handler handler) {
  handler.use(
    authenticationMiddleware<Curator, CuratorAuthenticationRepository,
        CheckCuratorAccessTokenValidity>(),
  );
  return handler;
}
