import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template storage_unavailable_failure}
/// Failure for when cloud storage is unavailable
/// {@endtemplate}
class StorageUnavailableFailure extends Failure {
  /// {@macro storage_unavailable_failure}
  const StorageUnavailableFailure()
      : super(
          name: "Cloud Storage Unavailable Failure",
          message: "Cloud storage is currently unavailable",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "storage_unavailable_failure",
        );
}
