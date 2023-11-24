import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/domain/models/curator.dart';

/// {@template authentication_repository}
/// Repository for authentication related operations
/// {@endtemplate}
abstract class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository();

  /// Checks if the given curator username is taken
  ///
  /// Parameters:
  /// - [String] username
  ///
  /// Returns:
  /// - a [bool] indicating if the username is taken
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> isCuratorUsernameTaken(String username);

  /// Generates a hash of the given password
  ///
  /// Parameters:
  /// - [String] password
  ///
  /// Returns:
  /// - a [String] containing the hash of the given password
  String generatePasswordHash(String password);

  /// Creates a record of a curator with the given username and password hash
  ///
  /// Parameters:
  /// - [String] username
  /// - [String] passwordHash
  ///
  /// Returns:
  /// - a [Curator] with the given username and password hash
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, Curator>> createCurator(
    String username,
    String passwordHash,
  );
}
