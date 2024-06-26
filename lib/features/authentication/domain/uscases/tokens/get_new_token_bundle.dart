import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/encrypted_token.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/check_refresh_token_validity.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/generate_access_token.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/generate_refresh_token.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/invalidate_all_refresh_tokens.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/invalidate_refresh_token.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/save_refresh_token.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Add specific types for the wrapper (for curator, frame)
*/

/// {@template get_new_tokens}
/// __Get New Token Bundle__ gets a new [TokenBundle] object containing the new
/// access and refresh tokens.
///
/// Parameters:
/// - [String] oldRefreshToken
///
/// Returns:
/// - [TokenBundle] object containing the new tokens
///
///
/// Failures:
/// - [ExpiredTokenFailure]
/// - [InvalidTokenFailure]
/// - [RefreshTokenReuseFailure]
/// - [InvalidUserTypeFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// - [UserNotFoundFailure]
/// {@endtemplate}
class GetNewTokenTokenBundle<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro get_new_tokens}
  const GetNewTokenTokenBundle({
    required this.checkRefreshTokenValidityWrapper,
    required this.generateAccessToken,
    required this.generateRefreshToken,
    required this.invalidateRefreshToken,
    required this.invalidateAllRefreshTokens,
    required this.saveRefreshTokenUsecase,
    required this.userAuthRepository,
    required this.basicAuthRepository,
  });

  /// Used to check the validity of the refresh token
  final CheckRefreshTokenValidityWrapper<U, R> checkRefreshTokenValidityWrapper;

  /// Used to generate the access token
  final GenerateAccessToken generateAccessToken;

  /// Used to generate the refresh token
  final GenerateRefreshToken generateRefreshToken;

  /// Used to invalidate the old refresh token
  final InvalidateRefreshToken<U, R> invalidateRefreshToken;

  /// Used to invalidate all refresh tokens in case of a refresh token re-use
  final InvalidateAllRefreshTokens<U, R> invalidateAllRefreshTokens;

  /// Used to save the new refresh token
  final SaveRefreshToken<U, R> saveRefreshTokenUsecase;

  /// Used to get the user from the user id
  final UserAuthenticationRepository<U> userAuthRepository;

  /// Used to get the user id from the old refresh token
  final BasicAuthenticationRepository basicAuthRepository;

  /// {@macro get_new_tokens}
  Future<Either<Failure, TokenBundle>> call({
    required String oldRefreshToken,
  }) {
    return _checkRefreshTokenValidity(refreshToken: oldRefreshToken);
  }

  Future<Either<Failure, TokenBundle>> _checkRefreshTokenValidity({
    required String refreshToken,
  }) async {
    final checkRefreshTokenValidityResult =
        await checkRefreshTokenValidityWrapper(
      refreshToken: refreshToken,
    );

    return checkRefreshTokenValidityResult.fold(
      (Failure failure) {
        if (failure is RefreshTokenReuseFailure) {
          return _invalidateAllRefreshTokens(
            refreshToken: refreshToken,
          );
        }

        return Left(failure);
      },
      (User user) => _generateAccessToken(
        user: user,
        oldRefreshToken: refreshToken,
      ),
    );
  }

  Future<Either<Failure, TokenBundle>> _invalidateAllRefreshTokens({
    required String refreshToken,
  }) async {
    final Either<Failure, String> getUserIdEither =
        await basicAuthRepository.getUserIdFromToken(refreshToken);

    return getUserIdEither.fold(Left.new, (String userId) async {
      final Either<Failure, None> invalidateAllRefreshTokensEither =
          await invalidateAllRefreshTokens(userId: userId);

      return invalidateAllRefreshTokensEither.fold(
        Left.new,
        (_) => const Left(RefreshTokenReuseFailure()),
      );
    });
  }

  Future<Either<Failure, TokenBundle>> _generateAccessToken({
    required User user,
    required String oldRefreshToken,
  }) async {
    // needs to get the user from id
    final EncryptedToken accessToken = generateAccessToken(
      user: user,
    );

    return _generateRefreshToken(
      user: user,
      oldRefreshToken: oldRefreshToken,
      accessToken: accessToken,
    );
  }

  Future<Either<Failure, TokenBundle>> _generateRefreshToken({
    required User user,
    required String oldRefreshToken,
    required EncryptedToken accessToken,
  }) {
    final EncryptedToken refreshToken = generateRefreshToken(user: user);

    return _invalidateOldRefreshToken(
      user: user,
      oldRefreshToken: oldRefreshToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<Either<Failure, TokenBundle>> _invalidateOldRefreshToken({
    required User user,
    required String oldRefreshToken,
    required EncryptedToken accessToken,
    required EncryptedToken refreshToken,
  }) async {
    final Either<Failure, None> invalidateOldTokenEither =
        await invalidateRefreshToken(
      userId: user.userId,
      refreshTokenString: oldRefreshToken,
    );

    return invalidateOldTokenEither.fold(
      Left.new,
      (None none) {
        return _saveNewRefreshToken(
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      },
    );
  }

  Future<Either<Failure, TokenBundle>> _saveNewRefreshToken({
    required User user,
    required EncryptedToken accessToken,
    required EncryptedToken refreshToken,
  }) async {
    final Either<Failure, None> saveTokenEither = await saveRefreshTokenUsecase(
      userId: user.userId,
      refreshToken: refreshToken,
    );

    return saveTokenEither.fold(Left.new, (None none) {
      return Right(
        TokenBundle(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    });
  }
}
