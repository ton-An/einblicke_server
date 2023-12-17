import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template storage_read_failure}
/// Failure for when reading from cloud storage fails
/// {@endtemplate}
class StorageReadFailure extends Failure {
  /// {@macro storage_read_failure}
  const StorageReadFailure()
      : super(
          name: "Cloud Storage Read Failure",
          message: "Failed to read from cloud storage",
          categoryCode: FailureStrings.imageExchangeCategoryCode,
          code: "storage_read_failure",
        );
}
