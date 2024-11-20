import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/encrypted_token.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/generate_access_token.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/generate_refresh_token.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/tokens/save_refresh_token.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template sign_in_handle_tokens}
/// __Sign In Handle Tokens__ handles the generation and saving of tokens
/// for a [U] user.
///
/// Parameters:
/// - [U] user
///
/// Returns:
/// - [ServerTokenBundle] if the tokens were generated and saved successfully
///
/// Failures:
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class GetSignInTokens<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro sign_in_handle_tokens}
  GetSignInTokens({
    required this.generateAccessToken,
    required this.generateRefreshToken,
    required this.saveRefreshToken,
  });

  /// Used to generate an access token
  final GenerateAccessToken generateAccessToken;

  /// Used to generate a refresh token
  final GenerateRefreshToken generateRefreshToken;

  /// Used to save the refresh token
  final SaveRefreshToken<U, R> saveRefreshToken;

  /// {@macro sign_in_handle_tokens}
  Future<Either<Failure, ServerTokenBundle>> call(
    U user,
  ) async {
    return _generateTokens(user: user);
  }

  Future<Either<Failure, ServerTokenBundle>> _generateTokens({
    required User user,
  }) async {
    final EncryptedToken accessToken = generateAccessToken(user: user);
    final EncryptedToken refreshToken = generateRefreshToken(user: user);

    return _saveRefreshToken(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<Either<Failure, ServerTokenBundle>> _saveRefreshToken({
    required User user,
    required EncryptedToken accessToken,
    required EncryptedToken refreshToken,
  }) async {
    final Either<Failure, None> saveRefreshTokenEither = await saveRefreshToken(
      userId: user.userId,
      refreshToken: refreshToken,
    );

    return saveRefreshTokenEither.fold(
      Left.new,
      (None none) => Right(
        ServerTokenBundle(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      ),
    );
  }
}
