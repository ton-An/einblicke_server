import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Add specific types for the wrapper (for curator, frame)
*/

/// {@template invalidate_all_refresh_tokens}
/// __Invalidate All Refresh Tokens__ invalidates all refresh tokens for a given
/// user
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
