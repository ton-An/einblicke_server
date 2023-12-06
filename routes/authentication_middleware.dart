import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/check_access_token_validity.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

Middleware authenticationMiddleware() {
  return bearerAuthentication<String>(
    authenticator: (context, token) async {
      final CheckAccessTokenValidity checkAccessTokenValidity =
          getIt.get<CheckAccessTokenValidity>();

      final Either<Failure, String> tokenValidityEither =
          await checkAccessTokenValidity(accessToken: token);

      return tokenValidityEither.fold(
        (Failure failure) => null,
        (String userId) => userId,
      );
    },
  );
}
