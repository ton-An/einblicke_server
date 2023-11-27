import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template expired_token_failure}
/// Failure for when the given token has expired
/// {@endtemplate}
class ExpiredTokenFailure extends Failure {
  /// {@macro expired_token_failure}
  const ExpiredTokenFailure()
      : super(
          name: "Expired Token Failure",
          message:
              "The given authentication token has expired. Please sign in again.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "expired_token",
        );
}
