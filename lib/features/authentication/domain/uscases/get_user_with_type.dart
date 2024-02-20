import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Add specific types for the wrapper (for curator, frame)
*/

/// {@template get_user_with_type}
/// __Get User With Type__ gets a user from the database if the user type
/// corresponds to [U]
///
///
/// Parameters:
/// - [String] userId
/// - [dynamic] userType
///
/// Returns:
/// - [U] user
///
/// Failures:
/// - [InvalidUserTypeFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class GetUserWithType<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro get_user_with_type}
  const GetUserWithType({
    required this.userAuthenticationRepository,
  });

  /// Used to get the user from the database
  final R userAuthenticationRepository;

  /// {@macro get_user_with_type}
  Future<Either<Failure, U>> call({
    required String userId,
    required dynamic userType,
  }) async {
    if (userType != U) {
      return const Left(
        InvalidUserTypeFailure(),
      );
    }

    return userAuthenticationRepository.getUserFromId(
      userId,
    );
  }
}
