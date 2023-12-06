import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template invalid_user_type_failure}
/// Failure for when the given user type is invalid
/// {@endtemplate}
class InvalidUserTypeFailure extends Failure {
  /// {@macro invalid_user_type_failure}
  const InvalidUserTypeFailure()
      : super(
          name: "Invalid User Type Failure",
          message: "The given user type is invalid",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "invalid_user_type_failure",
        );
}
