import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/frame_socket_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template frame_image_socket_handler}
/// __Frame Image Socket Handler__ handles the websocket connections sending
/// image ids to the [Frame]s.
///
/// Methods:
/// - [addConnection] adds a new connection to the list of connections
/// - [removeConnection] removes a connection from the list of connections
/// - [sendImage] sends an image to all connections of a specific frame
///
/// {@endtemplate}
class FrameImageSocketHandler extends FrameSocketHandler {
  /// {@macro frame_image_socket_handler}
  FrameImageSocketHandler({
    required this.getImageFromId,
    required this.getLatestImage,
  });

  /// Gets an [Image] from a given image id
  final GetImageFromId getImageFromId;

  /// Gets the latest [Image] for a given [Frame]
  final GetLatestImage getLatestImage;

  @override
  Future<void> addConnection({
    required String frameId,
    required StreamSink streamSink,
  }) async {
    await super.addConnection(frameId: frameId, streamSink: streamSink);

    final latestImageEither = await getLatestImage(frameId: frameId);

    await latestImageEither.fold(
      (failure) => sendMessage(
        frameId: frameId,
        message: jsonEncode(
          failure.toJson(),
        ),
      ),
      (image) => sendMessage(
        frameId: frameId,
        message: jsonEncode(
          {"image_id": image.imageId},
        ),
      ),
    );
  }

  /// Sends an image to all connections of a specific frame
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the frame is not connected
  /// - [StorageReadFailure]
  Future<Either<Failure, None>> sendImage({
    required String frameId,
    required String imageId,
  }) async {
    final imageEither = await getImageFromId(imageId: imageId);

    return imageEither.fold(
      Left.new,
      (Image image) => sendMessage(
        frameId: frameId,
        message: jsonEncode(
          {"image_id": image.imageId},
        ),
      ),
    );
  }
}
