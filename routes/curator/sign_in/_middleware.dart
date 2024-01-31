import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/presentation/middleware/client_check_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(clientCheckMiddleware());
}
