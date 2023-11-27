//  secret
import 'package:dispatch_pi_dart/core/secrets.dart';

class TSecrets extends Secrets {
  const TSecrets();

  @override
  String get clientId => "testClientId";

  @override
  String get clientSecret => "testClientSecret";

  @override
  int get accessTokenLifetime => 12345;

  @override
  int get refreshTokenLifetime => 123456;
}

const TSecrets tSecrets = TSecrets();
