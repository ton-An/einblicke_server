import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/frame_image_retriever_by_id.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return FailureResponseHandler.getFailureResponse(
        const MethodNotAllowedFailure());
  }

  final String frameId = context.read<Frame>().userId;
  final String? imageId = context.request.uri.queryParameters['image_id'];

  if (imageId == null) {
    return FailureResponseHandler.getFailureResponse(const BadRequestFailure());
  }

  final FrameImageRetrieverById getFramesImageFromId =
      getIt<FrameImageRetrieverById>();

  final Either<Failure, Image> imageEither = await getFramesImageFromId(
    frameId: frameId,
    imageId: imageId,
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
