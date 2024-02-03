// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/data/repository_implementation/basic_authentication_repository_impl.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:jose/jose.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

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

  group("checkTokenSignatureValidity", () {
    setUp(() {
      when(() =>
              mockBasicAuthLocalDataSource.checkTokenSignatureValidity(any()))
          .thenAnswer((_) async => tAccessTokenClaims);
    });

    test(
        "should call checkTokenSignatureValidity on the local data source "
        "and return the result", () async {
      // act
      final result = await basicAuthenticationRepositoryImpl
          .checkTokenSignatureValidity(tAccessToken);

      // assert
      expect(result, Right(tAccessTokenClaims));
      verify(
        () => mockBasicAuthLocalDataSource
            .checkTokenSignatureValidity(tAccessToken),
      );
    });

    test(
        "should return a [InvalidTokenFailure] when checkTokenSignatureValidity "
        "throws a [JoseException]", () async {
      // arrange
      when(() =>
              mockBasicAuthLocalDataSource.checkTokenSignatureValidity(any()))
          .thenThrow(JoseException("tMessage"));

      // act
      final result = await basicAuthenticationRepositoryImpl
          .checkTokenSignatureValidity(tAccessToken);

      // assert
      expect(result, const Left(InvalidTokenFailure()));
    });
  });

  group("generateJWEToken", () {
    setUp(() {
      when(() => mockBasicAuthLocalDataSource.generateJWEToken(any()))
          .thenReturn(tAccessToken);
    });

    test(
        "should call generateJWEToken on the local data source "
        "and return the result", () {
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
        "should call generatePasswordHash on the local data source "
        "and return the result", () {
      // act
      final result =
          basicAuthenticationRepositoryImpl.generatePasswordHash(tPassword);

      // assert
      verify(() => mockBasicAuthLocalDataSource.generatePasswordHash(any()));
      expect(result, tPasswordHash);
    });
  });

  group("getUserIdFromToken", () {
    setUp(() {
      when(() => mockBasicAuthLocalDataSource.getUserIdFromToken(any()))
          .thenAnswer((_) async => tUserId);
    });

    test(
        "should call getUserIdFromToken on the local data source "
        "and return the result", () async {
      // act
      final result = await basicAuthenticationRepositoryImpl
          .getUserIdFromToken(tAccessToken);

      // assert
      expect(result, const Right(tUserId));
      verify(
        () => mockBasicAuthLocalDataSource.getUserIdFromToken(tAccessToken),
      );
    });

    test(
        "should return a [InvalidTokenFailure] when getUserIdFromToken "
        "throws a [JoseException]", () async {
      // arrange
      when(() => mockBasicAuthLocalDataSource.getUserIdFromToken(any()))
          .thenThrow(JoseException("tMessage"));

      // act
      final result = await basicAuthenticationRepositoryImpl
          .getUserIdFromToken(tAccessToken);

      // assert
      expect(result, const Left(InvalidTokenFailure()));
    });
  });
}
