import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/receive_image_from_curator.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:einblicke_server/injection_container.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

final contentTypePng = ContentType('image', 'png');
final contentTypeJpg = ContentType('image', 'jpg');
final contentTypeJpeg = ContentType('image', 'jpeg');

/// Establishes a websocket connection to a picture frame
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }

  final FormData formData = await context.request.formData();
  final UploadedFile? photo = formData.files['photo'];
  final String? frameId = formData.fields['frame_id'];

  if (photo == null ||
      frameId == null ||
      !(photo.contentType.mimeType == contentTypePng.mimeType ||
          photo.contentType.mimeType == contentTypeJpg.mimeType ||
          photo.contentType.mimeType == contentTypeJpeg.mimeType)) {
    return FailureResponseHandler.getFailureResponse(const BadRequestFailure());
  }

  final List<int> photoBytes = await photo.readAsBytes();

  final Curator curator = context.read<Curator>();
  final ReceiveImageFromCurator receiveImageFromCurator =
      getIt<ReceiveImageFromCurator>();

  final Either<Failure, String> imageIdEither = await receiveImageFromCurator(
    curatorId: curator.userId,
    frameId: frameId,
    imageBytes: photoBytes,
  );

  return imageIdEither.fold(
    FailureResponseHandler.getFailureResponse,
    (String imageId) async {
      final FrameSocketHandler frameSocketHandler =
          context.read<FrameSocketHandler>();

      await frameSocketHandler.sendImage(frameId: frameId, imageId: imageId);
      return Response();
    },
  );
}
