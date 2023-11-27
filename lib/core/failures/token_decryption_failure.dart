import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template token_decryption_failure}
/// Failure for when an error occurs while decrypting a given token
/// {@endtemplate}
class TokenDecryptionFailure extends Failure {
  /// {@macro token_decryption_failure}
  const TokenDecryptionFailure()
      : super(
          name: "Token Decryption Failure",
          message: "An error occurred while decrypting the given token.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "token_decryption",
        );
}
