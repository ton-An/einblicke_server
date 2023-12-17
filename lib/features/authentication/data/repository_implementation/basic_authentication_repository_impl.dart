import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/basic_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';

/// {@template basic_authentication_repository_impl}
/// Repository implementation for basic authentication related operations
/// {@endtemplate}
class BasicAuthenticationRepositoryImpl extends BasicAuthenticationRepository {
  /// {@macro basic_authentication_repository_impl}
  const BasicAuthenticationRepositoryImpl({
    required this.basicAuthLocalDataSource,
  });

  /// Local data source for basic authentication related operations
  final BasicAuthLocalDataSource basicAuthLocalDataSource;

  @override
  Either<Failure, TokenClaims> checkTokenSignatureValidity(
    String refreshToken,
  ) {
    // TODO: implement checkTokenSignatureValidity
    throw UnimplementedError();
  }

  @override
  String generateJWEToken(TokenClaims claims) {
    return basicAuthLocalDataSource.generateJWEToken(claims);
  }

  @override
  String generatePasswordHash(String password) {
    return basicAuthLocalDataSource.generatePasswordHash(password);
  }

  @override
  Either<Failure, String> getUserIdFromToken(String token) {
    // TODO: implement getUserIdFromToken
    throw UnimplementedError();
  }
}
