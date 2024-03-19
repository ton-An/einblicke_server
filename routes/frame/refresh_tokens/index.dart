import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final TokenBundle credentials = context.read<TokenBundle>();

  final Map<String, dynamic> credentialsMap = credentials.toJson();

  final bodyString = jsonEncode(credentialsMap);

  return Response(
    body: bodyString,
  );
}
