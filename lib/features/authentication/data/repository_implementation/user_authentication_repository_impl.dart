import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/user.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> doesUserWithIdExist(String userId) async {
    try {
      final bool doesUserWithIdExist =
          await userAuthLocalDataSource.doesUserWithIdExist(userId);

      return Right(doesUserWithIdExist);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, U>> getUser(
    String username,
    String passwordHash,
  ) async {
    try {
      final U? user = await userAuthLocalDataSource.getUser(
        username: username,
        passwordHash: passwordHash,
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
  Future<Either<Failure, U>> getUserFromId(String userId) async {
    try {
      final U? user = await userAuthLocalDataSource.getUserFromId(userId);

      if (user == null) {
        return const Left(UserNotFoundFailure());
      }

      return Right(user);
    } on DatabaseException {
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
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUserIdTaken(String userId) async {
    try {
      final bool isUserIdTaken =
          await userAuthLocalDataSource.isUserIdTaken(userId);

      return Right(isUserIdTaken);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameTaken(String username) async {
    try {
      final bool isUsernameTaken =
          await userAuthLocalDataSource.isUsernameTaken(username);

      return Right(isUsernameTaken);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
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
    } on DatabaseException {
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
    } on DatabaseException {
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
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }
}

/// {@macro user_auth_repository}
typedef CuratorAuthRepositoryImpl = UserAuthenticationRepositoryImpl<Curator>;

/// {@macro user_auth_repository}
typedef FrameAuthRepositoryImpl
    = UserAuthenticationRepositoryImpl<PictureFrame>;
