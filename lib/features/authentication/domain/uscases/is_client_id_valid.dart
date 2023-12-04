import 'package:dispatch_pi_dart/core/secrets.dart';

/// {@template is_client_id_valid}
/// Checks if the client id is valid.
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

  final Secrets secrets;

  /// {@macro is_client_id_valid}
  bool call(String clientId) {
    final bool isClientIdValid = clientId == secrets.clientId;

    return isClientIdValid;
  }
}
