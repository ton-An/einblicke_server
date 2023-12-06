import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';

Future<Response> onRequest(RequestContext context) async {
  final AuthenticationCredentials credentials =
      context.read<AuthenticationCredentials>();

  final Map<String, dynamic> credentialsMap = credentials.toJson();

  final bodyString = credentialsMap.toString();

  return Response(
    body: bodyString,
  );
}
