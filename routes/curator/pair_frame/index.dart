import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/pairing_socket_handler.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

// ToDo: Add protection against e.g. sql injection

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final Curator curator = context.read<Curator>();
  final String bodyString = await context.request.body();
  final Map<String, String> bodyMap =
      Map.castFrom<String, dynamic, String, String>(
    jsonDecode(bodyString) as Map<String, dynamic>,
  );

  final String? qrCode = bodyMap['qr_code'];
  final String? frameName = bodyMap['frame_name'];

  if (qrCode == null || frameName == null) {
    return FailureResponseHandler.getFailureResponse(
      const BadRequestFailure(),
    );
  }

  final String tempFrameId = qrCode.split("einblicke-").last;

  final PairingSocketHandler pairingSocketHandler =
      context.read<PairingSocketHandler>();

  final Either<Failure, None> pairFrameEither = await pairingSocketHandler.pair(
    tempFrameId: tempFrameId,
    curatorId: curator.userId,
    name: frameName,
  );

  return pairFrameEither.fold(
    FailureResponseHandler.getFailureResponse,
    (None none) => Response(body: jsonEncode({})),
  );
}
