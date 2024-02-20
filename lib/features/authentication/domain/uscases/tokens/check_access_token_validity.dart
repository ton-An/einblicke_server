import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_claims/token_claims.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/get_user_with_type.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/is_token_expired.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template check_frame_access_token_validity}
/// __Check Frame Access Token Valididty__ checks if an access token is valid
/// and returns the corresponding [Frame] object if it is.
/// {@endtemplate}
///
/// {@macro check_access_token_validity}
class CheckFrameAccessTokenValidity extends CheckAccessTokenValidityWrapper<
    Frame, FrameAuthenticationRepository> {
  /// {@macro check_frame_access_token_validity}
  ///
  /// {@macro check_access_token_validity}
  const CheckFrameAccessTokenValidity({
    required super.basicAuthRepository,
    required super.isTokenExpiredUseCase,
    required super.getUserWithType,
    required super.userAuthenticationRepository,
  });
}

/// {@template check_curator_access_token_validity}
/// __Check Curator Access Token Valididty__ checks if an access token is valid
/// and returns the corresponding [Curator] object if it is.
/// {@endtemplate}
///
/// {@macro check_access_token_validity}
class CheckCuratorAccessTokenValidity extends CheckAccessTokenValidityWrapper<
    Curator, CuratorAuthenticationRepository> {
  /// {@macro check_curator_access_token_validity}
  ///
  /// {@macro check_access_token_validity}
  const CheckCuratorAccessTokenValidity({
    required super.basicAuthRepository,
    required super.isTokenExpiredUseCase,
    required super.getUserWithType,
    required super.userAuthenticationRepository,
  });
}

/// {@template check_access_token_validity_wrapper}
/// __Check Access Token Valididty Wrapper__ checks if an access token is valid
/// and returns the corresponding [U] user object if it is.
/// {@endtemplate}
///
/// {@template check_access_token_validity}
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
    required this.getUserWithType,
    required this.userAuthenticationRepository,
  });

  /// Used for checking the signature of the token
  final BasicAuthenticationRepository basicAuthRepository;

  /// Checks if a token is expired
  final IsTokenExpired isTokenExpiredUseCase;

  /// Used for getting the user from the database
  final GetUserWithType<U, R> getUserWithType;

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
        await basicAuthRepository.checkTokenSignatureValidity(
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
    return getUserWithType(
      userId: tokenPayload.userId,
      userType: tokenPayload.userType,
    );
  }
}
