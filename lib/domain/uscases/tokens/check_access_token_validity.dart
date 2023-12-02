import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/expired_token_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/invalid_token_failure.dart';
import 'package:dispatch_pi_dart/domain/models/token_payload.dart';
import 'package:dispatch_pi_dart/domain/repositories/basic_authentication_repository.dart';
import 'package:dispatch_pi_dart/domain/uscases/tokens/is_token_expired.dart';

/// {@template check_access_token_validity}
/// Checks if an access token is valid
///
/// Parameters:
/// - [String] accessToken
///
/// Returns:
/// - [String userId] if the token is valid
///
/// Failures:
/// - [ExpiredTokenFailure]
/// - [InvalidTokenFailure]
/// - [DatabaseReadFailure]
/// {@endtemplate}
class CheckAccessTokenValidity {
  /// {@macro check_access_token_validity}
  const CheckAccessTokenValidity({
    required this.basicAuthRepository,
    required this.isTokenExpiredUseCase,
  });

  /// Used for checking the signature of the token
  final BasicAuthenticationRepository basicAuthRepository;

  /// Checks if a token is expired
  final IsTokenExpired isTokenExpiredUseCase;

  /// {@macro check_access_token_validity}
  Future<Either<Failure, String>> call({required String accessToken}) {
    return _checkTokenSignatureValidity(
      accessToken: accessToken,
    );
  }

  Future<Either<Failure, String>> _checkTokenSignatureValidity(
      {required String accessToken}) async {
    final Either<Failure, TokenPayload> signatureCheckEither =
        basicAuthRepository.checkTokenSignatureValidity(
      accessToken,
    );

    return signatureCheckEither.fold(
      Left.new,
      (tokenPayload) => _checkTokenExpiration(
        tokenPayload: tokenPayload,
      ),
    );
  }

  Future<Either<Failure, String>> _checkTokenExpiration({
    required TokenPayload tokenPayload,
  }) async {
    final bool isTokenExpired = isTokenExpiredUseCase(
      expiresAt: tokenPayload.expiresAt,
    );

    if (isTokenExpired) {
      return const Left(
        ExpiredTokenFailure(),
      );
    }

    return Right(
      tokenPayload.userId,
    );
  }
}
