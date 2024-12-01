import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/generate_user_id.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Reflect on the future of the relationship between the wrapper and it's children (i.e. maybe make the wrapper abstract)
*/

/// {@template create_curator}
/// __Create Curator__ creates a user account for a [Curator].
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [Curator] if the curator was created successfully
///
/// Failures:
/// - [InvalidUsernameFailure]
/// - [InvalidPasswordFailure]
/// - [UsernameTakenFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// - [UserIdGenerationFailure]
/// {@endtemplate}
class CreateCurator {
  /// {@macro create_curator}
  const CreateCurator({
    required this.isUsernameValid,
    required this.isPasswordValid,
    required this.curatorAuthRepository,
    required this.basicAuthRepository,
    required this.generateUserId,
  });

  /// Used to check if the username is valid
  final IsUsernameValid isUsernameValid;

  /// Used to check if the password is valid
  final IsPasswordValid isPasswordValid;

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// Used to create the record of the curator
  final CuratorAuthenticationRepository curatorAuthRepository;

  /// Used to generate the user id
  final GenerateUserId generateUserId;

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
        await curatorAuthRepository.isUsernameTaken(username: username);

    return isUsernameTakenEither.fold(Left.new, (isUsernameTaken) {
      if (isUsernameTaken) {
        return const Left(UsernameTakenFailure());
      }

      return _generateUserId(username, password);
    });
  }

  Future<Either<Failure, Curator>> _generateUserId(
    String username,
    String password,
  ) async {
    final Either<Failure, String> generateUserIdEither = await generateUserId();

    return generateUserIdEither.fold(Left.new, (String userId) {
      return _generatePasswordHash(userId, username, password);
    });
  }

  Future<Either<Failure, Curator>> _generatePasswordHash(
    String userId,
    String username,
    String password,
  ) async {
    final String passwordHash =
        basicAuthRepository.generatePasswordHash(password);

    return _createCurator(userId, username, passwordHash);
  }

  Future<Either<Failure, Curator>> _createCurator(
    String userId,
    String username,
    String passwordHash,
  ) async {
    final Either<Failure, Curator> createCuratorEither =
        await curatorAuthRepository.createCurator(
      userId: userId,
      username: username,
      passwordHash: passwordHash,
    );

    return createCuratorEither;
  }
}
