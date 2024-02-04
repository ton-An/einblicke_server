import 'dart:async';

import 'package:equatable/equatable.dart';

/// {@template socket_connection}
/// __SocketConnetion__ is a container for a connection to a web socket.
///
/// It contains the [frameId] of the connected frame and the [sink]
/// of the connection which is used to send data to the frame.
/// {@endtemplate}
class SocketConnetion extends Equatable {
  /// {@macro socket_connection}
  const SocketConnetion({
    required this.frameId,
    required this.sink,
  });

  /// The id of the frame
  final String frameId;

  /// The sink of the connection
  final StreamSink sink;

  @override
  List<Object?> get props => [frameId, sink];
}
