import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_user_role_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';

/// {@template get_user_with_type}
/// Gets a user from the database with the specified type
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
