import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/paired_frame_info.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_paired_frames_info.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final Curator curator = context.read<Curator>();
  final GetPairedFramesInfo getPairedFramesInfo = getIt<GetPairedFramesInfo>();

  final Either<Failure, List<PairedFrameInfo>> pairedFramesInfoEither =
      await getPairedFramesInfo(curatorId: curator.userId);

  return pairedFramesInfoEither.fold(FailureResponseHandler.getFailureResponse,
      (List<PairedFrameInfo> pairedFramesInfo) {
    final List<Map<String, dynamic>> pairedFramesInfoJson =
        pairedFramesInfo.map((PairedFrameInfo pairedFrameInfo) {
      return pairedFrameInfo.toJson();
    }).toList();

    return Response(
      body: jsonEncode(pairedFramesInfoJson),
    );
  });
}
