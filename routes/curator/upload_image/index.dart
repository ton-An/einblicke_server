import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/receive_image_from_curator.dart';
import 'package:dispatch_pi_dart/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:dispatch_pi_dart/injection_container.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

final contentTypePng = ContentType('image', 'png');
final contentTypeJpg = ContentType('image', 'jpg');
final contentTypeJpeg = ContentType('image', 'jpeg');

/// Establishes a websocket connection to a picture frame
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final FormData formData = await context.request.formData();
  final UploadedFile? photo = formData.files['photo'];
  final String? frameId = formData.fields['frame_id'];

  if (photo == null ||
      frameId == null ||
      !(photo.contentType.mimeType == contentTypePng.mimeType ||
          photo.contentType.mimeType == contentTypeJpg.mimeType ||
          photo.contentType.mimeType == contentTypeJpeg.mimeType)) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  print(1);

  final List<int> photoBytes = await photo.readAsBytes();

  print(2);

  final Curator curator = context.read<Curator>();
  final ReceiveImageFromCurator receiveImageFromCurator =
      getIt<ReceiveImageFromCurator>();

  final Either<Failure, String> imageIdEither = await receiveImageFromCurator(
    curatorId: curator.userId,
    frameId: frameId,
    imageBytes: photoBytes,
  );
  print(3);
  print(imageIdEither);

  return imageIdEither.fold(
    (Failure failure) => Response(
      statusCode: 500,
      body: failure.code,
    ),
    (String imageId) async {
      final FrameSocketHandler frameSocketHandler =
          context.read<FrameSocketHandler>();

      await frameSocketHandler.sendImage(frameId: frameId, imageId: imageId);
      return Response();
    },
  );
}
