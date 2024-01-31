import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template invalidate_refresh_token}
/// Invalidates the given refresh token for the given user id
///
/// Parameters:
/// - [String] userId
/// - [String] refreshTokenString
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
    required String refreshTokenString,
  }) {
    return userAuthenticationRepository.removeRefreshTokenFromDb(
      userId,
      refreshTokenString,
    );
  }
}
