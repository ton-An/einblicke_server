import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_remote_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:sqlite3/sqlite3.dart';

/// {@macro user_auth_repository}
class UserAuthenticationRepositoryImpl<U extends User>
    extends UserAuthenticationRepository<U> {
  /// {@macro user_auth_repository}
  const UserAuthenticationRepositoryImpl({
    required this.userAuthLocalDataSource,
  });

  /// Local data source for user authentication
  final UserAuthenticationLocalDataSource<U> userAuthLocalDataSource;

  @override
  Future<Either<Failure, U>> createUser(
    String userId,
    String username,
    String passwordHash,
  ) async {
    try {
      final U user = await userAuthLocalDataSource.createUser(
        userId: userId,
        username: username,
        passwordHash: passwordHash,
      );

      return Right(user);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> doesUserWithIdExist(String userId) async {
    try {
      final bool doesUserWithIdExist =
          await userAuthLocalDataSource.doesUserWithIdExist(userId);

      return Right(doesUserWithIdExist);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, U>> getUser(
    String username,
    String passwordHash,
  ) async {
    try {
      final U user = await userAuthLocalDataSource.getUser(
        username: username,
        passwordHash: passwordHash,
      );

      return Right(user);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, U>> getUserFromId(String userId) async {
    try {
      final U user = await userAuthLocalDataSource.getUserFromId(userId);

      return Right(user);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isRefreshTokenInUserDb(
    String userId,
    String refreshToken,
  ) async {
    try {
      final bool isRefreshTokenInUserDb =
          await userAuthLocalDataSource.isRefreshTokenInUserDb(
        refreshToken: refreshToken,
        userId: userId,
      );

      return Right(isRefreshTokenInUserDb);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUserIdTaken(String userId) async {
    try {
      final bool isUserIdTaken =
          await userAuthLocalDataSource.isUserIdTaken(userId);

      return Right(isUserIdTaken);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameTaken(String username) async {
    try {
      final bool isUsernameTaken =
          await userAuthLocalDataSource.isUsernameTaken(username);

      return Right(isUsernameTaken);
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> removeAllRefreshTokensFromDb(
      String userId) async {
    try {
      await userAuthLocalDataSource.removeAllRefreshTokensFromDb(
        userId,
      );

      return const Right(None());
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> removeRefreshTokenFromDb(
    String userId,
    String refreshToken,
  ) async {
    try {
      await userAuthLocalDataSource.removeRefreshTokenFromDb(
        userId: userId,
        refreshToken: refreshToken,
      );

      return const Right(None());
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveRefreshTokenToDb(
    String userId,
    String refreshToken,
  ) async {
    try {
      await userAuthLocalDataSource.saveRefreshTokenToDb(
        userId: userId,
        refreshToken: refreshToken,
      );

      return const Right(None());
    } on SqliteException {
      return const Left(DatabaseWriteFailure());
    }
  }
}