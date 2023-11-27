import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template invalid_token_failure}
/// Failure for when the given token is invalid
/// {@endtemplate}
class InvalidTokenFailure extends Failure {
  /// {@macro invalid_token_failure}
  const InvalidTokenFailure()
      : super(
          name: "Invalid Token Failure",
          message:
              "The given authentication token is invalid. Please contact the server owner.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "invalid_token",
        );
}
