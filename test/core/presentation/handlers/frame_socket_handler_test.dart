// ignore_for_file: inference_failure_on_instance_creation

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/frame_socket_handler.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fixtures.dart';
import '../../../mocks.dart';

class TFrameSocketHandlerImplementation extends FrameSocketHandler {}

void main() {
  late TFrameSocketHandlerImplementation frameSocketHandler;

  late MockStreamSink tMockStreamSink;
  late MockStreamSink tSecondMockStreamSink;

  setUp(() {
    frameSocketHandler = TFrameSocketHandlerImplementation();

    tMockStreamSink = MockStreamSink();
    tSecondMockStreamSink = MockStreamSink();
  });

  group("addConnection", () {
    test(
        "should get [None] in return when calling sendMessage after establishing the connection (meaning the frame is connected)",
        () async {
// arrange
      await frameSocketHandler.addConnection(
        frameId: tPictureFrameId,
        streamSink: tMockStreamSink,
      );

      // act
      final result = await frameSocketHandler.sendMessage(
        message: tMessage,
        frameId: tPictureFrameId,
      );

      // assert
      expect(result, const Right(None()));
    });
  });

  group("removeConnection", () {
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
          "should receive a [FrameNotConnectedFailure] for sendMessage after removing the connection (meaning the frame isn't connected anymore)",
          () async {
        // act
        frameSocketHandler.removeConnection(
          streamSink: tMockStreamSink,
        );
        final result = await frameSocketHandler.sendMessage(
          frameId: tPictureFrameId,
          message: tMessage,
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

  group("send message", () {
    group("if connected to the frame", () {
      setUp(() async {
        await frameSocketHandler.addConnection(
          frameId: tPictureFrameId,
          streamSink: tMockStreamSink,
        );
      });

      test("should add the message to all the frame's sinks", () async {
        // arrange
        await frameSocketHandler.addConnection(
          frameId: tPictureFrameId,
          streamSink: tSecondMockStreamSink,
        );

        // act
        await frameSocketHandler.sendMessage(
          frameId: tPictureFrameId,
          message: tMessage,
        );

        // assert
        verify(() => tMockStreamSink.add(tMessage));
        verify(() => tSecondMockStreamSink.add(tMessage));
      });

      test("should return [None] on success", () async {
        // act
        final result = await frameSocketHandler.sendMessage(
          frameId: tPictureFrameId,
          message: tMessage,
        );

        // assert
        expect(result, const Right(None()));
      });
    });

    group("if not connected to the frame", () {
      test(
          "should return a [FrameNotConnectedFailure] if there are no [StreamSinks] with the given frameId",
          () async {
        // act
        final result = await frameSocketHandler.sendMessage(
          frameId: tPictureFrameId,
          message: tMessage,
        );

        // assert
        expect(result, const Left(FrameNotConnectedFailure()));
      });
    });
  });
}
