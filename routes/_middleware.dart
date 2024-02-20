import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:einblicke_server/injection_container.dart';

/// Adds a [FrameSocketHandler] provider
Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        provider((context) => getIt.get<FrameSocketHandler>()),
      );
}
