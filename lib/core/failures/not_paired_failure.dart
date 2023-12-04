import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template not_paired_failure}
/// Failure for when the curator and frame are not paired or do not exist
/// {@endtemplate}
class NotPairedFailure extends Failure {
  /// {@macro not_paired_failure}
  const NotPairedFailure()
      : super(
          name: "Not Paired Failure",
          message: "The curator and frame are not paired or do not exist",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "not_paired_failure",
        );
}
