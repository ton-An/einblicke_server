import 'package:jose/jose.dart';

class JWEBuilderWrapper {
  JsonWebEncryptionBuilder createBuilderInstance() {
    return JsonWebEncryptionBuilder();
  }

  JsonWebKeyStore createKeyStoreInstance() {
    return JsonWebKeyStore();
  }
}
