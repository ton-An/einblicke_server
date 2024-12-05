import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_image_socket_handler.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/pairing_socket_handler.dart';
import 'package:einblicke_server/injection_container.dart';

/// Adds a [FrameImageSocketHandler] provider
Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        provider((context) => getIt.get<FrameImageSocketHandler>()),
      )
      .use(
        provider((context) => getIt.get<PairingSocketHandler>()),
      );
}
