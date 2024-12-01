import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/frame_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template frame_auth_repository_impl}
/// __Frame Authentication Repository Implementation__ handles the
/// authentication of [Frame] users.
/// {@endtemplate}
class FrameAuthenticationRepositoryImpl extends FrameAuthenticationRepository
    with UserAuthenticationRepositoryImpl {
  /// {@macro frame_auth_repository_impl}
  FrameAuthenticationRepositoryImpl({required this.userAuthLocalDataSource});

  /// Used to create the database record of the frame
  @override
  final FrameAuthenticationLocalDataSource userAuthLocalDataSource;

  @override
  Future<Either<Failure, Frame>> createFrame({
    required String userId,
    required String ownerId,
    required String name,
  }) async {
    try {
      final Frame frame = await userAuthLocalDataSource.createFrame(
        userId: userId,
        ownerId: ownerId,
        name: name,
      );

      return Right(frame);
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, Frame>> getUserFromId({required String userId}) async {
    try {
      final Frame? user = await userAuthLocalDataSource.getUserFromId(
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
}
