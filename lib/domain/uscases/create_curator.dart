import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_password_failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_username_failure.dart';
import 'package:dispatch_pi_dart/core/failures/username_taken_failure.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';
import 'package:dispatch_pi_dart/domain/repositories/authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_password_valid.dart';
import 'package:dispatch_pi_dart/domain/uscases/is_username_valid.dart';

/// {@template create_curator}
/// Creates a [Curator] user with a given username and password
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [Curator] if the user was created successfully
///
/// Failures:
/// - [InvalidUsernameFailure]
/// - [InvalidPasswordFailure]
/// - [UsernameTakenFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// {@endtemplate}
class CreateCurator {
  /// {@macro create_curator}
  const CreateCurator({
    required this.isUsernameValid,
    required this.isPasswordValid,
    required this.repository,
  });

  /// Used to check if the username is valid
  final IsUsernameValid isUsernameValid;

  /// Used to check if the password is valid
  final IsPasswordValid isPasswordValid;

  /// Used to create the record of the curator
  final AuthenticationRepository repository;

  /// {@macro create_curator}
  Future<Either<Failure, Curator>> call(
    String username,
    String password,
  ) async {
    return _checkUsernameValidity(username, password);
  }

  Future<Either<Failure, Curator>> _checkUsernameValidity(
    String username,
    String password,
  ) async {
    final bool isUsernameValidResult = isUsernameValid(username);

    if (!isUsernameValidResult) {
      return const Left(InvalidUsernameFailure());
    }

    return _checkPasswordValidity(username, password);
  }

  Future<Either<Failure, Curator>> _checkPasswordValidity(
    String username,
    String password,
  ) async {
    final bool isPasswordValidResult = isPasswordValid(password);

    if (!isPasswordValidResult) {
      return const Left(InvalidPasswordFailure());
    }

    return _checkUsernameTaken(username, password);
  }

  Future<Either<Failure, Curator>> _checkUsernameTaken(
    String username,
    String password,
  ) async {
    final Either<Failure, bool> isUsernameTakenEither =
        await repository.isCuratorUsernameTaken(username);

    return isUsernameTakenEither.fold(Left.new, (isUsernameTaken) {
      if (isUsernameTaken) {
        return const Left(UsernameTakenFailure());
      }

      return _generatePasswordHash(username, password);
    });
  }

  Future<Either<Failure, Curator>> _generatePasswordHash(
    String username,
    String password,
  ) async {
    final String passwordHash = repository.generatePasswordHash(password);

    return _createCurator(username, passwordHash);
  }

  Future<Either<Failure, Curator>> _createCurator(
    String username,
    String passwordHash,
  ) async {
    final Either<Failure, Curator> createCuratorEither =
        await repository.createCurator(username, passwordHash);

    return createCuratorEither;
  }
}
