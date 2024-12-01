import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/domain/crypto_repository.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template generate_user_id}
/// __Generate User Id__ generates a unique user id for a user
/// and checks if it is taken.
///
/// Returns:
/// - a [String] containing the generated user id
///
/// Failures:
/// - [UserIdGenerationFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class GenerateUserId<U extends User,
    R extends UserAuthenticationRepository<U>> {
  /// {@macro generate_user_id}
  const GenerateUserId({
    required this.userAuthRepository,
    required this.cryptoRepository,
  });

  /// Used to check if the generated user id is taken
  final R userAuthRepository;

  /// Used for generating unique identifiers
  final CryptoRepository cryptoRepository;

  /// {@macro generate_user_id}
  Future<Either<Failure, String>> call() {
    return _generateUserId();
  }

  Future<Either<Failure, String>> _generateUserId([
    int currentIteration = 0,
  ]) {
    final String userId = cryptoRepository.generateUuid();

    return _checkUserIdTaken(userId, currentIteration);
  }

  Future<Either<Failure, String>> _checkUserIdTaken(
    String userId,
    int currentIteration,
  ) async {
    final Either<Failure, bool> isUserIdTakenEither =
        await userAuthRepository.isUserIdTaken(userId: userId);

    return isUserIdTakenEither.fold(Left.new, (bool isUserIdTaken) {
      if (isUserIdTaken) {
        if (currentIteration > 3) {
          return const Left(UserIdGenerationFailure());
        }

        return _generateUserId(currentIteration + 1);
      }

      return Right(userId);
    });
  }
}
