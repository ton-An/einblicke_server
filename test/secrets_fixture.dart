//  secret
import 'package:dispatch_pi_dart/core/secrets.dart';

class TSecrets extends Secrets {
  const TSecrets();

  @override
  String get clientId => "testClientId";

  @override
  String get clientSecret => "testClientSecret";

  @override
  Duration get accessTokenLifetime => Duration(hours: 1);

  @override
  Duration get refreshTokenLifetime => Duration(days: 16);
}

const TSecrets tSecrets = TSecrets();
