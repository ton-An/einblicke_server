import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final String bodyString = await context.request.body();
  final Map<String, dynamic> body =
      jsonDecode(bodyString) as Map<String, dynamic>;

  final String username = body['username'] as String;
  final String password = body['password'] as String;

  final SignInCurator signInCurator = getIt<SignInCurator>();

  final Either<Failure, TokenBundle> signInResult =
      await signInCurator(username: username, password: password);

  return signInResult.fold(
    FailureResponseHandler.getFailureResponse,
    (TokenBundle credentials) => Response(
      body: jsonEncode(credentials.toJson()),
    ),
  );
}
