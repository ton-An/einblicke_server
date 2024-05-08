import 'dart:io';
import 'dart:typed_data';

import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*
  To-Do:
    - [ ] Add missing tests
    - [ ] Need to handle when nothing is found in the database e.g. getLatestImageIdFromDb
*/

/// {@template image_exchange_local_data_source}
/// __Image Exchange Local Data Source__ is a contract for the image exchange
/// related local data source operations.
/// {@endtemplate}
abstract class ImageExchangeLocalDataSource {
  /// {@macro image_exchange_local_data_source}
  const ImageExchangeLocalDataSource();

  /// Adds an entry to the curator_x_frame table
  /// for the given curator and frame
  ///
  /// Parameters:
  /// - [String] curatorId
  /// - [String] frameId
  ///
  /// Throws:
  /// - [DatabaseException]
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
  /// - [DatabaseException]
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
  /// [IOException]
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
  /// - [DatabaseException]
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
  /// -
  Future<String?> getLatestImageIdFromDb({
    required String frameId,
  });

  /// Gets an image from the cloud storage
  ///
  /// Parameters:
  /// - [String] imageId
  ///
  /// Throws:
  /// [IOException]
  Future<Image> getImageById({
    required String imageId,
  });

  /// Checks if an image belongs to a frame
  ///
  /// Parameters:
  /// - [String] frameId
  /// - [String] imageId
  ///
  /// Throws:
  /// - [DatabaseException]
  Future<bool> isImageAssociatedWithFrame({
    required String frameId,
    required String imageId,
  });

  /// Gets the paired frames ids of a curator
  ///
  /// Parameters:
  /// - [String] curatorId
  ///
  /// Returns:
  /// - [List<String>] of frame ids
  ///
  /// Throws:
  /// - [DatabaseException]
  Future<List<String>> getPairedFrameIdsOfCurator({
    required String curatorId,
  });
}

/// {@template image_exchange_local_data_source_impl}
/// __Image Exchange Local Data Source Implementation__ is the concrete
/// implementation of the [ImageExchangeLocalDataSource] contract and handles
/// the image exchange related local data source operations.
/// {@endtemplate}
class ImageExchangeLocalDataSourceImpl extends ImageExchangeLocalDataSource {
  /// {@macro image_exchange_local_data_source_impl}
  const ImageExchangeLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.imageDirectoryPath,
  });

  /// The database connection
  final Database sqliteDatabase;

  /// The directory path where the images are stored
  final String imageDirectoryPath;

  @override
  Future<bool> areCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  }) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM curator_x_frame "
      "WHERE curator_id = ? AND frame_id = ?)",
      [curatorId, frameId],
    );

    final bool isPaired = queryResult.first.containsValue(1);

    return isPaired;
  }

  @override
  Future<Image> getImageById({required String imageId}) async {
    final File imageFile = File(
      "$imageDirectoryPath/$imageId.jpg",
    );

    final Uint8List imageBytes = await imageFile.readAsBytes();

    final Image image = Image(
      imageId: imageId,
      imageBytes: imageBytes,
    );

    return Future.value(image);
  }

  @override
  Future<String?> getLatestImageIdFromDb({required String frameId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT image_id FROM images "
      "WHERE frame_id = ? "
      "ORDER BY created_at DESC "
      "LIMIT 1",
      [frameId],
    );

    final String? imageId = queryResult.first["image_id"] as String?;

    return imageId;
  }

  @override
  Future<void> pairCuratorXFrame({
    required String curatorId,
    required String frameId,
  }) async {
    await sqliteDatabase.execute(
      "INSERT INTO curator_x_frame (curator_id, frame_id) "
      "VALUES (?, ?)",
      [curatorId, frameId],
    );
  }

  @override
  Future<void> saveImage({
    required String imageId,
    required List<int> imageBytes,
  }) async {
    final File imageFile = File(
      "$imageDirectoryPath/$imageId.jpg",
    );

    await imageFile.create(recursive: true);

    await imageFile.writeAsBytes(imageBytes, flush: true);
  }

  @override
  Future<void> saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
    required DateTime createdAt,
  }) async {
    await sqliteDatabase.execute(
      "INSERT INTO images (curator_id, frame_id, image_id, created_at) "
      "VALUES (?, ?, ?, ?)",
      [curatorId, frameId, imageId, createdAt.toIso8601String()],
    );
  }

  @override
  Future<bool> isImageAssociatedWithFrame(
      {required String frameId, required String imageId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM images "
      "WHERE frame_id = ? AND image_id = ?)",
      [frameId, imageId],
    );

    final bool isImageAssociatedWithFrame = queryResult.first.containsValue(1);

    return isImageAssociatedWithFrame;
  }

  @override
  Future<List<String>> getPairedFrameIdsOfCurator(
      {required String curatorId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT frame_id FROM curator_x_frame "
      "WHERE curator_id = ?",
      [curatorId],
    );

    final List<String> frameIds = queryResult
        .map((Map<String, dynamic> row) => row["frame_id"] as String)
        .toList();

    return frameIds;
  }
}
