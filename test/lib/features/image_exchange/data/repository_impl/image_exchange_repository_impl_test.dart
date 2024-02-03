// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/repository_implementations/image_exchange_repository_impl.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late ImageExchangeRepositoryImpl imageExchangeRepositoryImpl;
  late MockImageExchangeLocalDataSource mockImageExchangeLocalDataSource;

  late MockSqliteException tMockSqliteExcpetion;

  setUp(() {
    mockImageExchangeLocalDataSource = MockImageExchangeLocalDataSource();
    imageExchangeRepositoryImpl = ImageExchangeRepositoryImpl(
      localDataSource: mockImageExchangeLocalDataSource,
    );

    tMockSqliteExcpetion = MockSqliteException();
  });

  group("areCuratorXFramePaired()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => true);
    });

    test("should get the [bool] from the data source and return it", () async {
      // act
      final result = await imageExchangeRepositoryImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.areCuratorXFramePaired(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseReadFailure] when the data source throws a [SqliteException]",
        () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockSqliteExcpetion);

      // act
      final result = await imageExchangeRepositoryImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("getImageById()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.getImageById(
          imageId: any(named: "imageId"),
        ),
      ).thenAnswer((_) async => tImage);
    });

    test("should get the image from the data source and return it", () async {
      // act
      final result = await imageExchangeRepositoryImpl.getImageById(
        imageId: tImageId,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.getImageById(
          imageId: tImageId,
        ),
      );
      expect(result, const Right(tImage));
    });

    test(
        "should return a [StorageReadFailure] when the data source "
        "throws a [IOException]", () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.getImageById(
          imageId: any(named: "imageId"),
        ),
      ).thenThrow(MockIOException());

      // act
      final result = await imageExchangeRepositoryImpl.getImageById(
        imageId: tImageId,
      );

      // assert§
      expect(result, const Left(StorageReadFailure()));
    });
  });

  group("getLatestImageIdFromDb()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.getLatestImageIdFromDb(
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => tImageId);
    });

    test("should get the latest image id and return it", () async {
      // act
      final result = await imageExchangeRepositoryImpl.getLatestImageIdFromDb(
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.getLatestImageIdFromDb(
          frameId: tPictureFrameId,
        ),
      );
      expect(result, const Right(tImageId));
    });

    test(
        "should return a [DatabaseReadFailure] when the data source "
        "throws a [SqliteException]", () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.getLatestImageIdFromDb(
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockSqliteExcpetion);

      // act
      final result = await imageExchangeRepositoryImpl.getLatestImageIdFromDb(
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("pairCuratorXFrame()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.pairCuratorXFrame(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test("should add the curator and frame pair to the db and return [None]",
        () async {
      // act
      final result = await imageExchangeRepositoryImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.pairCuratorXFrame(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the data source "
        "throws a [MysqlException]", () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.pairCuratorXFrame(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockSqliteExcpetion);

      // act
      final result = await imageExchangeRepositoryImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("saveImage()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.saveImage(
          imageId: any(named: "imageId"),
          imageBytes: any(named: "imageBytes"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test("should save the image to the db and return [None]", () async {
      // act
      final result = await imageExchangeRepositoryImpl.saveImage(
        imageId: tImageId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.saveImage(
          imageId: tImageId,
          imageBytes: tImageBytes,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [StorageWriteFailure] when the data source "
        "throws a [IOException]", () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.saveImage(
          imageId: any(named: "imageId"),
          imageBytes: any(named: "imageBytes"),
        ),
      ).thenThrow(MockIOException());

      // act
      final result = await imageExchangeRepositoryImpl.saveImage(
        imageId: tImageId,
        imageBytes: tImageBytes,
      );

      // assert
      expect(result, const Left(StorageWriteFailure()));
    });
  });

  group("saveImageToDb()", () {
    setUp(() {
      when(
        () => mockImageExchangeLocalDataSource.saveImageToDb(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
          imageId: any(named: "imageId"),
          createdAt: any(named: "createdAt"),
        ),
      ).thenAnswer((_) => Future.value());
    });

    test("should save the image to the db and return [None]", () async {
      // act
      final result = await imageExchangeRepositoryImpl.saveImageToDb(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageId: tImageId,
        createdAt: tCreatedAt,
      );

      // assert
      verify(
        () => mockImageExchangeLocalDataSource.saveImageToDb(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
          imageId: tImageId,
          createdAt: tCreatedAt,
        ),
      );
      expect(result, const Right(None()));
    });

    test(
        "should return a [DatabaseWriteFailure] when the data source "
        "throws a [SqliteException]", () async {
      // arrange
      when(
        () => mockImageExchangeLocalDataSource.saveImageToDb(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
          imageId: any(named: "imageId"),
          createdAt: any(named: "createdAt"),
        ),
      ).thenThrow(tMockSqliteExcpetion);

      // act
      final result = await imageExchangeRepositoryImpl.saveImageToDb(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageId: tImageId,
        createdAt: tCreatedAt,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });
}
