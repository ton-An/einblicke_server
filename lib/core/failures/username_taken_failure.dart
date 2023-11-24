import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template username_taken_failure}
/// Failure for when the given username is already taken
/// {@endtemplate}
class UsernameTakenFailure extends Failure {
  /// {@macro username_taken_failure}
  const UsernameTakenFailure()
      : super(
          name: "Username Taken",
          message: "The given username is already taken.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "username_taken",
        );
}
