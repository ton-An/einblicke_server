import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template image_exchange_repository_impl}
/// Repository for exchanging images between a curator and a frame
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
    } on IOException catch (_) {
      print(_);
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

  // ToDo: test
  @override
  Future<Either<Failure, bool>> doesImageBelongToFrame(
      {required String frameId, required String imageId}) async {
    try {
      final bool doesImageBelongToFrame =
          await localDataSource.doesImageBelongToFrame(
        frameId: frameId,
        imageId: imageId,
      );

      return Right(doesImageBelongToFrame);
    } on DatabaseException {
      return const Left(DatabaseReadFailure());
    }
  }
}
