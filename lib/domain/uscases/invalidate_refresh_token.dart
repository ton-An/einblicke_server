import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/domain/models/encrypted_token.dart';
import 'package:dispatch_pi_dart/domain/models/user.dart';
import 'package:dispatch_pi_dart/domain/repositories/user_authentication_repository.dart';

/// {@template invalidate_refresh_token}
/// Invalidates the given refresh token for the given user id
///
/// Parameters:
/// - [String] userId
/// - [EncryptedToken] refreshToken
///
/// Failures:
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class InvalidateRefreshToken<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro invalidate_refresh_token}
  const InvalidateRefreshToken({required this.userAuthenticationRepository});

  /// Used to invalidate the refresh token
  final R userAuthenticationRepository;

  /// {@macro invalidate_refresh_token}
  Future<Either<Failure, None>> call({
    required String userId,
    required EncryptedToken refreshToken,
  }) {
    final String refreshTokenString = refreshToken.token;

    return userAuthenticationRepository.removeRefreshTokenFromDb(
      userId,
      refreshTokenString,
    );
  }
}
