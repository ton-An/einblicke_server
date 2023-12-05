import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template cloud_storage_unavailable_failure}
/// Failure for when cloud storage is unavailable
/// {@endtemplate}
class CloudStorageUnavailableFailure extends Failure {
  /// {@macro cloud_storage_unavailable_failure}
  const CloudStorageUnavailableFailure()
      : super(
          name: "Cloud Storage Unavailable Failure",
          message: "Cloud storage is currently unavailable",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "cloud_storage_unavailable_failure",
        );
}
