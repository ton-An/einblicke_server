import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/user.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/user_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// __Curator Authentication Repository Implementation__ is the concrete
/// implementation of the [UserAuthenticationRepository] contract and handles
/// the [Curator] related authentication repository operations.
typedef CuratorAuthRepositoryImpl = UserAuthenticationRepositoryImpl<Curator>;

/// __Frame Authentication Repository Implementation__ is the concrete
/// implementation of the [UserAuthenticationRepository] contract and handles
/// the [Frame] related authentication repository operations.
typedef FrameAuthRepositoryImpl = UserAuthenticationRepositoryImpl<Frame>;

/// {@template user_auth_repository}
/// __User Authentication Repository Implementation__ is the concrete
/// implementation of the [UserAuthenticationRepository] contract and a
/// wrapper for [U] user related authentication repository operations.
/// {@endtemplate}
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
