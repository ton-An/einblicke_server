/// {@template failure}
/// Base class for all [Failure]s
///
/// Failures are basically a translation wrapper for errors to make them usable
/// in the business logic. The business logic uses exclusively [Failure]s to
/// handle errors.
///
/// This means, any errors which were not caught and translated to [Failure]s
/// before entering the business logic, will not be handled.
/// {@endtemplate}
abstract class Failure {
  /// {@macro failure}
  const Failure({
    required this.name,
    required this.message,
    required this.categoryCode,
    required this.code,
  });

  /// Human readable [name] of the error for display in the UI
  final String name;

  /// Human readable [message] of the error for display in the UI
  final String message;

  /// Identifies the error category
  final String categoryCode;

  /// Identifies the specific error using a code.
  final String code;
}
