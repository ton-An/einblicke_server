import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/presentation/handlers/pairing_socket_handler.dart';
import 'package:einblicke_shared/einblicke_shared.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../fixtures.dart';
import '../../../../../mocks.dart';

void main() {
  late PairingSocketHandler pairingSocketHandler;
  late MockGenerateUserId mockGenerateUserId;
  late MockCreateFrame mockCreateFrame;
  late MockSignInFrame mockSignInFrame;

  late MockStreamSink tMockStreamSink;

  setUp(() {
    mockGenerateUserId = MockGenerateUserId();
    mockCreateFrame = MockCreateFrame();
    mockSignInFrame = MockSignInFrame();
    pairingSocketHandler = PairingSocketHandler(
      generateUserId: mockGenerateUserId,
      createFrame: mockCreateFrame,
      signInFrame: mockSignInFrame,
    );

    tMockStreamSink = MockStreamSink();
  });

  group("add anonymous connection", () {
    setUp(() {
      when(() => mockGenerateUserId())
          .thenAnswer((_) async => const Right(tPictureFrameId));
    });
    test("should generate a temporary frame id", () async {
      // act
      await pairingSocketHandler.addAnonymousConnection(
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => mockGenerateUserId());
    });

    test("should relay [Failure]s from [GenerateUserId] to the [StreamSink]",
        () async {
      // arrange
      when(() => mockGenerateUserId())
          .thenAnswer((_) async => const Left(DatabaseReadFailure()));

      // act
      await pairingSocketHandler.addAnonymousConnection(
        streamSink: tMockStreamSink,
      );

      // assert
      verify(() => tMockStreamSink.add(tDatabaseReadFailureJsonString));
    });

    test("should send the temporary frame id to the frame", () async {
      // act
      await pairingSocketHandler.addAnonymousConnection(
        streamSink: tMockStreamSink,
      );

      // assert
      verify(
        () => tMockStreamSink.add(
          jsonEncode(
            {"temp_frame_id": tPictureFrameId},
          ),
        ),
      );
    });
  });

  group("pair", () {
    test(
        "should return a [FrameNotConnectedFailure] if a frame with the given id is not connected",
        () async {
      // act
      final result = await pairingSocketHandler.pair(
        tempFrameId: tPictureFrameId,
        curatorId: tCuratorId,
      );

      // assert
      expect(result, const Left(FrameNotConnectedFailure()));
    });

    group("if frame with give id exists", () {
      setUp(() {
        when(() => mockCreateFrame(any()))
            .thenAnswer((_) async => const Right(tPictureFrame));
        when(() => mockSignInFrame(frame: any(named: "frame")))
            .thenAnswer((_) async => Right(tServerTokenBundle));

        pairingSocketHandler.addConnection(
          frameId: tPictureFrameId,
          streamSink: tMockStreamSink,
        );
      });

      test("should create a new frame with the given curatorId as the owner",
          () async {
        // act
        await pairingSocketHandler.pair(
          tempFrameId: tPictureFrameId,
          curatorId: tCuratorId,
        );

        // assert
        verify(() => mockCreateFrame(tCuratorId));
      });

      test("should sign in the new frame", () async {
        // act
        await pairingSocketHandler.pair(
          tempFrameId: tPictureFrameId,
          curatorId: tCuratorId,
        );

        // assert
        verify(() => mockSignInFrame(frame: tPictureFrame));
      });

      test("should send the frame an [AuthenticationBundle]", () async {
        // act
        await pairingSocketHandler.pair(
          tempFrameId: tPictureFrameId,
          curatorId: tCuratorId,
        );

        // assert
        verify(
          () => tMockStreamSink.add(
            jsonEncode(tServerTokenBundle.toJson()),
          ),
        );
      });

      test("should close the socket connection to the temporary frame",
          () async {
        // act
        await pairingSocketHandler.pair(
          tempFrameId: tPictureFrameId,
          curatorId: tCuratorId,
        );

        // assert
        expect(
          pairingSocketHandler.isFrameConnected(frameId: tPictureFrameId),
          false,
        );
      });

      test("should return [None]", () async {
        // act
        final result = await pairingSocketHandler.pair(
          tempFrameId: tPictureFrameId,
          curatorId: tCuratorId,
        );

        // assert
        expect(result, const Right(None()));
      });
    });
  });
}
