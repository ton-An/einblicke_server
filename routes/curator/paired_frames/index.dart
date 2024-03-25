import 'package:dart_frog/dart_frog.dart';
import 'package:einblicke_server/core/presentation/handlers/failure_response_handler.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return FailureResponseHandler.getFailureResponse(
      const MethodNotAllowedFailure(),
    );
  }
  throw UnimplementedError();
  // should return a list of paired frames. The list should return the frame id, name and the most recent image
}
