import 'package:dispatch_pi_dart/features/image_exchange/data/data_sources/image_exchange_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late ImageExchangeRemoteDataSourceImpl imageExchangeRemoteDataSourceImpl;
  late MockSqliteDatabase mockSqliteDatabase;

  setUp(() {
    mockSqliteDatabase = MockSqliteDatabase();
    imageExchangeRemoteDataSourceImpl = ImageExchangeRemoteDataSourceImpl(
      sqliteDatabase: mockSqliteDatabase,
    );
  });

  group("areCuratorXFramePaired", () {
    setUp(() {
      final Row tDbRow = Row(
        ResultSet(
          [
            "SELECT EXISTS(SELECT 1 FROM curator_x_frame WHERE curator_id = ? AND frame_id = ?)",
          ],
          [null],
          [
            [1],
          ],
        ),
        [1],
      );

      when(() => mockSqliteDatabase.get(any(), any()))
          .thenAnswer((_) async => tDbRow);
    });

    test(
        "should check if there is an entry in the curator_x_frame table for "
        "the given curator and frame and return the result as a [bool]",
        () async {
      // act
      final result =
          await imageExchangeRemoteDataSourceImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockSqliteDatabase.get(
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
      when(() => mockSqliteDatabase.execute(any(), any()))
          .thenAnswer((_) async => MockResultSet());
    });

    test(
        "should insert an entry into the curator_x_frame table for "
        "the given curator and frame", () async {
      // act
      await imageExchangeRemoteDataSourceImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockSqliteDatabase.execute(
          "INSERT INTO curator_x_frame (curator_id, frame_id) "
          "VALUES (?, ?)",
          [tCuratorId, tPictureFrameId],
        ),
      );
    });
  });

  group("saveImageToDb", () {
    setUp(() {
      when(() => mockSqliteDatabase.execute(any(), any()))
          .thenAnswer((_) async => MockResultSet());
    });

    test(
        "should insert an entry into the images table for "
        "the given curator, frame and image", () async {
      // act
      await imageExchangeRemoteDataSourceImpl.saveImageToDb(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageId: tImageId,
        createdAt: tCreatedAt,
      );

      // assert
      verify(
        () => mockSqliteDatabase.execute(
          "INSERT INTO images (curator_id, frame_id, image_id, created_at) "
          "VALUES (?, ?, ?, ?)",
          [tCuratorId, tPictureFrameId, tImageId, tCreatedAt.toIso8601String()],
        ),
      );
    });
  });

  group("getLatestImageIdFromDb", () {
    setUp(() {
      final Row tDbRow = Row(
        ResultSet(
          [
            "SELECT image_id FROM images WHERE frame_id = ? ORDER BY created_at DESC LIMIT 1",
          ],
          ["images"],
          [
            [tImageId],
          ],
        ),
        [tImageId],
      );

      when(() => mockSqliteDatabase.get(any(), any()))
          .thenAnswer((_) async => tDbRow);
    });

    test(
        "should get the latest image id from the images table for "
        "the given frame", () async {
      // act
      final result = await imageExchangeRemoteDataSourceImpl
          .getLatestImageIdFromDb(frameId: tPictureFrameId);

      // assert
      verify(
        () => mockSqliteDatabase.get(
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
}
