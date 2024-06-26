import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Evaluate if bools start with 'are' should be changed to 'is'
*/

/// {@template image_exchange_repository}
/// __Image Exchange Repository__ is a contract for the image exchange related
/// repository operations.
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

  /// Gets the paired frames of a curator
  ///
  /// Parameters:
  /// - [String] curatorId
  ///
  /// Returns:
  /// - [List<String>] frameIds
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, List<String>>> getPairedFrameIdsOfCurator({
    required String curatorId,
  });

  /// Saves an image to storage
  ///
  /// Parameters:
  /// - [String] imageId
  /// - [List<int>] imageBytes
  ///
  /// Failures:
  /// - [StorageWriteFailure]
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

  /// Gets the latest image id from the database
  ///
  /// Returns:
  /// - [List<int>] imageBytes
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  /// - [NoImagesFoundFailure]
  Future<Either<Failure, String>> getLatestImageIdFromDb({
    required String frameId,
  });

  /// Gets an image from storage
  ///
  /// Parameters:
  /// - [String] imageId
  ///
  /// Returns:
  /// - [List<int>] imageBytes
  ///
  /// Failures:
  /// - [StorageReadFailure]
  Future<Either<Failure, Image>> getImageById({
    required String imageId,
  });

  /// Checks if an image belongs to a frame
  ///
  /// Parameters:
  /// - [String] frameId
  /// - [String] imageId
  ///
  /// Returns:
  /// - [bool] indicating if the image belongs to the frame
  ///
  /// Failures:
  /// - [DatabaseReadFailure]
  Future<Either<Failure, bool>> isImageAssociatedWithFrame({
    required String frameId,
    required String imageId,
  });
}
