import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity/check_access_token_validity.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

/// An authentiaction middleware that verifies a users access token
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
