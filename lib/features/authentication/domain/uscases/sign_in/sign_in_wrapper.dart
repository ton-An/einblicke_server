import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_access_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/generate_encrypted_token/generate_refresh_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/tokens/save_refresh_token/save_refresh_token.dart';

/// {@template sign_in_wrapper}
/// A wrapper for signing in a [U] user with a given username and password
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [AuthenticationCredentials] if the user was found
///
/// Failures:
/// - [UserNotFoundFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class SignInWrapper<U extends User, R extends UserAuthenticationRepository<U>> {
  /// {@macro sign_in_wrapper}
  SignInWrapper({
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
  Future<Either<Failure, AuthenticationCredentials>> call({
    required String username,
    required String password,
  }) {
    return _getHashedPassword(username: username, password: password);
  }

  Future<Either<Failure, AuthenticationCredentials>> _getHashedPassword({
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

  Future<Either<Failure, AuthenticationCredentials>> _getUser({
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

  Future<Either<Failure, AuthenticationCredentials>> _generateTokens({
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

  Future<Either<Failure, AuthenticationCredentials>> _saveRefreshToken({
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
        AuthenticationCredentials(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      ),
    );
  }
}
