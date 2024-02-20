import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/*
  To-Do:
    - [ ] Add proper error handling
    - [ ] Add failures to docs
*/

/// {@template frame_image_stream}
/// __Frame Image Stream__ creates a stream of [Image]s destined for a [Frame].
///
/// When the stream is initialized, the latest image is added to the stream
///
/// Atm, the stream the only time a [Failure] is added to the stream is when the
/// stream is initialized. Maybe this should be changed. Plus, the docs for
/// this class are not complete
/// {@endtemplate}
class FrameImageStream {
  /// {@macro frame_image_stream}
  FrameImageStream({
    required this.streamController,
    required this.getLatestImage,
  });

  /// Used to control the stream of images
  final StreamController<Either<Failure, Image>> streamController;

  /// Used to get the latest image
  final GetLatestImage getLatestImage;

  /// Initializes the [Image] to frame stream
  Future<void> initStream({required String frameId}) async {
    await _getLatestImage(frameId: frameId);
  }

  /// Returns the [Image] to frame stream
  Stream<Either<Failure, Image>> getStream() async* {
    yield* streamController.stream;
  }

  /// Adds an [Image] to the stream
  void addImage(Image image) {
    // should add an image to the stream
    streamController.add(Right(image));
  }

  /// Adds a [Failure] to the stream
  void addFailure(Failure failure) {
    // should add a failure to the stream
    streamController.add(Left(failure));
  }

  Future<void> _getLatestImage({required String frameId}) async {
    final Either<Failure, Image> getLatestImageEither =
        await getLatestImage(frameId: frameId);

    getLatestImageEither.fold(
      addFailure,
      addImage,
    );
  }
}
