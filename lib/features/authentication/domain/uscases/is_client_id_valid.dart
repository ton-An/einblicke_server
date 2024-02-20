import 'package:einblicke_server/core/secrets.dart';

/// {@template is_client_id_valid}
/// __Is Client Id Valid__ checks if a client id is valid and returns a [bool].
///
/// Parameters:
/// - [clientid]: The client id to be checked
///
///  Returns:
/// - a [bool] indicating if the client id is valid
/// {@endtemplate}
class IsClientIdValid {
  /// {@macro is_client_id_valid}
  const IsClientIdValid({
    required this.secrets,
  });

  /// The secrets for the application
  final Secrets secrets;

  /// {@macro is_client_id_valid}
  bool call(String clientId) {
    final bool isClientIdValid = clientId == secrets.clientId;

    return isClientIdValid;
  }
}
