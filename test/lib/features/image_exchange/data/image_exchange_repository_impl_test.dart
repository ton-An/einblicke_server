// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/data/repository_implementations/image_exchange_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late ImageExchangeRepositoryImpl imageExchangeRepositoryImpl;
  late MockImageExchangeRemoteDataSource mockImageExchangeRemoteDataSource;
  late MockCryptoLocalDataSource mockCryptoLocalDataSource;

  late MockMySqlException tMockMysqlException;

  setUp(() {
    mockImageExchangeRemoteDataSource = MockImageExchangeRemoteDataSource();
    mockCryptoLocalDataSource = MockCryptoLocalDataSource();
    imageExchangeRepositoryImpl = ImageExchangeRepositoryImpl(
      remoteDataSource: mockImageExchangeRemoteDataSource,
      cryptoLocalDataSource: mockCryptoLocalDataSource,
    );

    tMockMysqlException = MockMySqlException();
  });

  group("areCuratorXFramePaired()", () {
    setUp(() {
      when(
        () => mockImageExchangeRemoteDataSource.areCuratorXFramePaired(
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
        () => mockImageExchangeRemoteDataSource.areCuratorXFramePaired(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
        ),
      );
      expect(result, const Right(true));
    });

    test(
        "should return a [DatabaseReadFailure] when the data source throws a [MySqlException]",
        () async {
      // arrange
      when(
        () => mockImageExchangeRemoteDataSource.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockMysqlException);

      // act
      final result = await imageExchangeRepositoryImpl.areCuratorXFramePaired(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("generateImageId()", () {
    setUp(() {
      when(() => mockCryptoLocalDataSource.generateUuid())
          .thenReturn(tUuidString);
    });

    test("should generate a uuid [String] and return it", () {
      // act
      final result = imageExchangeRepositoryImpl.generateImageId();

      // assert
      verify(() => mockCryptoLocalDataSource.generateUuid());
      expect(result, tUuidString);
    });
  });

  group("getImageById()", () {});

  group("getLatestImageIdFromDb()", () {
    setUp(() {
      when(
        () => mockImageExchangeRemoteDataSource.getLatestImageIdFromDb(
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
        () => mockImageExchangeRemoteDataSource.getLatestImageIdFromDb(
          frameId: tPictureFrameId,
        ),
      );
      expect(result, const Right(tImageId));
    });

    test(
        "should return a [DatabaseReadFailure] when the data source "
        "throws a [MySqlException]", () async {
      // arrange
      when(
        () => mockImageExchangeRemoteDataSource.getLatestImageIdFromDb(
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockMysqlException);

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
        () => mockImageExchangeRemoteDataSource.pairCuratorXFrame(
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
        () => mockImageExchangeRemoteDataSource.pairCuratorXFrame(
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
        () => mockImageExchangeRemoteDataSource.pairCuratorXFrame(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenThrow(tMockMysqlException);

      // act
      final result = await imageExchangeRepositoryImpl.pairCuratorXFrame(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  group("saveImage()", () {});

  group("saveImageToDb()", () {
    setUp(() {
      when(
        () => mockImageExchangeRemoteDataSource.saveImageToDb(
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
        () => mockImageExchangeRemoteDataSource.saveImageToDb(
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
        "throws a [MySqlException]", () async {
      // arrange
      when(
        () => mockImageExchangeRemoteDataSource.saveImageToDb(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
          imageId: any(named: "imageId"),
          createdAt: any(named: "createdAt"),
        ),
      ).thenThrow(tMockMysqlException);

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
