import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure_strings.dart';

/// {@template database_read_failure}
/// Failure for when an error occurs while reading from the database
/// {@endtemplate}
class DatabaseReadFailure extends Failure {
  /// {@macro database_read_failure}
  const DatabaseReadFailure()
      : super(
          name: "Database Read Failure",
          message: "An error occurred while reading from the database.",
          categoryCode: FailureStrings.databaseCategoryCode,
          code: "database_read_failure",
        );
}
