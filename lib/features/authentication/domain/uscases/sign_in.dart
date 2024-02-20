import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/token_bundle.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_access_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/save_refresh_token.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template sign_in_picture_frame}
/// ___Sign In Frame__ signs in a picture frame user with a given
/// username and password
/// {@endtemplate}
///
/// {@macro sign_in}
class SignInPictureFrame
    extends SignInWrapper<Frame, FrameAuthenticationRepository> {
  /// {@macro sign_in_picture_frame}
  ///
  /// {@macro sign_in}
  const SignInPictureFrame({
    required super.userAuthRepository,
    required super.basicAuthRepository,
    required super.generateAccessToken,
    required super.generateRefreshToken,
    required super.saveRefreshTokenUsecase,
  });
}

/// {@template sign_in_curator}
/// __Sign In Curator__ signs in a curator user with a given
/// username and password
/// {@endtemplate}
///
/// {@macro sign_in}
class SignInCurator
    extends SignInWrapper<Curator, CuratorAuthenticationRepository> {
  /// {@macro sign_in_curator}
  ///
  /// {@macro sign_in}
  const SignInCurator({
    required super.userAuthRepository,
    required super.basicAuthRepository,
    required super.generateAccessToken,
    required super.generateRefreshToken,
    required super.saveRefreshTokenUsecase,
  });
}

/// {@template sign_in_wrapper}
/// __Sign In Wrapper__ wrapper for signing in a [U] user with a given username and password
/// {@endtemplate}
///
/// {@template sign_in}
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [TokenBundle] if the user was found
///
/// Failures:
/// - [UserNotFoundFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class SignInWrapper<U extends User, R extends UserAuthenticationRepository<U>> {
  /// {@macro sign_in_wrapper}
  ///
  /// {@macro sign_in}
  const SignInWrapper({
    required this.userAuthRepository,
    required this.basicAuthRepository,
    required this.generateAccessToken,
    required this.generateRefreshToken,
    required this.saveRefreshTokenUsecase,
  });

  /// Used to create the record of the [U] user
  final R userAuthRepository;

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// Used to generate an access token
  final GenerateAccessToken generateAccessToken;

  /// Used to generate a refresh token
  final GenerateRefreshToken generateRefreshToken;

  /// Used to save the refresh token
  final SaveRefreshToken<U, R> saveRefreshTokenUsecase;

  /// {@macro sign_in_wrapper}
  Future<Either<Failure, TokenBundle>> call({
    required String username,
    required String password,
  }) {
    return _getHashedPassword(username: username, password: password);
  }

  Future<Either<Failure, TokenBundle>> _getHashedPassword({
    required String username,
    required String password,
  }) {
    final String passwordHash =
        basicAuthRepository.generatePasswordHash(password);

    return _getUser(
      username: username,
      passwordHash: passwordHash,
    );
  }

  Future<Either<Failure, TokenBundle>> _getUser({
    required String username,
    required String passwordHash,
  }) async {
    final Either<Failure, U> user = await userAuthRepository.getUser(
      username,
      passwordHash,
    );

    return user.fold(
      Left.new,
      (U user) => _generateTokens(user: user),
    );
  }

  Future<Either<Failure, TokenBundle>> _generateTokens({
    required U user,
  }) async {
    final EncryptedToken accessToken = generateAccessToken(user: user);
    final EncryptedToken refreshToken = generateRefreshToken(user: user);

    return _saveRefreshToken(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<Either<Failure, TokenBundle>> _saveRefreshToken({
    required U user,
    required EncryptedToken accessToken,
    required EncryptedToken refreshToken,
  }) async {
    final Either<Failure, None> saveRefreshTokenEither =
        await saveRefreshTokenUsecase(
      userId: user.userId,
      refreshToken: refreshToken,
    );

    return saveRefreshTokenEither.fold(
      Left.new,
      (None none) => Right(
        TokenBundle(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      ),
    );
  }
}
