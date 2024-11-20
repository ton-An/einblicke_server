import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/pairing_socket_handler.dart';

/// Establishes a websocket connection
Future<Response> onRequest(RequestContext context) async {
  final imageSocketHandler = webSocketHandler(
    (channel, protocol) async {
      final PairingSocketHandler pairingSocketHandler =
          context.read<PairingSocketHandler>();

      await pairingSocketHandler.addAnonymousConnection(
        streamSink: channel.sink,
      );

      channel.stream.listen((event) {}).onDone(() {
        pairingSocketHandler.removeConnectionWithSink(streamSink: channel.sink);
      });
    },
  );

  return imageSocketHandler(context);
}
