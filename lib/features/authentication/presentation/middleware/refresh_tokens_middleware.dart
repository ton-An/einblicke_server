import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/get_new_tokens.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

/// A middleware that verifies a users refresh token
Middleware refreshTokensMiddleware<U extends User,
    R extends UserAuthenticationRepository<U>>() {
  return (Handler handler) => (RequestContext context) async {
        final GetNewTokens<U, R> getNewTokens = getIt.get();
        final String? refreshToken = context.request.headers['refresh_token'];

        if (refreshToken == null) {
          return Response(statusCode: HttpStatus.unauthorized);
        }

        final Either<Failure, AuthenticationCredentials> getNewTokensEither =
            await getNewTokens(oldRefreshToken: refreshToken);

        return getNewTokensEither.fold(
          (Failure failure) => Response(statusCode: HttpStatus.unauthorized),
          (AuthenticationCredentials credentials) {
            handler.use(
              provider((context) => credentials),
            );

            return handler(context);
          },
        );
      };
}
