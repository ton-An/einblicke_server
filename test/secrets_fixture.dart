//  secret
import 'package:einblicke_server/core/secrets.dart';

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

  @override
  // TODO: implement jsonWebKey
  Map<String, String> get jsonWebKey => {
        "kty": "EC",
        "crv": "P-521",
        "x": "AekpBQ8ST8a8VcfVOTNl353vSrDCLLJXmPk06wTjxrrjcBpXp5EOnYG_"
            "NjFZ6OvLFV1jSfS9tsz4qUxcWceqwQGk",
        "y": "ADSmRA43Z1DSNx_RvcLI87cdL07l6jQyyBXMoxVg_l2Th-x3S1WDhjDl"
            "y79ajL4Kkd0AZMaZmh9ubmf63e3kyMj2",
        "d": "AY5pb7A0UFiB3RELSD64fTLOSV_jazdF7fLYyuTw8lOfRhWg6Y6rUrPA"
            "xerEzgdRhajnu0ferB0d53vM9mE15j2C"
      };
}

const TSecrets tSecrets = TSecrets();
