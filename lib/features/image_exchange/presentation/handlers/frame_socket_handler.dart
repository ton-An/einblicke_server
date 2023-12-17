import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/frame_not_connected_failure.dart';
import 'package:dispatch_pi_dart/core/failures/no_images_found_failure.dart';
import 'package:dispatch_pi_dart/core/failures/read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/storage_unavailable_failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/socket_connection.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_latest_image.dart';

/// {@template frame_socket_handler}
/// Handles the websocket connections to the picture frames
///
/// Methods:
/// - [addConnection] adds a new connection to the list of connections
/// - [removeConnection] removes a connection from the list of connections
/// - [sendImage] sends an image to all connections of a specific frame
///
/// [addConnection] is the only mehtod that adds it's [Failure]s to the stream
///
/// {@endtemplate}
class FrameSocketHandler {
  /// {@macro frame_socket_handler}
  FrameSocketHandler({
    required this.getImageFromId,
    required this.getLatestImage,
  });

  final GetImageFromId getImageFromId;
  final GetLatestImage getLatestImage;

  final List<SocketConnetion> _connections = [];

  /// Adds a new connection to the list of connections
  ///
  /// Failures (emitted to the specific frames):
  /// - [DatabaseReadFailure]
  /// - [NoImagesFoundFailure]
  /// - [StorageReadFailure]
  /// - [StorageUnavailableFailure]
  Future<void> addConnection({
    required String frameId,
    required StreamSink streamSink,
  }) async {
    final latestImageEither = await getLatestImage(frameId: frameId);

    latestImageEither.fold(
      (failure) => streamSink.add(Left<Failure, Image>(failure)),
      (image) => streamSink.add(Right<Failure, Image>(image)),
    );

    final SocketConnetion connetion =
        SocketConnetion(frameId: frameId, sink: streamSink);

    _connections.add(connetion);
  }

  /// Removes a connection from the list of connections
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the connection does not exist
  Either<Failure, None> removeConnection({
    required StreamSink streamSink,
  }) {
    final bool doesSpecificConnectionExist =
        _doesSpecificConnectionExist(streamSink: streamSink);

    if (!doesSpecificConnectionExist) {
      return const Left(FrameNotConnectedFailure());
    }

    _connections.removeWhere((connection) => connection.sink == streamSink);

    return const Right(None());
  }

  /// Sends an image to all connections of a specific frame
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the frame is not connected
  /// - [StorageReadFailure]
  /// - [StorageUnavailableFailure]
  Future<Either<Failure, None>> sendImage({
    required String frameId,
    required String imageId,
  }) async {
    final bool isFrameConnected = _isFrameConnected(frameId: frameId);

    if (!isFrameConnected) {
      return const Left(FrameNotConnectedFailure());
    }

    final imageEither = await getImageFromId(imageId: imageId);

    return imageEither.fold(
      Left.new,
      (Image image) => _addImageToStreamSinks(
        frameId: frameId,
        image: image,
      ),
    );
  }

  Right<Failure, None> _addImageToStreamSinks({
    required String frameId,
    required Image image,
  }) {
    for (final connection in _connections) {
      if (connection.frameId == frameId) {
        connection.sink.add(Right<Failure, Image>(image));
      }
    }

    return const Right(None());
  }

  bool _isFrameConnected({required String frameId}) {
    return _connections.any(
      (connection) => connection.frameId == frameId,
    );
  }

  bool _doesSpecificConnectionExist({required StreamSink streamSink}) {
    return _connections.any(
      (connection) => connection.sink == streamSink,
    );
  }
}
