import 'dart:io';
import 'dart:typed_data';

import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

// ToDo: Need to clean up the database tests (especially the test query results)

void main() {
  late ImageExchangeLocalDataSourceImpl imageExchangeLocalDataSourceImpl;
  late Database database;

  late MockFile tMockFile;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    tMockFile = MockFile();

    imageExchangeLocalDataSourceImpl = ImageExchangeLocalDataSourceImpl(
      sqliteDatabase: database,
      imageDirectoryPath: tImageDirectoryPath,
    );
  });

  group("areCuratorXFramePaired", () {
    setUp(() {
      final List<Map<String, Object?>> tDbRow = [];
      // Row(
      //   ResultSet(
      //     [
      //       "SELECT EXISTS(SELECT 1 FROM curator_x_frame WHERE curator_id = ? AND frame_id = ?)",
      //     ],
      //     [null],
      //     [
      //       [1],
      //     ],
      //   ),
      //   [1],
      // );

      when(() => database.rawQuery(any(), any()))
          .thenAnswer((_) async => tDbRow);
    });

    test(
        "should check if there is an entry in the curator_x_frame table for "
        "the given curator and frame and return the result as a [bool]",
        () async {
      // act
      final result =
          await imageExchangeLocalDataSourceImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => database.rawQuery(
          "SELECT EXISTS(SELECT 1 FROM curator_x_frame "
          "WHERE curator_id = ? AND frame_id = ?)",
          [tCuratorId, tPictureFrameId],
        ),
      );
      expect(result, true);
    });
  });
  group("pairCuratorXFrame", () {
    setUp(() {
      when(() => database.execute(any(), any()))
          .thenAnswer((_) async => Future.value());
    });

    test(
        "should insert an entry into the curator_x_frame table for "
        "the given curator and frame", () async {
      // act
      await imageExchangeLocalDataSourceImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => database.execute(
          "INSERT INTO curator_x_frame (curator_id, frame_id) "
          "VALUES (?, ?)",
          [tCuratorId, tPictureFrameId],
        ),
      );
    });
  });

  group("saveImageToDb", () {
    setUp(() {
      when(() => database.execute(any(), any()))
          .thenAnswer((_) async => Future.value());
    });

    test(
        "should insert an entry into the images table for "
        "the given curator, frame and image", () async {
      // act
      await imageExchangeLocalDataSourceImpl.saveImageToDb(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageId: tImageId,
        createdAt: tCreatedAt,
      );

      // assert
      verify(
        () => database.execute(
          "INSERT INTO images (curator_id, frame_id, image_id, created_at) "
          "VALUES (?, ?, ?, ?)",
          [tCuratorId, tPictureFrameId, tImageId, tCreatedAt.toIso8601String()],
        ),
      );
    });
  });

  group("getLatestImageIdFromDb", () {
    setUp(() {
      final List<Map<String, Object?>> tDbRow = [];
      // Row(
      //   ResultSet(
      //     [
      //       "SELECT image_id FROM images WHERE frame_id = ? ORDER BY created_at DESC LIMIT 1",
      //     ],
      //     ["images"],
      //     [
      //       [tImageId],
      //     ],
      //   ),
      //   [tImageId],
      // );

      when(() => database.rawQuery(any(), any()))
          .thenAnswer((_) async => tDbRow);
    });

    test(
        "should get the latest image id from the images table for "
        "the given frame", () async {
      // act
      final result = await imageExchangeLocalDataSourceImpl
          .getLatestImageIdFromDb(frameId: tPictureFrameId);

      // assert
      verify(
        () => database.rawQuery(
          "SELECT image_id FROM images "
          "WHERE frame_id = ? "
          "ORDER BY created_at DESC "
          "LIMIT 1",
          [tPictureFrameId],
        ),
      );
      expect(result, tImageId);
    });
  });

  group("saveImage", () {
    setUp(() {
      when(() => tMockFile.writeAsBytes(any(), flush: any(named: "flush")))
          .thenAnswer((_) async => tMockFile);
    });

    test("should write the image to the image directory", () {
      IOOverrides.runZoned(
        () async {
          // act
          await imageExchangeLocalDataSourceImpl.saveImage(
            imageId: tImageId,
            imageBytes: tImageBytes,
          );

          // assert
          verify(
            () => tMockFile.writeAsBytes(
              tImageBytes,
              flush: true,
            ),
          );
        },
        createFile: (String filePath) {
          // assert
          expect(filePath, tImageFilePath);
          return tMockFile;
        },
      );
    });
  });

  group("getImageById", () {
    setUp(() {
      when(() => tMockFile.readAsBytes())
          .thenAnswer((_) async => Uint8List.fromList(tImageBytes));
    });

    test("should get the image from the image directory", () {
      IOOverrides.runZoned(
        () async {
          // act
          final result = await imageExchangeLocalDataSourceImpl.getImageById(
            imageId: tImageId,
          );

          // assert
          verify(() => tMockFile.readAsBytes());
          expect(result, tImage);
        },
        createFile: (String filePath) {
          // assert
          expect(filePath, tImageFilePath);
          return tMockFile;
        },
      );
    });
  });
}
