import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/token_decryption_failure.dart';
import 'package:dispatch_pi_dart/domain/repositories/basic_authentication_repository.dart';

/// {@template check_token_validity}
/// Checks if the given token is valid
///
/// Parameters:
/// - [String] encrypted token
///
/// Returns:
/// [String] the users id
///
/// Failures:
/// - [TokenDecryptionFailure]
/// - [InvalidTokenFailure]
/// - [ExpiredTokenFailure]
/// {@endtemplate}
class CheckTokenValidity {
  /// {@macro check_token_validity}
  const CheckTokenValidity({
    required this.basicAuthRepository,
  });

  /// Used for basic authentication related operations
  final BasicAuthenticationRepository basicAuthRepository;

  /// {@template check_token_validity}
  Either<Failure, String> call(String encryptedToken) {
    return _decryptToken(encryptedToken);
  }

  Either<Failure, String> _decryptToken(String encryptedToken) {
    final Either<Failure, String> decryptedTokenEither =
        basicAuthRepository.decryptToken(encryptedToken);

    return decryptedTokenEither.fold(
      Left.new,
      _checkTokenValidity,
    );
  }

  Either<Failure, String> _checkTokenValidity(String decryptedToken) {
    final Either<Failure, String> validatedTokenEither =
        basicAuthRepository.isTokenValid(decryptedToken);

    return validatedTokenEither.fold(Left.new, (String userId) {
      return Right(userId);
    });
  }
}
