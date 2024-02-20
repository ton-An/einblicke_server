import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final TokenBundle credentials = context.read<TokenBundle>();

  final Map<String, dynamic> credentialsMap = credentials.toJson();

  final bodyString = jsonEncode(credentialsMap);

  return Response(
    body: bodyString,
  );
}
