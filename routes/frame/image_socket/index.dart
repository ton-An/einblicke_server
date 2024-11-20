import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_image_socket_handler.dart';

/*
  To-Do:
  - [ ] What happens if the access token gets invalidated during the stream?
*/

/// Establishes a websocket connection to a picture frame
Future<Response> onRequest(RequestContext context) async {
  final imageSocketHandler = webSocketHandler(
    (channel, protocol) {
      final String frameId = context.read<Frame>().userId;
      final FrameImageSocketHandler frameImageSocketHandler =
          context.read<FrameImageSocketHandler>();

      frameImageSocketHandler.addConnection(
        frameId: frameId,
        streamSink: channel.sink,
      );

      channel.stream.listen((event) {}).onDone(() {
        frameImageSocketHandler.removeConnectionWithSink(
          streamSink: channel.sink,
        );
      });
    },
  );

  return imageSocketHandler(context);
}
