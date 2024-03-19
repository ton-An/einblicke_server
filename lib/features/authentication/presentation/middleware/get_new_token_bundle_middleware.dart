import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/get_new_token_bundle.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Implement proper error responses
*/

/// __getNewTokenBundleMiddleware()__ is a middleware that gets a new
/// [TokenBundle] from a refresh token.
Middleware getNewTokenBundleMiddleware<U extends User,
    R extends UserAuthenticationRepository<U>>() {
  return (Handler handler) {
    return (RequestContext context) async {
      final GetNewTokenTokenBundle<U, R> getNewTokens = getIt.get();

      final String bodyString = await context.request.body();
      final Map<String, String> bodyMap =
          Map.castFrom<String, dynamic, String, String>(
        jsonDecode(bodyString) as Map<String, dynamic>,
      );

      final String? refreshToken = bodyMap['refresh_token'];

      if (refreshToken == null) {
        return FailureResponseHandler.getFailureResponse(
          const UnauthorizedFailure(),
        );
      }

      final Either<Failure, TokenBundle> getNewTokensEither =
          await getNewTokens(oldRefreshToken: refreshToken);

      return getNewTokensEither.fold(
        (Failure failure) => FailureResponseHandler.getFailureResponse(
          const UnauthorizedFailure(),
        ),
        (TokenBundle credentials) {
          final newHandler = handler.use(
            provider<TokenBundle>((context) => credentials),
          );

          return newHandler(context);
        },
      );
    };
  };
}
