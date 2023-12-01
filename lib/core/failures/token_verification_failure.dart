import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template token_verification_failure}
/// Failure for when an authentication token could not be verified
/// {@endtemplate}
class TokenVerificationFailure extends Failure {
  /// {@macro token_verification_failure}
  const TokenVerificationFailure()
      : super(
          name: "Token Verification Failure",
          message:
              "An authentication token could not be verified due to an unknown error.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "token_verification_failure",
        );
}
