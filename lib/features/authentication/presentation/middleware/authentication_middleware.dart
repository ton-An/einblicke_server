import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/check_access_token_validity.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
/*
  To-Do:
    - [ ] Implement proper error responses
*/

/// __authenticationMiddleware()__ is a middleware that checks if a given
/// access token is valid.
Middleware authenticationMiddleware<U extends User,
    R extends UserAuthenticationRepository<U>>() {
  return (handler) => (context) async {
        final String? accessToken = context.request.headers.bearer();

        if (accessToken == null) {
          return FailureResponseHandler.getFailureResponse(
            const UnauthorizedFailure(),
          );
        }

        final CheckAccessTokenValidityWrapper<U, R> checkAccessTokenValidity =
            getIt.get();

        final Either<Failure, U> tokenValidityEither =
            await checkAccessTokenValidity(accessToken: accessToken);

        return tokenValidityEither.fold(
          (_) => FailureResponseHandler.getFailureResponse(
            const UnauthorizedFailure(),
          ),
          (U user) => handler(context.provide(() => user)),
        );
      };
}

extension on Map<String, String> {
  String? authorization(String type) {
    final value = this['Authorization']?.split(' ');

    if (value != null && value.length == 2 && value.first == type) {
      return value.last;
    }

    return null;
  }

  String? bearer() => authorization('Bearer');
}
