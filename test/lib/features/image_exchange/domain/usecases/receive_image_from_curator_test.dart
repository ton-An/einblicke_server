// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/image_save_failure.dart';
import 'package:dispatch_pi_dart/core/failures/not_paired_failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/receive_image_from_curator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late ReceiveImageFromCurator receiveImageFromCurator;
  late MockImageExchangeRepository mockImageExchangeRepository;
  late MockClock mockClock;

  setUp(() {
    mockImageExchangeRepository = MockImageExchangeRepository();
    mockClock = MockClock();
    receiveImageFromCurator = ReceiveImageFromCurator(
      imageExchangeRepository: mockImageExchangeRepository,
      clock: mockClock,
    );

    when(
      () => mockImageExchangeRepository.areCuratorXFramePaired(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) async => const Right(true));

    when(() => mockClock.now()).thenReturn(tCreatedAt);

    when(
      () => mockImageExchangeRepository.generateImageId(),
    ).thenReturn(tImageId);

    when(
      () => mockImageExchangeRepository.saveImage(
        imageId: any(named: "imageId"),
        imageBytes: any(named: "imageBytes"),
      ),
    ).thenAnswer((_) async => const Right(None()));

    when(
      () => mockImageExchangeRepository.saveImageToDb(
        curatorId: any(named: "curatorId"),
        frameId: any(named: "frameId"),
        imageId: any(named: "imageId"),
        createdAt: any(named: "createdAt"),
      ),
    ).thenAnswer((_) async => const Right(None()));
  });

  group("check if the curator and frame are paired", () {
    test("should check if the curator and frame are paired", () async {
      // act
      await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(
        () => mockImageExchangeRepository.areCuratorXFramePaired(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
        ),
      );
    });

    test(
        "should return a [NotPairedFailure] if the curator and frame are not paired",
        () async {
      // arrange
      when(
        () => mockImageExchangeRepository.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Right(false));

      // act
      final result = await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      expect(result, const Left(NotPairedFailure()));
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.areCuratorXFramePaired(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      final result = await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("generate image id", () {
    test("should generate an image id", () async {
      // act
      await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(() => mockImageExchangeRepository.generateImageId());
    });
  });

  group("save the image", () {
    test("should get the current time", () async {
      // act
      await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(() => mockClock.now());
    });

    test("should save the image", () async {
      // act
      await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(
        () => mockImageExchangeRepository.saveImage(
          imageId: tImageId,
          imageBytes: tImageBytes,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.saveImage(
          imageId: any(named: "imageId"),
          imageBytes: any(named: "imageBytes"),
        ),
      ).thenAnswer((_) async => const Left(ImageSaveFailure()));

      // act
      final result = await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      expect(result, const Left(ImageSaveFailure()));
    });
  });

  group("save image to db", () {
    test("should save the image to the db", () async {
      // act
      await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      verify(
        () => mockImageExchangeRepository.saveImageToDb(
          curatorId: tCuratorId,
          frameId: tPictureFrameId,
          imageId: tImageId,
          createdAt: tCreatedAt,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      // arrange
      when(
        () => mockImageExchangeRepository.saveImageToDb(
          curatorId: any(named: "curatorId"),
          frameId: any(named: "frameId"),
          imageId: any(named: "imageId"),
          createdAt: any(named: "createdAt"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseWriteFailure()));

      // act
      final result = await receiveImageFromCurator(
        curatorId: tCuratorId,
        frameId: tPictureFrameId,
        imageBytes: tImageBytes,
      );

      // assert
      expect(result, const Left(DatabaseWriteFailure()));
    });
  });

  test("should return None", () async {
    // act
    final result = await receiveImageFromCurator(
      curatorId: tCuratorId,
      frameId: tPictureFrameId,
      imageBytes: tImageBytes,
    );

    // assert
    expect(result, const Right(None()));
  });
}
