// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late GetLatestImage getLatestImage;
  late MockImageExchangeRepository mockImageExchangeRepository;

  setUp(() {
    mockImageExchangeRepository = MockImageExchangeRepository();
    getLatestImage = GetLatestImage(
      imageExchangeRepository: mockImageExchangeRepository,
    );

    when(
      () => mockImageExchangeRepository.getLatestImageIdFromDb(
        frameId: any(named: "frameId"),
      ),
    ).thenAnswer((_) async => const Right(tImageId));

    when(
      () => mockImageExchangeRepository.getImageById(
        imageId: any(named: "imageId"),
      ),
    ).thenAnswer((_) async => const Right(tImage));
  });

  group("get latest image id from the database", () {
    test("should get the latest image from the database using the frame id",
        () async {
      await getLatestImage(frameId: tPictureFrameId);

      verify(
        () => mockImageExchangeRepository.getLatestImageIdFromDb(
          frameId: tPictureFrameId,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      when(
        () => mockImageExchangeRepository.getLatestImageIdFromDb(
          frameId: any(named: "frameId"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      final result = await getLatestImage(frameId: tPictureFrameId);

      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  group("get image from storage", () {
    test("should get the image from storage using the image id", () async {
      await getLatestImage(frameId: tPictureFrameId);

      verify(
        () => mockImageExchangeRepository.getImageById(
          imageId: tImageId,
        ),
      );
    });

    test("should relay [Failure]s", () async {
      when(
        () => mockImageExchangeRepository.getImageById(
          imageId: any(named: "imageId"),
        ),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      final result = await getLatestImage(frameId: tPictureFrameId);

      expect(result, const Left(DatabaseReadFailure()));
    });
  });

  test("should return an [Image]", () async {
    // act
    final result = await getLatestImage(frameId: tPictureFrameId);

    // assert
    expect(result, const Right(tImage));
  });
}
