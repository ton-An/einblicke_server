// routes/ws.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Handler get onRequest {
  return webSocketHandler(
    (channel, protocol) {
      // A new connection was established.
      print('connected');
      // Subscribe to the stream of messages from the client.
      channel.stream.listen(
        (message) {
          // Handle incoming messages.
          print('received: $message');
          // Send outgoing messages to the connected client.
          channel.sink.add('pong');
        },
        // The connection was terminated.
        onDone: () => print('disconnected'),
      );
    },
  );
}
