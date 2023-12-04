import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';

/// {@template invalidate_all_refresh_tokens}
/// Removes all refresh tokens for the given user id
///
/// Parameters:
/// - [String] userId
///
/// Failures:
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class InvalidateAllRefreshTokens<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro save_refresh_token}
  const InvalidateAllRefreshTokens(
      {required this.userAuthenticationRepository});

  /// Used remove all refresh tokens
  final R userAuthenticationRepository;

  /// {@macro save_refresh_token}
  Future<Either<Failure, None>> call({
    required String userId,
  }) {
    return userAuthenticationRepository.removeAllRefreshTokensFromDb(
      userId,
    );
  }
}
