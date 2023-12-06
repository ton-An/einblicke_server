import 'package:dart_frog/dart_frog.dart';
import 'package:dispatch_pi_dart/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:dispatch_pi_dart/injection_container.dart';

/// Adds a [FrameSocketHandler] provider
Handler middleware(Handler handler) {
  handler
    ..use(requestLogger())
    ..use(
      provider((context) => getIt.get<FrameSocketHandler>()),
    );

  return handler;
}
