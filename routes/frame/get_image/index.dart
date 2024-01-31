import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_frames_image_from_id.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final String frameId = context.read<PictureFrame>().userId;
  final String? imageId = context.request.uri.queryParameters['image_id'];

  if (imageId == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final GetFramesImageFromId getFramesImageFromId =
      getIt<GetFramesImageFromId>();

  final Either<Failure, Image> imageEither = await getFramesImageFromId(
    frameId: frameId,
    imageId: imageId,
  );

  return imageEither.fold((Failure failure) {
    return Response(statusCode: HttpStatus.notFound);
  }, (Image image) {
    return Response.bytes(
      headers: {
        "Content-Type": "image/jpg",
      },
      body: image.imageBytes,
    );
  });
}
