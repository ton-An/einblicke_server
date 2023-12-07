import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/data_sources/crypto_local_data_source.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_remote_data_source.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';

/// {@template image_exchange_repository_impl}
/// Repository for exchanging images between a curator and a frame
/// {@endtemplate}
class ImageExchangeRepositoryImpl extends ImageExchangeRepository {
  /// {@macro image_exchange_repository_impl}
  const ImageExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.cryptoLocalDataSource,
  });

  final ImageExchangeRemoteDataSource remoteDataSource;
  final CryptoLocalDataSource cryptoLocalDataSource;

  @override
  Future<Either<Failure, bool>> areCuratorXFramePaired(
      {required String curatorId, required String frameId}) {
    // TODO: implement areCuratorXFramePaired
    throw UnimplementedError();
  }

  @override
  String generateImageId() {
    // TODO: implement generateImageId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Image>> getImageById({required String imageId}) {
    // TODO: implement getImageById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getLatestImageIdFromDb(
      {required String frameId}) {
    // TODO: implement getLatestImageIdFromDb
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> pairCuratorXFrame(
      {required String curatorId, required String frameId}) {
    // TODO: implement pairCuratorXFrame
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveImage(
      {required String imageId, required List<int> imageBytes}) {
    // TODO: implement saveImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveImageToDb(
      {required String curatorId,
      required String frameId,
      required String imageId,
      required DateTime createdAt}) {
    // TODO: implement saveImageToDb
    throw UnimplementedError();
  }
}
