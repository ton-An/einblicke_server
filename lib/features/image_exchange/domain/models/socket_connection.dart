import 'dart:async';

import 'package:equatable/equatable.dart';

/// {@template socket_connection}
/// A web socket connection to a specific frame
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
