import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';

/// {@template curator_not_found_failure}
/// Failure for when a [Curator] could not be found.
/// {@endtemplate}
class CuratorNotFoundFailure extends Failure {
  /// {@macro curator_not_found_failure}
  const CuratorNotFoundFailure()
      : super(
          name: "Curator Not Found Failure",
          message: "The requested curator could not be found.",
          categoryCode: FailureStrings.authenticationCategoryCode,
          code: "curator_not_found_failure",
        );
}
