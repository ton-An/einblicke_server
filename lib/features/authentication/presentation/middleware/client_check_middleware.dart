import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_client_id_valid.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_client_secret_valid.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

/// A middleware that verifies the client id and client secret
Middleware clientCheckMiddleware() {
  return (handler) => (context) async {
        final String? clientId = context.request.headers['client_id'];
        final String? clientSecret = context.request.headers['client_secret'];

        if (clientId == null || clientSecret == null) {
          return Response(statusCode: HttpStatus.unauthorized);
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
          return Response(statusCode: HttpStatus.unauthorized);
        }
      };
}
