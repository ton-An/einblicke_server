import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/curator_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template curator_auth_repository_impl}
/// __Curator Authentication Repository Implementation__ handles the
/// authentication of [Curator] users.
/// {@endtemplate}
class CuratorAuthenticationRepositoryImpl
    extends CuratorAuthenticationRepository
    with UserAuthenticationRepositoryImpl {
  /// {@macro curator_auth_repository_impl}
  CuratorAuthenticationRepositoryImpl({required this.userAuthLocalDataSource});

  /// Used to create the database record of the frame and
  /// to get the frame from the database
  @override
  final CuratorAuthenticationLocalDataSource userAuthLocalDataSource;

  @override
  Future<Either<Failure, Curator>> createCurator({
    required String userId,
    required String username,
    required String passwordHash,
  }) async {
    try {
      final Curator curator = await userAuthLocalDataSource.createCurator(
        userId: userId,
        username: username,
        passwordHash: passwordHash,
      );

      return Right(curator);
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, Curator>> getCuratorFromCredentials({
    required String username,
    required String passwordHash,
  }) async {
    try {
      final Curator? curator =
          await userAuthLocalDataSource.getCuratorFromCredentials(
        username: username,
        passwordHash: passwordHash,
      );

      if (curator == null) {
        return const Left(UserNotFoundFailure());
      }

      return Right(curator);
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, Curator>> getUserFromId({
    required String userId,
  }) async {
    try {
      final Curator? user = await userAuthLocalDataSource.getUserFromId(
        userId: userId,
      );

      if (user == null) {
        return const Left(UserNotFoundFailure());
      }

      return Right(user);
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameTaken({
    required String username,
  }) async {
    try {
      final bool isUsernameTaken =
          await userAuthLocalDataSource.isUsernameTaken(username: username);

      return Right(isUsernameTaken);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }
}
