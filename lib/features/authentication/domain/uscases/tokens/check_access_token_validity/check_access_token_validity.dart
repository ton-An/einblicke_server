import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_user_role_failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_claims.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/is_token_expired.dart';

/// {@template check_access_token_validity_wrapper}
/// Checks if an access token is valid
///
/// Parameters:
/// - [String] accessToken
///
/// Returns:
/// - [U] a user object if the token is valid
///
/// Failures:
/// - [ExpiredTokenFailure]
/// - [InvalidTokenFailure]
/// - [DatabaseReadFailure]
/// - [InvalidUserTypeFailure]
/// - [UserNotFoundFailure]
/// {@endtemplate}
class CheckAccessTokenValidityWrapper<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro check_access_token_validity_wrapper}
  const CheckAccessTokenValidityWrapper({
    required this.basicAuthRepository,
    required this.isTokenExpiredUseCase,
    required this.userAuthenticationRepository,
  });

  /// Used for checking the signature of the token
  final BasicAuthenticationRepository basicAuthRepository;

  /// Checks if a token is expired
  final IsTokenExpired isTokenExpiredUseCase;

  /// Used for getting the user from the database
  final R userAuthenticationRepository;

  /// {@macro check_access_token_validity}
  Future<Either<Failure, U>> call({required String accessToken}) {
    return _checkTokenSignatureValidity(
      accessToken: accessToken,
    );
  }

  Future<Either<Failure, U>> _checkTokenSignatureValidity({
    required String accessToken,
  }) async {
    final Either<Failure, TokenClaims> signatureCheckEither =
        basicAuthRepository.checkTokenSignatureValidity(
      accessToken,
    );

    return signatureCheckEither.fold(
      Left.new,
      (tokenPayload) => _checkTokenExpiration(
        tokenPayload: tokenPayload,
      ),
    );
  }

  Future<Either<Failure, U>> _checkTokenExpiration({
    required TokenClaims tokenPayload,
  }) async {
    final bool isTokenExpired = isTokenExpiredUseCase(
      expiresAt: tokenPayload.expiresAt,
    );

    if (isTokenExpired) {
      return const Left(
        ExpiredTokenFailure(),
      );
    }

    return _getUser(
      tokenPayload: tokenPayload,
    );
  }

  Future<Either<Failure, U>> _getUser({
    required TokenClaims tokenPayload,
  }) async {
    if (tokenPayload.userType != U) {
      return const Left(
        InvalidUserTypeFailure(),
      );
    }

    return userAuthenticationRepository.getUserFromId(
      tokenPayload.userId,
    );
  }
}
