import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

import '../../../lib/features/image_exchange/presentation/handlers/frame_socket_handler.dart';

/// Establishes a websocket connection to a picture frame
Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    final String frameId = context.read<String>();
    final FrameSocketHandler frameSocketHandler =
        context.read<FrameSocketHandler>();

    frameSocketHandler.addConnection(
      frameId: frameId,
      streamSink: channel.sink,
    );
  });

  return handler(context);
}
