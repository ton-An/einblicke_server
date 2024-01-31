import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template save_refresh_token}
/// Saves the given refresh token for the given user id
///
/// Parameters:
/// - [String] userId
/// - [EncryptedToken] refreshToken
///
/// Failures:
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class SaveRefreshToken<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro save_refresh_token}
  const SaveRefreshToken({required this.userAuthenticationRepository});

  /// Used to save the refresh token
  final R userAuthenticationRepository;

  /// {@macro save_refresh_token}
  Future<Either<Failure, None>> call({
    required String userId,
    required EncryptedToken refreshToken,
  }) {
    final String refreshTokenString = refreshToken.token;

    return userAuthenticationRepository.saveRefreshTokenToDb(
      userId,
      refreshTokenString,
    );
  }
}
