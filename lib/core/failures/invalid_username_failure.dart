import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template invalid_username_failure}
/// Failure for when the given username is invalid
/// {@endtemplate}
class InvalidUsernameFailure extends Failure {
  /// {@macro invalid_username_failure}
  const InvalidUsernameFailure()
      : super(
          name: "Invalid Username",
          message: "A valid username must be between 3 and 20 characters, and "
              "can only contain letters, numbers, underscores, and hyphens.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "invalid_username",
        );
}
