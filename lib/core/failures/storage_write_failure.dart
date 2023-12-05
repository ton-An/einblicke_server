import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template cloud_storage_write_failure}
/// Failure for when writing to cloud storage fails
/// {@endtemplate}
class CloudStorageWriteFailure extends Failure {
  /// {@macro cloud_storage_write_failure}
  const CloudStorageWriteFailure()
      : super(
          name: "Cloud Storage Write Failure",
          message: "Failed to write to cloud storage",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "cloud_storage_write_failure",
        );
}
