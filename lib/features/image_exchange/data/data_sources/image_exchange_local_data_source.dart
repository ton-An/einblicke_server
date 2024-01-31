import 'dart:io';
import 'dart:typed_data';

import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// {@template image_exchange_local_data_source}
/// Local data source for handling the exchange of images between
/// a curator and a frame
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
  /// - [SqliteException]
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
  /// - [SqliteException]
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
  /// - [SqliteException]
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
  /// - [SqliteException]
  Future<bool> doesImageBelongToFrame({
    required String frameId,
    required String imageId,
  });
}

/// {@macro image_exchange_local_data_source}
class ImageExchangeLocalDataSourceImpl extends ImageExchangeLocalDataSource {
  /// {@macro image_exchange_local_data_source}
  const ImageExchangeLocalDataSourceImpl({
    required this.sqliteDatabase,
    required this.imageDirectoryPath,
  });

  /// The database connection
  final Database sqliteDatabase;

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
    print(queryResult);

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

    // ToDo: test
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

  // ToDo: test
  @override
  Future<bool> doesImageBelongToFrame(
      {required String frameId, required String imageId}) async {
    final List<Map<String, dynamic>> queryResult =
        await sqliteDatabase.rawQuery(
      "SELECT EXISTS(SELECT 1 FROM images "
      "WHERE frame_id = ? AND image_id = ?)",
      [frameId, imageId],
    );

    final bool doesImageBelongToFrame = queryResult.first.containsValue(1);

    return doesImageBelongToFrame;
  }
}
