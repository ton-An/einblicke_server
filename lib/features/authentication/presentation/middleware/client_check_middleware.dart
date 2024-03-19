import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/is_client_id_valid.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/is_client_secret_valid.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Implement proper error responses
*/

/// __clientCheckMiddleware()__ is a middleware that checks if the given
/// client id and client secret are valid.
Middleware clientCheckMiddleware() {
  return (handler) => (context) async {
        final String? clientId = context.request.headers['client_id'];
        final String? clientSecret = context.request.headers['client_secret'];

        if (clientId == null || clientSecret == null) {
          return FailureResponseHandler.getFailureResponse(
            const UnauthorizedFailure(),
          );
        }

        final IsClientIdValid isClientIdValidUsecase =
            getIt.get<IsClientIdValid>();
        final IsClientSecretValid isClientSecretValidUsecase =
            getIt.get<IsClientSecretValid>();

        final bool isClientIdValid = isClientIdValidUsecase(clientId);
        final bool isClientSecretValid =
            isClientSecretValidUsecase(clientSecret);

        if (isClientIdValid && isClientSecretValid) {
          return handler(context);
        } else {
          return FailureResponseHandler.getFailureResponse(
            const UnauthorizedFailure(),
          );
        }
      };
}
