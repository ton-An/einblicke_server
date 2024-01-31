import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/create_user/create_user_wrapper.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

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
    required this.createCurator,
  });

  /// Used to create the record of the curator
  final CreateUserWrapper<Curator, CuratorAuthenticationRepository>
      createCurator;

  /// {@macro create_curator}
  Future<Either<Failure, Curator>> call(
    String username,
    String password,
  ) async {
    return createCurator(username, password);
  }
}
