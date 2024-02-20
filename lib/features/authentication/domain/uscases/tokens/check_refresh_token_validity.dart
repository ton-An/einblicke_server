import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/get_user_with_type.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/is_token_expired.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Add specific types for the wrapper (for curator, frame)
*/

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
/// - [InvalidUserTypeFailure]
/// {@endtemplate}
class CheckRefreshTokenValidityWrapper<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro check_refresh_token_validity}
  const CheckRefreshTokenValidityWrapper({
    required this.userAuthRepository,
    required this.basicAuthRepository,
    required this.isTokenExpiredUseCase,
    required this.getUserWithType,
  });

  /// The repository for user authentication related operations
  final R userAuthRepository;

  /// The repository for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// The use case for checking if a token is expired
  final IsTokenExpired isTokenExpiredUseCase;

  /// The use case for getting a user from the database
  final GetUserWithType<U, R> getUserWithType;

  /// {@macro check_refresh_token_validity}
  Future<Either<Failure, U>> call({
    required String refreshToken,
  }) async {
    return _checkTokenSignatureValidity(refreshToken: refreshToken);
  }

  Future<Either<Failure, U>> _checkTokenSignatureValidity({
    required String refreshToken,
  }) async {
    final Either<Failure, TokenClaims> signatureCheckEither =
        await basicAuthRepository.checkTokenSignatureValidity(
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

  Future<Either<Failure, U>> _checkTokenExpiration({
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

  Future<Either<Failure, U>> _checkTokenReuse({
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

        return _getUser(userId: payload.userId);
      },
    );
  }

  Future<Either<Failure, U>> _getUser({
    required String userId,
  }) async {
    return getUserWithType(
      userId: userId,
      userType: U,
    );
  }
}
