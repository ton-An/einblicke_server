import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/data_sources/crypto_local_data_source.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_remote_data_source.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:mysql1/mysql1.dart';

/// {@template image_exchange_repository_impl}
/// Repository for exchanging images between a curator and a frame
/// {@endtemplate}
class ImageExchangeRepositoryImpl extends ImageExchangeRepository {
  /// {@macro image_exchange_repository_impl}
  const ImageExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.cryptoLocalDataSource,
  });

  /// {@macro image_exchange_remote_data_source}
  final ImageExchangeRemoteDataSource remoteDataSource;

  /// {@macro crypto_local_data_source}
  final CryptoLocalDataSource cryptoLocalDataSource;

  @override
  Future<Either<Failure, bool>> areCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  }) async {
    try {
      final areCuratorXFramePaired =
          await remoteDataSource.areCuratorXFramePaired(
        curatorId: curatorId,
        frameId: frameId,
      );

      return Right(areCuratorXFramePaired);
    } on MySqlException catch (_) {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  String generateImageId() {
    return cryptoLocalDataSource.generateUuid();
  }

  @override
  Future<Either<Failure, Image>> getImageById({
    required String imageId,
  }) {
    // TODO: implement getImageById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getLatestImageIdFromDb(
      {required String frameId}) async {
    try {
      final latestImageId = await remoteDataSource.getLatestImageIdFromDb(
        frameId: frameId,
      );

      return Right(latestImageId);
    } on MySqlException catch (_) {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, None>> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  }) async {
    try {
      await remoteDataSource.pairCuratorXFrame(
        curatorId: curatorId,
        frameId: frameId,
      );

      return const Right(None());
    } on MySqlException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveImage({
    required String imageId,
    required List<int> imageBytes,
  }) {
    // TODO: implement saveImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, None>> saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
    required DateTime createdAt,
  }) async {
    try {
      await remoteDataSource.saveImageToDb(
        curatorId: curatorId,
        frameId: frameId,
        imageId: imageId,
        createdAt: createdAt,
      );

      return const Right(None());
    } on MySqlException {
      return const Left(DatabaseWriteFailure());
    }
  }
}
