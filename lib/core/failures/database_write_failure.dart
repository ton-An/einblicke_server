import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template database_write_failure}
/// Failure for when an error occurs while writing to the database
/// {@endtemplate}
class DatabaseWriteFailure extends Failure {
  /// {@macro database_write_failure}
  const DatabaseWriteFailure()
      : super(
          name: "Database Write Failure",
          message: "An error occurred while writing to the database.",
          categoryCode: FailureStrings.databaseCategoryCode,
          code: "database_write_failure",
        );
}
