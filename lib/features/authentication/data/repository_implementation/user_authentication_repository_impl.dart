import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template user_auth_repository}
/// __User Authentication Repository Implementation__ is the concrete
/// implementation of the [UserAuthenticationRepository] contract and a
/// wrapper for [U] user related authentication repository operations.
/// {@endtemplate}
mixin UserAuthenticationRepositoryImpl<U extends User>
    on UserAuthenticationRepository<U> {
  /// Local data source for user authentication
  abstract final UserAuthenticationLocalDataSource<U> userAuthLocalDataSource;

  @override
  Future<Either<Failure, bool>> isRefreshTokenInUserDb({
    required String userId,
    required String refreshToken,
  }) async {
    try {
      final bool isRefreshTokenInUserDb =
          await userAuthLocalDataSource.isRefreshTokenInUserDb(
        refreshToken: refreshToken,
        userId: userId,
      );

      return Right(isRefreshTokenInUserDb);
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUserIdTaken({required String userId}) async {
    try {
      final bool isUserIdTaken =
          await userAuthLocalDataSource.isUserIdTaken(userId: userId);

      return Right(isUserIdTaken);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, None>> removeAllRefreshTokensFromDb({
    required String userId,
  }) async {
    try {
      await userAuthLocalDataSource.removeAllRefreshTokensFromDb(
        userId: userId,
      );

      return const Right(None());
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> removeRefreshTokenFromDb({
    required String userId,
    required String refreshToken,
  }) async {
    try {
      await userAuthLocalDataSource.removeRefreshTokenFromDb(
        userId: userId,
        refreshToken: refreshToken,
      );

      return const Right(None());
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveRefreshTokenToDb({
    required String userId,
    required String refreshToken,
  }) async {
    try {
      await userAuthLocalDataSource.saveRefreshTokenToDb(
        userId: userId,
        refreshToken: refreshToken,
      );

      return const Right(None());
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }
}
