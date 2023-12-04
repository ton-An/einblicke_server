import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template already_paired_failure}
/// Failure for when a curator and frame are already paired
/// {@endtemplate}
class AlreadyPairedFailure extends Failure {
  /// {@macro already_paired_failure}
  const AlreadyPairedFailure()
      : super(
          name: "Already Paired Failure",
          message: "The curator and frame are already paired",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "already_paired",
        );
}
