import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/basic_authentication_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late BasicAuthenticationRepositoryImpl basicAuthenticationRepositoryImpl;
  late MockBasicAuthLocalDataSource mockBasicAuthLocalDataSource;

  setUp(() {
    mockBasicAuthLocalDataSource = MockBasicAuthLocalDataSource();
    basicAuthenticationRepositoryImpl = BasicAuthenticationRepositoryImpl(
      basicAuthLocalDataSource: mockBasicAuthLocalDataSource,
    );

    registerFallbackValue(MockTokenClaims());
  });

  group("checkTokenSignatureValidity", () {});

  group("generateJWEToken", () {
    setUp(() {
      when(() => mockBasicAuthLocalDataSource.generateJWEToken(any()))
          .thenReturn(tAccessToken);
    });

    test(
        "should call generateJWEToken on the local data source and return the result",
        () {
      // act
      final result = basicAuthenticationRepositoryImpl
          .generateJWEToken(tAccessTokenClaims);

      // assert
      verify(() => mockBasicAuthLocalDataSource.generateJWEToken(any()));
      expect(result, tAccessToken);
    });
  });

  group("generatePasswordHash", () {
    setUp(() {
      when(() => mockBasicAuthLocalDataSource.generatePasswordHash(any()))
          .thenReturn(tPasswordHash);
    });

    test(
        "should call generatePasswordHash on the local data source and return the result",
        () {
      // act
      final result =
          basicAuthenticationRepositoryImpl.generatePasswordHash(tPassword);

      // assert
      verify(() => mockBasicAuthLocalDataSource.generatePasswordHash(any()));
      expect(result, tPasswordHash);
    });
  });

  group("generateTokenId", () {});

  group("generateUserId", () {});

  group("getUserIdFromToken", () {});
}
