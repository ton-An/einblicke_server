import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/data/data_sources/user_authentication_local_data_source.dart';
import 'package:einblicke_server/features/authentication/data/repository_implementation/user_authentication_repository_impl.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/repositories/curator_authentication_repository.dart';
import 'package:einblicke_shared/src/core/failures/failure.dart';

class CuratorAuthenticationRepositoryImpl
    extends CuratorAuthenticationRepository
    with UserAuthenticationRepositoryImpl {
  CuratorAuthenticationRepositoryImpl({required this.userAuthLocalDataSource});

  final UserAuthenticationLocalDataSource<Curator> userAuthLocalDataSource;

  @override
  Future<Either<Failure, Curator>> createCurator(
      String userId, String username, String passwordHash) {
    // TODO: implement createCurator
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Curator>> getCuratorFromCredentials(
      String username, String passwordHash) {
    // TODO: implement getCuratorFromCredentials
    throw UnimplementedError();
  }
}
