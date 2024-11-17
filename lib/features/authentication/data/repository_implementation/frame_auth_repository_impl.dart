import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/frame_authentication_repository.dart';
import 'package:einblicke_shared/src/core/failures/failure.dart';

/// {@template frame_auth_repository_impl}
/// __Frame Authentication Repository Implementation__ handles the
/// authentication of [Frame] users.
/// {@endtemplate}
class FrameAuthenticationRepositoryImpl extends FrameAuthenticationRepository
    with UserAuthenticationRepositoryImpl {
  /// {@macro frame_auth_repository_impl}
  FrameAuthenticationRepositoryImpl({required this.userAuthLocalDataSource});

  final FrameAuthLocalDataSource userAuthLocalDataSource;

  @override
  Future<Either<Failure, Frame>> createFrame(String userId, String curatorId) {
    // TODO: implement createFrame
    throw UnimplementedError();
  }
}
