import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  To-Do:
    - [ ] Test isImageAssociatedWithFrame()
*/

/// {@template image_exchange_repository_impl}
/// __Image Exchange Repository Impl__ is a concrete implementation of the
/// [ImageExchangeRepository] contract and handles the image exchange related
/// repository operations.
/// {@endtemplate}
class ImageExchangeRepositoryImpl extends ImageExchangeRepository {
  /// {@macro image_exchange_repository_impl}
  const ImageExchangeRepositoryImpl({
    required this.localDataSource,
  });

  /// {@macro image_exchange_local_data_source}
  final ImageExchangeLocalDataSource localDataSource;

  @override
  Future<Either<Failure, bool>> areCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  }) async {
    try {
      final bool areCuratorXFramePaired =
          await localDataSource.areCuratorXFramePaired(
        curatorId: curatorId,
        frameId: frameId,
      );

      return Right(areCuratorXFramePaired);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, Image>> getImageById({
    required String imageId,
  }) async {
    try {
      final Image image = await localDataSource.getImageById(
        imageId: imageId,
      );

      return Right(image);
    } on IOException {
      return const Left(StorageReadFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getLatestImageIdFromDb({
    required String frameId,
  }) async {
    try {
      final String? latestImageId =
          await localDataSource.getLatestImageIdFromDb(
        frameId: frameId,
      );

      if (latestImageId == null) {
        return const Left(DatabaseReadFailure());
      }

      return Right(latestImageId);
    } on DatabaseException catch (_) {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, None>> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  }) async {
    try {
      await localDataSource.pairCuratorXFrame(
        curatorId: curatorId,
        frameId: frameId,
      );

      return const Right(None());
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveImage({
    required String imageId,
    required List<int> imageBytes,
  }) async {
    try {
      await localDataSource.saveImage(
        imageId: imageId,
        imageBytes: imageBytes,
      );

      return const Right(None());
    } on IOException {
      return const Left(StorageWriteFailure());
    }
  }

  @override
  Future<Either<Failure, None>> saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
    required DateTime createdAt,
  }) async {
    try {
      await localDataSource.saveImageToDb(
        curatorId: curatorId,
        frameId: frameId,
        imageId: imageId,
        createdAt: createdAt,
      );

      return const Right(None());
    } on DatabaseException {
      return const Left(DatabaseWriteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isImageAssociatedWithFrame(
      {required String frameId, required String imageId}) async {
    try {
      final bool isImageAssociatedWithFrame =
          await localDataSource.isImageAssociatedWithFrame(
        frameId: frameId,
        imageId: imageId,
      );

      return Right(isImageAssociatedWithFrame);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPairedFramesOfCurator(
      {required String curatorId}) {
    // TODO: implement getPairedFramesOfCurator
    throw UnimplementedError();
  }
}
