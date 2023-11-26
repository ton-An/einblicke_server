import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template user_not_found_failure}
/// Failure for when the user is not found, meaning the user may not exist or
/// the provided credentials might be incorrect.
/// {@endtemplate}
class UserNotFoundFailure extends Failure {
  /// {@macro user_not_found_failure}
  const UserNotFoundFailure()
      : super(
          name: "User Not Found Failure",
          message:
              "The user was not found. Please check your credentials and try again.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "user_not_found",
        );
}
