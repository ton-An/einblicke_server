import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/socket_connection.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template frame_socket_handler}
/// __Frame Socket Handler__ handles the websocket connections to the
/// [Frame]s.
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

  /// Gets an [Image] from a given image id
  final GetImageFromId getImageFromId;

  /// Gets the latest [Image] for a given [Frame]
  final GetLatestImage getLatestImage;

  final List<SocketConnetion> _connections = [];

  /// Adds a new connection to the list of connections
  ///
  /// Failures (emitted to the specific frames):
  /// - [DatabaseReadFailure]
  /// - [NoImagesFoundFailure]
  /// - [StorageReadFailure]
  Future<void> addConnection({
    required String frameId,
    required StreamSink streamSink,
  }) async {
    final latestImageEither = await getLatestImage(frameId: frameId);

    latestImageEither.fold(
      (failure) => streamSink.add(failure.code),
      (image) => streamSink.add(image.imageId),
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
    final bool isConnectionPresent =
        _isConnectionPresent(streamSink: streamSink);

    if (!isConnectionPresent) {
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
        connection.sink.add(image.imageId);
      }
    }

    return const Right(None());
  }

  bool _isFrameConnected({required String frameId}) {
    return _connections.any(
      (connection) {
        return connection.frameId == frameId;
      },
    );
  }

  bool _isConnectionPresent({required StreamSink streamSink}) {
    return _connections.any(
      (connection) => connection.sink == streamSink,
    );
  }
}
