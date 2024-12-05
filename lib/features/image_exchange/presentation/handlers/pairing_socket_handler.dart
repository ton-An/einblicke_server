import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:einblicke_server/core/presentation/handlers/frame_socket_handler.dart';
import 'package:einblicke_server/features/authentication/domain/models/curator.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/authentication/domain/models/token_bundle.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/create_frame.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/generate_user_id.dart';
import 'package:einblicke_server/features/authentication/domain/uscases/sign_in_frame.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template pairing_socket_handler}
/// __Pairing Socket Handler__ handles the pairing of a [Frame] and a [Curator].
/// {@endtemplate}
class PairingSocketHandler extends FrameSocketHandler {
  /// {@macro pairing_socket_handler}
  PairingSocketHandler({
    required this.generateUserId,
    required this.createFrame,
    required this.signInFrame,
  });

  /// Used to generate a user id
  GenerateUserId generateUserId;

  /// Used to create a frame
  CreateFrame createFrame;

  /// Used to sign in a frame
  SignInFrame signInFrame;

  /// Adds an anonymous connection to the socket handler
  /// and sends a temp frame id to the to be paired frame
  ///
  /// Parameters:
  /// - [streamSink] the stream sink to be added
  ///
  /// Emits:
  /// - [String] the temp frame id
  ///
  /// Emits Failures:
  /// - [DatabaseReadFailure]
  /// - [UserIdGenerationFailure]
  Future<void> addAnonymousConnection({
    required StreamSink streamSink,
  }) async {
    final Either<Failure, String> tempFrameIdEither = await generateUserId();

    await tempFrameIdEither.fold(
      (Failure failure) async => streamSink.add(
        jsonEncode(failure.toJson()),
      ),
      (String tempFrameId) async {
        await super.addConnection(frameId: tempFrameId, streamSink: streamSink);

        await sendMessage(
          frameId: tempFrameId,
          message: jsonEncode({"temp_frame_id": "einblicke-$tempFrameId"}),
        );
      },
    );
  }

  /// Pairs a [Frame] with a [Curator]
  ///
  /// Parameters:
  /// - [tempFrameId] the temp frame id of the frame to be paired
  /// - [curatorId] the id of the curator to be paired
  ///
  /// Emits to frame:
  /// - [ServerTokenBundle] containing the access and refresh tokens
  ///
  /// Returns Failures:
  /// - [FrameNotConnectedFailure]
  /// - [DatabaseReadFailure]
  /// - [UserIdGenerationFailure]
  /// - [DatabaseWriteFailure]
  Future<Either<Failure, None>> pair({
    required String tempFrameId,
    required String curatorId,
    required String name,
  }) async {
    if (!isFrameConnected(frameId: tempFrameId)) {
      return const Left(FrameNotConnectedFailure());
    }

    final Either<Failure, Frame> createFrameEither =
        await createFrame(ownerId: curatorId, name: name);

    return createFrameEither.fold(Left.new, (Frame frame) async {
      final Either<Failure, ServerTokenBundle> signInFrameEither =
          await signInFrame(frame: frame);

      return signInFrameEither.fold(Left.new,
          (ServerTokenBundle tokenBundle) async {
        await sendMessage(
          frameId: tempFrameId,
          message: jsonEncode(tokenBundle.toJson()),
        );

        removeConnectionWithFrameId(
          frameId: tempFrameId,
        );

        return const Right(None());
      });
    });
  }
}
