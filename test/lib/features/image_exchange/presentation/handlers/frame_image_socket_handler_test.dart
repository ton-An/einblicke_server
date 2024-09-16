// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/frame_image_socket_handler.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late FrameImageSocketHandler frameImageSocketHandler;
  late MockGetLatestImage mockGetLatestImage;
  late MockGetImageFromId mockGetImageFromId;

  late MockStreamSink tMockStreamSink;
  late MockStreamSink tSecondMockStreamSink;

  setUp(() {
    mockGetLatestImage = MockGetLatestImage();
    mockGetImageFromId = MockGetImageFromId();

    frameImageSocketHandler = FrameImageSocketHandler(
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
      await frameImageSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => mockGetLatestImage(frameId: tPictureFrameId));
    });

    test("should send the image id to the frame", () async {
      // act
      await frameImageSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => tMockStreamSink.add(tImageIdJsonString));
    });

    test("should add failures code to the [StreamSink]", () async {
      // arrange
      when(
        () => mockGetLatestImage(frameId: any(named: "frameId")),
      ).thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      await frameImageSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => tMockStreamSink.add(tDatabaseReadFailureJsonString));
    });

    test(
        "should get [None] in return when calling sendImage after establishing the connection",
        () async {
// arrange
      await frameImageSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // act
      final result = await frameImageSocketHandler.sendImage(
        imageId: tImageId,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Right(None()));
    });
  });

  group("send image", () {
    setUp(() async {
      await frameImageSocketHandler.addConnection(
          frameId: tPictureFrameId, streamSink: tMockStreamSink);
    });

    test("should get the image", () async {
      // act
      await frameImageSocketHandler.sendImage(
        frameId: tPictureFrameId,
        imageId: tImageId,
      );

      // assert
      verify(() => mockGetImageFromId(imageId: tImageId));
    });

    test("should add the image to all the frame's sinks", () async {
      // arrange
      await frameImageSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tSecondMockStreamSink,
      );

      // act
      await frameImageSocketHandler.sendImage(
        frameId: tPictureFrameId,
        imageId: tImageId,
      );

      // assert
      verify(() => tMockStreamSink.add(tImageIdJsonString));
      verify(() => tSecondMockStreamSink.add(tImageIdJsonString));
    });

    test("should return [None] on success", () async {
      // act
      final result = await frameImageSocketHandler.sendImage(
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
      final result = await frameImageSocketHandler.sendImage(
          frameId: tPictureFrameId, imageId: tImageId);

      // assert
      expect(result, const Left(DatabaseReadFailure()));
    });
  });
}
