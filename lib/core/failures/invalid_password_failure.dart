import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template invalid_password_failure}
/// Failure thrown when the given password is invalid
/// {@endtemplate}
class InvalidPasswordFailure extends Failure {
  /// {@macro invalid_password_failure}
  const InvalidPasswordFailure()
      : super(
          name: "Invalid Password",
          message: "A valid password must be between 8 and 20 characters, and "
              "must contain at least one uppercase letter, one lowercase letter, "
              r"one number, and one special character (!@#$%^&*()-_+).",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "invalid_password",
        );
}
