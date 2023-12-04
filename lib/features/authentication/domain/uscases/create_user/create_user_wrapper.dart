import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_username_failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_id_generation_failure.dart';
import 'package:dispatch_pi_dart/core/failures/username_taken_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_password_valid.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/is_username_valid.dart';

/// {@template create_user_wrapper}
/// A wrapper for creating a [U] user with a given username and password
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [U] if the user was created successfully
///
/// Failures:
/// - [InvalidUsernameFailure]
/// - [InvalidPasswordFailure]
/// - [UsernameTakenFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class CreateUserWrapper<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro create_user_wrapper}
  const CreateUserWrapper({
    required this.isUsernameValid,
    required this.isPasswordValid,
    required this.userAuthRepository,
    required this.basicAuthRepository,
  });

  /// Used to check if the username is valid
  final IsUsernameValid isUsernameValid;

  /// Used to check if the password is valid
  final IsPasswordValid isPasswordValid;

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// Used to create the record of the user
  final R userAuthRepository;

  /// {@macro create_user_wrapper}
  Future<Either<Failure, U>> call(
    String username,
    String password,
  ) async {
    return _checkUsernameValidity(username, password);
  }

  Future<Either<Failure, U>> _checkUsernameValidity(
    String username,
    String password,
  ) async {
    final bool isUsernameValidResult = isUsernameValid(username);

    if (!isUsernameValidResult) {
      return const Left(InvalidUsernameFailure());
    }

    return _checkPasswordValidity(username, password);
  }

  Future<Either<Failure, U>> _checkPasswordValidity(
    String username,
    String password,
  ) async {
    final bool isPasswordValidResult = isPasswordValid(password);

    if (!isPasswordValidResult) {
      return const Left(InvalidPasswordFailure());
    }

    return _checkUsernameTaken(username, password);
  }

  Future<Either<Failure, U>> _checkUsernameTaken(
    String username,
    String password,
  ) async {
    final Either<Failure, bool> isUsernameTakenEither =
        await userAuthRepository.isUsernameTaken(username);

    return isUsernameTakenEither.fold(Left.new, (isUsernameTaken) {
      if (isUsernameTaken) {
        return const Left(UsernameTakenFailure());
      }

      return _generateUserId(username, password);
    });
  }

  Future<Either<Failure, U>> _generateUserId(
    String username,
    String password, [
    int currentIteration = 0,
  ]) {
    final String userId = basicAuthRepository.generateUserId();

    return _checkUserIdTaken(userId, username, password, currentIteration);
  }

  Future<Either<Failure, U>> _checkUserIdTaken(
    String userId,
    String username,
    String password,
    int currentIteration,
  ) async {
    final Either<Failure, bool> isUserIdTakenEither =
        await userAuthRepository.isUserIdTaken(userId);

    return isUserIdTakenEither.fold(Left.new, (bool isUserIdTaken) {
      if (isUserIdTaken) {
        if (currentIteration > 3) {
          return const Left(UserIdGenerationFailure());
        }

        return _generateUserId(username, password, currentIteration + 1);
      }

      return _generatePasswordHash(userId, username, password);
    });
  }

  Future<Either<Failure, U>> _generatePasswordHash(
    String userId,
    String username,
    String password,
  ) async {
    final String passwordHash =
        basicAuthRepository.generatePasswordHash(password);

    return _createUser(userId, username, passwordHash);
  }

  Future<Either<Failure, U>> _createUser(
    String userId,
    String username,
    String passwordHash,
  ) async {
    final Either<Failure, U> createUserEither =
        await userAuthRepository.createUser(userId, username, passwordHash);

    return createUserEither;
  }
}
