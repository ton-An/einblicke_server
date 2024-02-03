// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/presentation/handlers/frame_socket_handler.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late FrameSocketHandler frameSocketHandler;
  late MockGetLatestImage mockGetLatestImage;
  late MockGetImageFromId mockGetImageFromId;

  late MockStreamSink tMockStreamSink;
  late MockStreamSink tSecondMockStreamSink;

  setUp(() {
    mockGetLatestImage = MockGetLatestImage();
    mockGetImageFromId = MockGetImageFromId();

    frameSocketHandler = FrameSocketHandler(
      getLatestImage: mockGetLatestImage,
      getImageFromId: mockGetImageFromId,
    );

    tMockStreamSink = MockStreamSink();
    tSecondMockStreamSink = MockStreamSink();

    when(() => mockGetImageFromId(imageId: any(named: "imageId")))
        .thenAnswer((_) async => const Right(tImage));
    when(() => mockGetLatestImage(frameId: any(named: "frameId")))
        .thenAnswer((_) async => const Right(tImage));
  });

  group("add connection", () {
    test("should get the latest [Image] for the given frame", () async {
      // act
      await frameSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => mockGetLatestImage(frameId: tPictureFrameId));
    });

    test("should add the [Image] to the [StreamSink]", () async {
      // act
      await frameSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => tMockStreamSink.add(const Right(tImage)));
    });

    test("should add [Failure]s to the [StreamSink]", () async {
      // arrange
      when(
        () => mockGetLatestImage(frameId: any(named: "frameId")),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      await frameSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => tMockStreamSink.add(const Left(DatabaseReadFailure())));
    });

    test(
        "should get [None] in return when calling sendImage after establishing the connection",
        () async {
// arrange
      await frameSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // act
      final result = await frameSocketHandler.sendImage(
        imageId: tImageId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Right(None()));
    });
  });

  group("remove connection", () {
    group("if connected to the frame", () {
      setUp(() async {
        await frameSocketHandler.addConnection(
          frameId: tPictureFrameId,
          streamSink: tMockStreamSink,
        );
      });

      test("should return [None] on success", () {
        // act
        final result = frameSocketHandler.removeConnection(
          streamSink: tMockStreamSink,
        );

        // assert
        expect(result, const Right(None()));
      });

      test(
          "should receive a [FrameNotConnectedFailure] for send image after removing the connection",
          () async {
        // act
        frameSocketHandler.removeConnection(
          streamSink: tMockStreamSink,
        );
        final result = await frameSocketHandler.sendImage(
          frameId: tPictureFrameId,
          imageId: tImageId,
        );

        // assert
        expect(result, const Left(FrameNotConnectedFailure()));
      });
    });

    test(
        "should return a [FrameNotConnectedFailure] if there is no connection with that [Streamsink]",
        () {
      // act
      final result = frameSocketHandler.removeConnection(
        streamSink: tMockStreamSink,
      );

      // assert
      expect(result, const Left(FrameNotConnectedFailure()));
    });
  });

  group("send image", () {
    // check if at least one connection to the frameId exists, if not failure
    // get image
    // add image to all the frame sink

    group("if connected to the frame", () {
      setUp(() async {
        await frameSocketHandler.addConnection(
            frameId: tPictureFrameId, streamSink: tMockStreamSink);
      });

      test("should get the image", () async {
        // act
        await frameSocketHandler.sendImage(
          frameId: tPictureFrameId,
          imageId: tImageId,
        );

        // assert
        verify(() => mockGetImageFromId(imageId: tImageId));
      });

      test("should add the image to all the frame's sinks", () async {
        // arrange
        await frameSocketHandler.addConnection(
          frameId: tPictureFrameId,
          streamSink: tSecondMockStreamSink,
        );

        // act
        await frameSocketHandler.sendImage(
          frameId: tPictureFrameId,
          imageId: tImageId,
        );

        // assert
        verify(() => tMockStreamSink.add(const Right(tImage)));
        verify(() => tSecondMockStreamSink.add(const Right(tImage)));
      });

      test("should return [None] on success", () async {
        // act
        final result = await frameSocketHandler.sendImage(
          frameId: tPictureFrameId,
          imageId: tImageId,
        );

        // assert
        expect(result, const Right(None()));
      });

      test("should relay [Failure]s", () async {
        // arrange
        when(() => mockGetImageFromId(imageId: any(named: "imageId")))
            .thenAnswer((_) async => const Left(DatabaseReadFailure()));

        // act
        final result = await frameSocketHandler.sendImage(
            frameId: tPictureFrameId, imageId: tImageId);

        // assert
        expect(result, const Left(DatabaseReadFailure()));
      });
    });

    test(
        "should return a [FrameNotConnectedFailure] if there are no [StreamSinks] with the given frameId",
        () async {
      // act
      final result = await frameSocketHandler.sendImage(
          frameId: tPictureFrameId, imageId: tImageId);

      // assert
      expect(result, const Left(FrameNotConnectedFailure()));
    });
  });
}
