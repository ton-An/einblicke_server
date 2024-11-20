import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/socket_connection.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template frame_socket_handler}
/// __Frame Socket Handler__ handles the websocket connections to the
/// [Frame]s.
///
/// Methods:
/// - [addConnection] adds a new connection to the list of connections
/// - [removeConnectionWithSink] removes a connection from the list of connections
/// - [sendMessage] sends a message to a specific frame
/// {@endtemplate}
abstract class FrameSocketHandler {
  /// {@macro frame_socket_handler}
  FrameSocketHandler();

  final List<SocketConnection> _connections = [];

  /// Adds a new connection to the list of connections
  ///
  /// Failures (emitted to the specific frames):
  /// - [DatabaseReadFailure]
  /// - [StorageReadFailure]
  Future<void> addConnection({
    required String frameId,
    required StreamSink streamSink,
  }) async {
    final SocketConnection connection =
        SocketConnection(frameId: frameId, sink: streamSink);

    _connections.add(connection);
  }

  /// Removes a connection from the list of connections with the given sink
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the connection does not exist
  Either<Failure, None> removeConnectionWithSink({
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

  /// Removes a connection from the list of connections with the given frame id
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the frame is not connected
  Either<Failure, None> removeConnectionWithFrameId({
    required String frameId,
  }) {
    if (!isFrameConnected(frameId: frameId)) {
      return const Left(FrameNotConnectedFailure());
    }

    _connections.removeWhere((connection) => connection.frameId == frameId);

    return const Right(None());
  }

  /// Sends message to a specific frame socket
  ///
  /// Failures:
  /// - [FrameNotConnectedFailure] if the frame is not connected
  Future<Either<Failure, None>> sendMessage({
    required String frameId,
    required String message,
  }) async {
    if (!isFrameConnected(frameId: frameId)) {
      return const Left(FrameNotConnectedFailure());
    }

    for (final connection in _connections) {
      if (connection.frameId == frameId) {
        connection.sink.add(message);
      }
    }

    return const Right(None());
  }

  /// Checks if a frame with the given id is connected
  ///
  /// Returns:
  /// - true if the frame is connected, false otherwise
  bool isFrameConnected({required String frameId}) {
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
