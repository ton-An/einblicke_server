import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dartz/dartz.dart';
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
  return bearerAuthentication<U>(
    authenticator: (context, token) async {
      final CheckAccessTokenValidityWrapper<U, R> checkAccessTokenValidity =
          getIt.get();

      final Either<Failure, U> tokenValidityEither =
          await checkAccessTokenValidity(accessToken: token);

      return tokenValidityEither.fold(
        (Failure failure) => null,
        (U user) => user,
      );
    },
  );
}
