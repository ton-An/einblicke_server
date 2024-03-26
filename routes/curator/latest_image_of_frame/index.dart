import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_latest_frame_image_for_curator.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final String curatorId = context.read<Curator>().userId;
  final String frameId = context.request.uri.queryParameters['frame_id']!;

  final GetLatestFrameImageForCurator getLatestFrameImageForCurator =
      context.read<GetLatestFrameImageForCurator>();

  final Either<Failure, Image> imageEither =
      await getLatestFrameImageForCurator(
    curatorId: curatorId,
    frameId: frameId,
  );

  return imageEither.fold(
    FailureResponseHandler.getFailureResponse,
    (Image image) {
      return Response.bytes(
        headers: {
          "Content-Type": "image/jpg",
        },
        body: image.imageBytes,
      );
    },
  );
}
