import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/presentation/middleware/get_new_token_bundle_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(
    getNewTokenBundleMiddleware<Curator, CuratorAuthenticationRepository>(),
  );
}
