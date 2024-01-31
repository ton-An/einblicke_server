import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_curator.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final String bodyString = await context.request.body();
  final Map<String, dynamic> body =
      jsonDecode(bodyString) as Map<String, dynamic>;

  final String username = body['username'] as String;
  final String password = body['password'] as String;

  final SignInCurator signInCurator = getIt<SignInCurator>();

  final Either<Failure, AuthenticationCredentials> signInResult =
      await signInCurator(username: username, password: password);

  return signInResult.fold(
    (Failure failure) => Response(
      statusCode: 403,
      body: failure.code,
    ),
    (AuthenticationCredentials credentials) => Response(
      body: jsonEncode(credentials.toJson()),
    ),
  );
}