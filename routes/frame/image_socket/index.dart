import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_socket_handler.dart';

/// Establishes a websocket connection to a picture frame
Future<Response> onRequest(RequestContext context) async {
  final handler2 = webSocketHandler(
    (channel, protocol) {
      final String frameId = context.read<Frame>().userId;
      final FrameSocketHandler frameSocketHandler =
          context.read<FrameSocketHandler>();

      frameSocketHandler.addConnection(
        frameId: frameId,
        streamSink: channel.sink,
      );

      channel.stream.listen((event) {}).onDone(() {
        frameSocketHandler.removeConnection(streamSink: channel.sink);
      });
    },
  );

  return handler2(context);
}
