import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/image_save_failure.dart';

/// {@template image_exchange_repository}
/// Repository for exchanging images between a curator and a frame
/// {@endtemplate}
abstract class ImageExchangeRepository {
  /// {@macro image_exchange_repository}
  const ImageExchangeRepository();

  /// Pairs a curator and frame
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  });

  /// Checks if a curator and frame are paired
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  ///
  /// Returns:
  /// - [bool] indicating if the given curator and frame are paired
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> areCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  });

  /// Saves an image to the database
  ///
  /// Parameters:
  /// - [String] imageId
  /// - [List<int>] imageBytes
  ///
  /// Failures:
  /// - [ImageSaveFailure]
  Future<Either<Failure, None>> saveImage({
    required String imageId,
    required List<int> imageBytes,
  });

  /// Saves the metadata of an image to the database
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  /// - [String] imageId
  /// - [DateTime] createdAt
  ///
  /// Failures:
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
    required DateTime createdAt,
  });

  /// Generates an id for an image
  String generateImageId();
}