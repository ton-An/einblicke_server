import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;

/// {@template crypto_wrapper}
/// Wrapper for functions of the crypto package
/// {@endtemplate}
class CryptoWrapper {
  /// {@macro crypto_wrapper}
  String sha512Convert(Uint8List data) {
    return crypto.sha512.convert(data).toString();
  }
}
