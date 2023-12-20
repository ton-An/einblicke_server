import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_picture_frame.dart';
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

  final SignInPictureFrame signInPictureFrame = getIt<SignInPictureFrame>();

  final Either<Failure, AuthenticationCredentials> signInResult =
      await signInPictureFrame(username: username, password: password);

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
