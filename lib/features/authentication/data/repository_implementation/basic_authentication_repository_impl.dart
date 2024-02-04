import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/basic_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:jose/jose.dart';

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
  Future<Either<Failure, TokenClaims>> checkTokenSignatureValidity(
    String refreshToken,
  ) async {
    try {
      final TokenClaims claims =
          await basicAuthLocalDataSource.checkTokenSignatureValidity(
        refreshToken,
      );

      return Right(claims);
    } on JoseException {
      return const Left(InvalidTokenFailure());
    }
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
  Future<Either<Failure, String>> getUserIdFromToken(String token) async {
    try {
      final String userId =
          await basicAuthLocalDataSource.getUserIdFromToken(token);

      return Right(userId);
    } on JoseException {
      return const Left(InvalidTokenFailure());
    }
  }
}
