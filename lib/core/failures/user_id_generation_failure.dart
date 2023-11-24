import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template user_id_generation_failure}
/// Failure for when generating a user ID fails
/// {@endtemplate}
class UserIdGenerationFailure extends Failure {
  /// {@macro user_id_generation_failure}
  const UserIdGenerationFailure()
      : super(
          name: "User ID Generation Failure",
          message:
              "An error occurred while generating the user ID. Please try again.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "user_id_generation_failure",
        );
}
