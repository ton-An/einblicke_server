import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template failure_response_handler}
/// __FailureResponseHandler__ is a class that handles the response for
/// [Failure]s.
/// {@endtemplate}
class FailureResponseHandler {
  /// {@macro failure_response_handler}
  const FailureResponseHandler();

  /// Returns a [Response] with the status code and body for the given [Failure]
  /// or a default status code of 500 and body for [InternalServerFailure].
  ///
  /// Returns:
  /// - [Response] response
  static Response getFailureResponse(Failure failure) {
    late int statusCode;
    late String body;

    switch (failure.runtimeType) {
      case NoImagesFoundFailure:
        statusCode = 204;
        body = jsonEncode(failure.toJson());
      case BadRequestFailure ||
            InvalidPasswordFailure ||
            InvalidUsernameFailure ||
            NotPairedFailure ||
            UserNotFoundFailure:
        statusCode = 400;
        body = jsonEncode(failure.toJson());
      case UnauthorizedFailure:
        statusCode = 401;
        body = jsonEncode(failure.toJson());
      case MethodNotAllowedFailure:
        statusCode = 405;
        body = jsonEncode(failure.toJson());
      case DatabaseReadFailure ||
            DatabaseWriteFailure ||
            StorageReadFailure ||
            StorageWriteFailure:
        statusCode = 500;
        body = jsonEncode(failure.toJson());
      default:
        statusCode = 500;
        body = jsonEncode(const InternalServerFailure().toJson());
    }

    return Response(
      statusCode: statusCode,
      body: body,
    );
  }
}
