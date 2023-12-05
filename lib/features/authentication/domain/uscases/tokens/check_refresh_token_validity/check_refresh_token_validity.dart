import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/refresh_token_reuse_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/is_token_expired.dart';

/// {@template check_refresh_token_validity}
/// A wrapper for checking if a refresh token is valid
/// It checks if the signature is valid, if the token is expired and
/// if the token has been reused.
///
/// Parameters:
/// - [String] refreshToken
///
/// Returns:
/// - [String] the user id
///
/// Failures:
/// - [ExpiredTokenFailure]
/// - [InvalidTokenFailure]
/// - [RefreshTokenReuseFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class CheckRefreshTokenValidityWrapper<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro check_refresh_token_validity}
  const CheckRefreshTokenValidityWrapper({
    required this.userAuthRepository,
    required this.basicAuthRepository,
    required this.isTokenExpiredUseCase,
  });

  /// The repository for user authentication related operations
  final R userAuthRepository;

  /// The repository for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// The use case for checking if a token is expired
  final IsTokenExpired isTokenExpiredUseCase;

  /// {@macro check_refresh_token_validity}
  Future<Either<Failure, String>> call({
    required String refreshToken,
  }) async {
    return _checkTokenSignatureValidity(refreshToken: refreshToken);
  }

  Future<Either<Failure, String>> _checkTokenSignatureValidity({
    required String refreshToken,
  }) async {
    final Either<Failure, TokenClaims> signatureCheckEither =
        basicAuthRepository.checkTokenSignatureValidity(
      refreshToken,
    );

    return signatureCheckEither.fold(
      Left.new,
      (TokenClaims payload) => _checkTokenExpiration(
        refreshToken: refreshToken,
        payload: payload,
      ),
    );
  }

  Future<Either<Failure, String>> _checkTokenExpiration({
    required String refreshToken,
    required TokenClaims payload,
  }) async {
    final bool isTokenExpired = isTokenExpiredUseCase(
      expiresAt: payload.expiresAt,
    );

    if (isTokenExpired) {
      return const Left(ExpiredTokenFailure());
    }

    return _checkTokenReuse(
      refreshToken: refreshToken,
      payload: payload,
    );
  }

  Future<Either<Failure, String>> _checkTokenReuse({
    required String refreshToken,
    required TokenClaims payload,
  }) async {
    final Either<Failure, bool> isRefreshTokenInDbEither =
        await userAuthRepository.isRefreshTokenInUserDb(
      payload.userId,
      refreshToken,
    );

    return isRefreshTokenInDbEither.fold(
      Left.new,
      (bool isRefreshTokenInDb) {
        if (!isRefreshTokenInDb) {
          return const Left(RefreshTokenReuseFailure());
        }

        return Right(payload.userId);
      },
    );
  }
}