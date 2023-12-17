import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template storage_write_failure}
/// Failure for when writing to cloud storage fails
/// {@endtemplate}
class StorageWriteFailure extends Failure {
  /// {@macro storage_write_failure}
  const StorageWriteFailure()
      : super(
          name: "Cloud Storage Write Failure",
          message: "Failed to write to cloud storage",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "storage_write_failure",
        );
}
