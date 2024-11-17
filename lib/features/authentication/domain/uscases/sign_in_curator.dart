import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/basic_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in_handle_tokens.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template sign_in_curator}
/// __Sign In Curator__  signs in a [Curator] user with a given username and password
///
/// Parameters:
/// - [String] username
/// - [String] password
///
/// Returns:
/// - [ServerTokenBundle] if the curator was found
///
/// Failures:
/// - [UserNotFoundFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class SignInCurator {
  /// {@macro sign_in_curator}
  ///
  /// {@macro sign_in_curator}
  const SignInCurator({
    required this.curatorAuthenticationRepository,
    required this.basicAuthRepository,
    required this.signInHandleTokens,
  });

  /// Used to create the record of the [Curator] user
  final CuratorAuthenticationRepository curatorAuthenticationRepository;

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// Used to handle the tokens after the user has been found
  final SignInHandleTokens<Curator, CuratorAuthenticationRepository>
      signInHandleTokens;

  /// {@macro sign_in_curator}
  Future<Either<Failure, ServerTokenBundle>> call({
    required String username,
    required String password,
  }) {
    return _getHashedPassword(username: username, password: password);
  }

  Future<Either<Failure, ServerTokenBundle>> _getHashedPassword({
    required String username,
    required String password,
  }) {
    final String passwordHash =
        basicAuthRepository.generatePasswordHash(password);

    return _getCurator(
      username: username,
      passwordHash: passwordHash,
    );
  }

  Future<Either<Failure, ServerTokenBundle>> _getCurator({
    required String username,
    required String passwordHash,
  }) async {
    final Either<Failure, Curator> userEither =
        await curatorAuthenticationRepository.getCuratorFromCredentials(
      username,
      passwordHash,
    );

    return userEither.fold(
      Left.new,
      (Curator curator) => _handleSignInTokens(curator: curator),
    );
  }

  Future<Either<Failure, ServerTokenBundle>> _handleSignInTokens(
      {required Curator curator}) {
    return signInHandleTokens(curator);
  }
}
