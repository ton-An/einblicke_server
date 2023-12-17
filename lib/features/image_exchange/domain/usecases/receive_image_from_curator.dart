import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/failures/database_read_failure.dart';
import 'package:dispatch_pi_dart/core/failures/database_write_failure.dart';
import 'package:dispatch_pi_dart/core/failures/failure.dart';
import 'package:dispatch_pi_dart/core/failures/not_paired_failure.dart';
import 'package:dispatch_pi_dart/core/failures/storage_unavailable_failure.dart';
import 'package:dispatch_pi_dart/core/failures/write_failure.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/picture_frame.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';

/// {@template receive_image_from_curator}
/// Receives an image from a [Curator] and sends it to a [PictureFrame].
///
/// Parameters:
/// - [String] curatorId
/// - [String] frameId
/// - [List<int>] imageBytes
///
/// Failures:
/// - [NotPairedFailure]
/// - [DatabaseReadFailure]
/// - [DatabaseWriteFailure]
/// - [StorageUnavailableFailure]
/// - [StorageWriteFailure]
/// - ... TBD ...
/// {@endtemplate}
class ReceiveImageFromCurator {
  /// {@macro receive_image_from_curator}
  ReceiveImageFromCurator({
    required this.imageExchangeRepository,
    required this.clock,
  });

  /// Used to interact with the database and storage
  final ImageExchangeRepository imageExchangeRepository;

  /// Used to get the current time
  final Clock clock;

  /// {@macro receive_image_from_curator}
  Future<Either<Failure, None>> call({
    required String curatorId,
    required String frameId,
    required List<int> imageBytes,
  }) async {
    return _checkIfCuratorXFramePaired(
      curatorId: curatorId,
      frameId: frameId,
      imageBytes: imageBytes,
    );
  }

  Future<Either<Failure, None>> _checkIfCuratorXFramePaired({
    required String curatorId,
    required String frameId,
    required List<int> imageBytes,
  }) async {
    final Either<Failure, bool> areCuratorXFramePaired =
        await imageExchangeRepository.areCuratorXFramePaired(
      curatorId: curatorId,
      frameId: frameId,
    );

    return areCuratorXFramePaired.fold(Left.new, (bool areCuratorXFramePaired) {
      if (!areCuratorXFramePaired) {
        return const Left(NotPairedFailure());
      }

      return _generateImageId(
        curatorId: curatorId,
        frameId: frameId,
        imageBytes: imageBytes,
      );
    });
  }

  Future<Either<Failure, None>> _generateImageId({
    required String curatorId,
    required String frameId,
    required List<int> imageBytes,
  }) async {
    final String imageId = imageExchangeRepository.generateImageId();

    return _saveImage(
      curatorId: curatorId,
      frameId: frameId,
      imageId: imageId,
      imageBytes: imageBytes,
    );
  }

  Future<Either<Failure, None>> _saveImage({
    required String curatorId,
    required String frameId,
    required String imageId,
    required List<int> imageBytes,
  }) async {
    final Either<Failure, None> saveImageEither =
        await imageExchangeRepository.saveImage(
      imageId: imageId,
      imageBytes: imageBytes,
    );

    return saveImageEither.fold(Left.new, (_) {
      return _saveImageToDb(
        curatorId: curatorId,
        frameId: frameId,
        imageId: imageId,
      );
    });
  }

  Future<Either<Failure, None>> _saveImageToDb({
    required String curatorId,
    required String frameId,
    required String imageId,
  }) async {
    final DateTime createdAt = clock.now();

    final Either<Failure, None> saveImageToDbEither =
        await imageExchangeRepository.saveImageToDb(
      curatorId: curatorId,
      frameId: frameId,
      imageId: imageId,
      createdAt: createdAt,
    );

    return saveImageToDbEither;
  }
}
