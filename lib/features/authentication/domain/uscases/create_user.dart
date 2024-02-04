import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/domain/crypto_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/*
  To-Do:
    - [ ] Reflect on the future of the relationship between the wrapper and it's children (i.e. maybe make the wrapper abstract)
*/

/// {@template create_frame}
/// __Create Frame__ creates a user account for a picture frame.
/// {@endtemplate}
///
/// {@macro create_user}
class CreatePictureFrame
    extends CreateUserWrapper<Frame, FrameAuthenticationRepository> {
  /// {@macro create_frame}
  ///
  /// {@macro create_user}
  const CreatePictureFrame({
    required super.basicAuthRepository,
    required super.cryptoRepository,
    required super.isPasswordValid,
    required super.isUsernameValid,
    required super.userAuthRepository,
  });
}

/// {@template create_curator}
/// __Create Curator__ creates a user account for a curator.
///
/// {@endtemplate}
/// {@macro create_user}
class CreateCurator
    extends CreateUserWrapper<Curator, CuratorAuthenticationRepository> {
  /// {@macro create_curator}
  ///
  /// {@macro create_user}
  const CreateCurator({
    required super.basicAuthRepository,
    required super.cryptoRepository,
    required super.isPasswordValid,
    required super.isUsernameValid,
    required super.userAuthRepository,
  });
}

/// {@template create_user_wrapper}
/// __Create User Wrapper__ creates a user account for a [U] user.
/// {@endtemplate}
///
/// {@template create_user}
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
  ///
  /// {@macro create_user}
  const CreateUserWrapper({
    required this.isUsernameValid,
    required this.isPasswordValid,
    required this.userAuthRepository,
    required this.basicAuthRepository,
    required this.cryptoRepository,
  });

  /// Used to check if the username is valid
  final IsUsernameValid isUsernameValid;

  /// Used to check if the password is valid
  final IsPasswordValid isPasswordValid;

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// Used to create the record of the user
  final R userAuthRepository;

  final CryptoRepository cryptoRepository;

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
    final String userId = cryptoRepository.generateUuid();

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
