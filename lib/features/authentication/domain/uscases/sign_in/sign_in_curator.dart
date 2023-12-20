import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/user_not_found_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/authentication_credentials.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/uscases/sign_in/sign_in_wrapper.dart';

/// {@template sign_in_curator}
/// Use case for signing in a [Curator].
///
/// Parameters:
/// - [String] the curator's username
/// - [String] the curator's password
///
/// Returns:
/// - [AuthenticationCredentials] if the curator was successfully signed in
///
/// Failures:
/// - [UserNotFoundFailure] if the curator was not found
/// - [DatabaseReadFailure] if the database could not be read
/// {@endtemplate}
class SignInCurator {
  /// {@macro sign_in_curator}
  SignInCurator({required this.signInCurator});

  /// The [SignInWrapper] for [Curator]s.
  final SignInWrapper<Curator, CuratorAuthenticationRepository> signInCurator;

  /// {@macro sign_in_curator}
  Future<Either<Failure, AuthenticationCredentials>> call({
    required String username,
    required String password,
  }) {
    return signInCurator(username: username, password: password);
  }
}
