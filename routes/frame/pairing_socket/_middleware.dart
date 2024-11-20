import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/authentication/presentation/middleware/client_check_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(clientCheckMiddleware());
}
