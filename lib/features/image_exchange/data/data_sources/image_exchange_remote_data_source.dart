import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:mysql1/mysql1.dart';

/// {@template image_exchange_remote_data_source}
/// Remote data source for handling the exchange of images between
/// a curator and a frame
/// {@endtemplate}
abstract class ImageExchangeRemoteDataSource {
  /// {@macro image_exchange_remote_data_source}
  const ImageExchangeRemoteDataSource();

  /// Adds an entry to the curator_x_frame table
  /// for the given curator and frame
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  ///
  /// Throws:
  /// - [MySqlException]
  Future<void> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  });

  /// Checks there is an entry in the curator_x_frame table
  /// for the given curator and frame
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  ///
  /// Returns:
  /// - [bool] indicating if the entry exists
  ///
  /// Throws:
  /// - [MySqlException]
  Future<bool> areCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  });

  /// Saves an image to the cloud storage
  ///
  /// Parameters:
  /// - [String] imageId
  /// - [List<int>] imageBytes
  ///
  /// Throws:
  /// ... TBD ...
  Future<void> saveImage({
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
  /// Throws:
  /// - [MySqlException]
  Future<void> saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
    required DateTime createdAt,
  });

  /// Gets the latest image id from the database
  ///
  /// Parameters:
  /// - [String] frameId
  ///
  /// Throws:
  /// - [MySqlException]
  Future<String> getLatestImageIdFromDb({
    required String frameId,
  });

  /// Gets an image from the cloud storage
  ///
  /// Parameters:
  /// - [String] imageId
  ///
  /// Throws:
  /// ... TBD ...
  Future<Image> getImageById({
    required String imageId,
  });
}
