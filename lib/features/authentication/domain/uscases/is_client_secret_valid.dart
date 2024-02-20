import 'package:einblicke_server/core/secrets.dart';

/// {@template is_client_secret_valid}
/// __Is Client Secret Valid__ checks if a client secret is valid
/// and returns a [bool].
///
/// Parameters:
/// - [clientSecret]: The client secret to be checked
///
///  Returns:
/// - a [bool] indicating if the client secret is valid
/// {@endtemplate}
class IsClientSecretValid {
  /// {@macro is_client_secret_valid}
  const IsClientSecretValid({
    required this.secrets,
  });

  /// The secrets for the application
  final Secrets secrets;

  /// {@macro is_client_secret_valid}
  bool call(String clientSecret) {
    final bool isClientSecretValid = clientSecret == secrets.clientSecret;

    return isClientSecretValid;
  }
}
