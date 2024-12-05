import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/presentation/middleware/authentication_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(
    authenticationMiddleware<Curator, CuratorAuthenticationRepository>(),
  );
}
