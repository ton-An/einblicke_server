// ignore_for_file: inference_failure_on_instance_creation

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/frame_image_stream.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late FrameImageStream frameImageStream;
  late StreamController<Either<Failure, Image>> mockImageStreamController;
  late MockGetLatestImage mockGetLatestImage;

  setUp(() {
    mockImageStreamController = StreamController();
    mockGetLatestImage = MockGetLatestImage();
    frameImageStream = FrameImageStream(
      streamController: mockImageStreamController,
      getLatestImage: mockGetLatestImage,
    );

    when(() => mockGetLatestImage(frameId: any(named: "frameId")))
        .thenAnswer((_) async => const Right(tImage));
  });

  group("init stream", () {
    test("should get the latest image and add it to the stream", () async {
      // arrange

      // actaw
      await frameImageStream.initStream(frameId: tPictureFrameId);
      final stream = frameImageStream.getStream();

      // assert
      await expectLater(stream, emitsInOrder([const Right(tImage)]));
      verify(() => mockGetLatestImage(frameId: tPictureFrameId));
    });
    test("should yield [Failure]s", () async {
      // arrange
      when(() => mockGetLatestImage(frameId: any(named: "frameId")))
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      await frameImageStream.initStream(frameId: tPictureFrameId);
      final stream = frameImageStream.getStream();

      // assert
      await expectLater(
          stream, emitsInOrder([const Left(DatabaseReadFailure())]));
    });
  });

  group("get stream", () {
    test("should get the stream", () {
      // arrange

      // act
      final stream = frameImageStream.getStream();

      // assert
      expect(stream, isA<Stream<Either<Failure, Image>>>());
    });
  });

  group("add image", () {
    test("should add an [Image] to the stream", () async {
      // arrange

      // act
      await frameImageStream.initStream(frameId: tPictureFrameId);
      final stream = frameImageStream.getStream();

      frameImageStream
        ..addImage(tSecondImage)
        ..addImage(tThirdImage);

      // assert
      await expectLater(
        stream,
        emitsInOrder([
          const Right(tImage),
          const Right(tSecondImage),
          const Right(tThirdImage)
        ]),
      );
    });
  });

  group("add failure", () {
    test("should add a [Failure] to the stream", () async {
      // act
      await frameImageStream.initStream(frameId: tPictureFrameId);
      final stream = frameImageStream.getStream();

      frameImageStream.addFailure(const DatabaseReadFailure());

      // assert
      await expectLater(
        stream,
        emitsInOrder([const Right(tImage), const Left(DatabaseReadFailure())]),
      );
    });
  });
}
