import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/*
  To-Do:
    - [ ] Add specific types for the wrapper (for curator, frame)
*/

/// {@template invalidate_refresh_token}
/// __Invalidate Refresh Token__  invalidates a given refresh token
/// for a given user id
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
