import 'dart:convert';

import 'package:dispatch_pi_dart/core/crypto_wrapper.dart';
import 'package:dispatch_pi_dart/core/jwe_builder_wrapper.dart';
import 'package:dispatch_pi_dart/core/secrets.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/access_token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/refresh_token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:jose/jose.dart';

/// {@template basic_auth_local_data_source}
/// Local data source for basic authentication related operations
/// {@endtemplate}
abstract class BasicAuthLocalDataSource {
  /// {@macro basic_auth_local_data_source}
  const BasicAuthLocalDataSource();

  /// Generates a hash of the given password
  ///
  /// Parameters:
  /// - [String] password
  ///
  /// Returns:
  /// - a [String] containing the hash of the given password
  String generatePasswordHash(String password);

  /// Generates a signed token with the given payload
  ///
  /// Parameters:
  /// - [Map] payload
  ///
  /// Returns:
  /// - a [String] containing the signed token
  String generateJWEToken(TokenClaims claims);

  /// Checks if the given token is valid
  ///
  /// Parameters:
  /// - [String] refreshToken
  ///
  /// Returns:
  /// - a [TokenClaims] containing the payload of the token
  ///
  /// Throws:
  /// - [JoseException]
  Future<TokenClaims> checkTokenSignatureValidity(
    String token,
  );

  /// Gets the user id from a given token
  ///
  /// Parameters:
  /// - [String] token
  ///
  /// Returns:
  /// - a [String] containing the user id
  ///
  /// Throws:
  /// - [JoseException]
  Future<String> getUserIdFromToken(String token);
}

/// {@macro basic_auth_local_data_source}
class BasicAuthLocalDataSourceImpl extends BasicAuthLocalDataSource {
  /// {@macro basic_auth_local_data_source}
  const BasicAuthLocalDataSourceImpl({
    required this.cryptoWrapper,
    required this.utf8Encoder,
    required this.jweBuilderWrapper,
    required this.secrets,
  });

  /// Used to generate password hashes
  final CryptoWrapper cryptoWrapper;

  /// Used to encode strings to utf8
  final Utf8Encoder utf8Encoder;

  /// Used to generate signed tokens
  final JWEBuilderWrapper jweBuilderWrapper;

  /// Used to get app's secrets
  final Secrets secrets;

  static const String _jweHashAlgorithm = "RSA1_5";

  static const String _encytpionAlgorithm = "A128CBC-HS256";

  @override
  Future<TokenClaims> checkTokenSignatureValidity(String token) async {
    final Map<String, String> payloadMap = await _getTokenPayloadMap(token);

    final TokenClaims tokenClaims = _claimsFromJson(payloadMap);

    return tokenClaims;
  }

  @override
  String generateJWEToken(TokenClaims claims) {
    final JsonWebEncryptionBuilder jweBuilder =
        jweBuilderWrapper.createBuilderInstance();

    final Map<String, dynamic> payload = _claimsToJson(claims);
    jweBuilder.stringContent = jsonEncode(payload);

    final JsonWebKey jsonWebKey = JsonWebKey.fromJson(secrets.jsonWebKey);
    jweBuilder.addRecipient(jsonWebKey, algorithm: _jweHashAlgorithm);

    jweBuilder.encryptionAlgorithm = _encytpionAlgorithm;
    final JsonWebEncryption jweToken = jweBuilder.build();

    final jweTokenString = jweToken.toCompactSerialization();

    return jweTokenString;
  }

  @override
  String generatePasswordHash(String password) {
    final passwordBytes = utf8Encoder.convert(password);

    final String passwordHash = cryptoWrapper.sha512Convert(passwordBytes);

    return passwordHash;
  }

  @override
  Future<String> getUserIdFromToken(String token) async {
    final Map<String, String> payloadMap = await _getTokenPayloadMap(token);

    return payloadMap["user_id"]!;
  }

  Future<Map<String, String>> _getTokenPayloadMap(String token) async {
    final JsonWebEncryption jweToken =
        JsonWebEncryption.fromCompactSerialization(token);

    final JsonWebKey jsonWebKey = JsonWebKey.fromJson(secrets.jsonWebKey);

    final JsonWebKeyStore keyStore = jweBuilderWrapper.createKeyStoreInstance()
      ..addKey(jsonWebKey);

    final JosePayload payload = await jweToken.getPayload(keyStore);

    final Map<String, String> payloadMap =
        Map.castFrom<String, dynamic, String, String>(
      jsonDecode(payload.stringContent) as Map<String, dynamic>,
    );
    return payloadMap;
  }

  Map<String, String> _claimsToJson(TokenClaims claims) {
    return <String, String>{
      if (claims is RefreshTokenClaims) "token_id": claims.tokenId,
      "user_id": claims.userId,
      "user_type": claims.userType.toString(),
      "issued_at": claims.issuedAt.toIso8601String(),
      "expires_at": claims.expiresAt.toIso8601String(),
    };
  }

  TokenClaims _claimsFromJson(Map<String, String> claimsMap) {
    if (claimsMap.containsKey("token_id")) {
      return RefreshTokenClaims(
        tokenId: claimsMap["token_id"]!,
        userId: claimsMap["user_id"]!,
        userType: TokenClaims.userTypesFromJson(claimsMap["user_type"]!),
        issuedAt: DateTime.parse(claimsMap["issued_at"]!),
        expiresAt: DateTime.parse(claimsMap["expires_at"]!),
      );
    } else {
      return AccessTokenClaims(
        userId: claimsMap["user_id"]!,
        userType: TokenClaims.userTypesFromJson(claimsMap["user_type"]!),
        issuedAt: DateTime.parse(claimsMap["issued_at"]!),
        expiresAt: DateTime.parse(claimsMap["expires_at"]!),
      );
    }
  }
}
