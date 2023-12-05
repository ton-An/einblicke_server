import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template cloud_storage_read_failure}
/// Failure for when reading from cloud storage fails
/// {@endtemplate}
class CloudStorageReadFailure extends Failure {
  /// {@macro cloud_storage_read_failure}
  const CloudStorageReadFailure()
      : super(
          name: "Cloud Storage Read Failure",
          message: "Failed to read from cloud storage",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "cloud_storage_read_failure",
        );
}
