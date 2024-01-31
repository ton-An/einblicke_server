import 'dart:convert';
import 'dart:typed_data';

import 'package:dispatch_pi_dart/features/authentication/data/data_sources/basic_authentication_local_data_source.dart';
import 'package:jose/jose.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';
import '../../../../../secrets_fixture.dart';

void main() {
  late BasicAuthLocalDataSource basicAuthLocalDataSource;
  late MockCryptoWrapper cryptoWrapper;
  late Utf8Encoder utf8Encoder;
  late MockJWEBBuilderWrapper mockJweBuilderWrapper;

  late MockJsonWebEncryptionBuilder mockJweBuilder;

  late MockJsonWebEncryption tMockJsonWebEncryption;

  setUp(() {
    cryptoWrapper = MockCryptoWrapper();
    utf8Encoder = const Utf8Encoder();
    mockJweBuilderWrapper = MockJWEBBuilderWrapper();

    basicAuthLocalDataSource = BasicAuthLocalDataSourceImpl(
      cryptoWrapper: cryptoWrapper,
      utf8Encoder: utf8Encoder,
      jweBuilderWrapper: mockJweBuilderWrapper,
      secrets: tSecrets,
    );

    registerFallbackValue(Uint8List(0));

    mockJweBuilder = MockJsonWebEncryptionBuilder();
    tMockJsonWebEncryption = MockJsonWebEncryption();
    when(() => mockJweBuilderWrapper.createBuilderInstance())
        .thenReturn(mockJweBuilder);
  });

  group("checkTokenSignatureValidity", () {});

  group("generateJWEToken", () {
    setUp(() {
      when(() => mockJweBuilder.build()).thenReturn(tMockJsonWebEncryption);
      when(() => tMockJsonWebEncryption.toCompactSerialization())
          .thenReturn(tAccessToken);
    });

    test("should create a [JsonWebEncryptionBuilder] instance", () async {
      // act
      basicAuthLocalDataSource.generateJWEToken(tAccessTokenClaims);

      // assert
      verify(() => mockJweBuilderWrapper.createBuilderInstance());
    });

    test("should add a recipient to the [JsonWebEncryptionBuilder]", () async {
      // act
      basicAuthLocalDataSource.generateJWEToken(tAccessTokenClaims);

      // assert
      verify(
        () => mockJweBuilder.addRecipient(
          tJsonWebKey,
          algorithm: "RSA-OAEP-256",
        ),
      );
    });

    test(
        "should set the string content of the [JsonWebEncryptionBuilder] "
        "as a json string of the given [AccessTokenClaims]", () async {
      // act
      basicAuthLocalDataSource.generateJWEToken(tAccessTokenClaims);

      // assert
      verify(
        () => mockJweBuilder.stringContent = jsonEncode(tAccessTokenClaimsMap),
      );
    });

    test(
        "should set the string content of the [JsonWebEncryptionBuilder] "
        "as a json string of the given [RefreshTokenClaims]", () async {
      // act
      basicAuthLocalDataSource.generateJWEToken(tRefreshTokenClaims);

      // assert
      verify(
        () => mockJweBuilder.stringContent = jsonEncode(tRefreshTokenClaimsMap),
      );
    });

    test(
        "should set the encryption algorithm of the [JsonWebEncryptionBuilder] "
        "to 'A256CBC-HS512'", () async {
      // act
      basicAuthLocalDataSource.generateJWEToken(tAccessTokenClaims);

      // assert
      verify(() => mockJweBuilder.encryptionAlgorithm = "A256CBC-HS512");
    });

    test(
        "should build the token return a [JsonWebEncryption] instance "
        "with the compact serialization of the [JsonWebEncryptionBuilder]",
        () async {
      // act
      final result =
          basicAuthLocalDataSource.generateJWEToken(tAccessTokenClaims);

      // assert
      expect(result, tAccessToken);
      verify(() => mockJweBuilder.build());
      verify(() => tMockJsonWebEncryption.toCompactSerialization());
    });
  });

  group("generatePasswordHash", () {
    setUp(() {
      when(() => cryptoWrapper.sha512Convert(any())).thenReturn(tPasswordHash);
    });

    test("should return a hash of the given password", () {
      // act
      final result = basicAuthLocalDataSource.generatePasswordHash(tPassword);

      // assert
      expect(result, tPasswordHash);
      verify(() => cryptoWrapper.sha512Convert(any()));
    });
  });

  group("getUserIdFromToken", () {
    test("gsddsf", () {
      // arrange
      final result = JsonWebKey.generate("RSA1_5");

      print(result.toString());

      // act

      // assert
    });
  });
}
