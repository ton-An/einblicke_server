import 'package:dispatch_pi_dart/core/secrets.dart';

/// {@template is_client_secret_valid}
/// Checks if the client secret is valid.
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

  final Secrets secrets;

  /// {@macro is_client_secret_valid}
  bool call(String clientSecret) {
    final bool isClientSecretValid = clientSecret == secrets.clientSecret;

    return isClientSecretValid;
  }
}
