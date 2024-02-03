import 'dart:io';
import 'dart:typed_data';

import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../../../../../database_mocks.dart';
import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

// ToDo: Need to clean up the database tests (especially the test query results)

void main() {
  late ImageExchangeLocalDataSourceImpl imageExchangeLocalDataSourceImpl;
  late Database database;

  late MockFile tMockFile;

  setUp(() async {
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await setUpMockCuratorXFrameTable(database);
    await setUpMockImagesTable(database);

    tMockFile = MockFile();

    imageExchangeLocalDataSourceImpl = ImageExchangeLocalDataSourceImpl(
      sqliteDatabase: database,
      imageDirectoryPath: tImageDirectoryPath,
    );
  });

  tearDown(() {
    database.close();
  });

  group("areCuratorXFramePaired", () {
    test(
        "should check if there is an entry in the curator_x_frame table for "
        "the given curator and frame and return the result as a [bool]",
        () async {
      // arrange
      await imageExchangeLocalDataSourceImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // act
      final result =
          await imageExchangeLocalDataSourceImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, true);
    });
  });
  group("pairCuratorXFrame", () {
    test(
        "should insert an entry into the curator_x_frame table for "
        "the given curator and frame", () async {
      // act
      await imageExchangeLocalDataSourceImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      final result =
          await imageExchangeLocalDataSourceImpl.areCuratorXFramePaired(
              curatorId: tCuratorId, frameId: tPictureFrameId);
      expect(result, true);
    });
  });

  group("saveImageToDb", () {
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
      final result =
          await imageExchangeLocalDataSourceImpl.getLatestImageIdFromDb(
        frameId: tPictureFrameId,
      );
      expect(result, tImageId);
    });
  });

  group("getLatestImageIdFromDb", () {
    test(
        "should get the latest image id from the images table for "
        "the given frame", () async {
      // arrange
      await imageExchangeLocalDataSourceImpl.saveImageToDb(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
          imageId: tImageId,
          createdAt: tCreatedAt);

      // act
      final result = await imageExchangeLocalDataSourceImpl
          .getLatestImageIdFromDb(frameId: tPictureFrameId);

      // assert
      expect(result, tImageId);
    });
  });

  group("saveImage", () {
    setUp(() {
      when(() => tMockFile.create(recursive: any(named: "recursive")))
          .thenAnswer((_) async => tMockFile);
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
