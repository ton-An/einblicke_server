import 'package:clock/clock.dart';
import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/core/domain/crypto_repository.dart';
import 'package:dispatch_pi_dart/features/authentication/domain/models/curator.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template receive_image_from_curator}
/// __Receive Image From Curator__ receives an image from a [Curator] and
/// saves it to the database and storage.
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
/// - [StorageWriteFailure]
/// - ... TBD ...
/// {@endtemplate}
class ReceiveImageFromCurator {
  /// {@macro receive_image_from_curator}
  ReceiveImageFromCurator({
    required this.imageExchangeRepository,
    required this.cryptoRepository,
    required this.clock,
  });

  /// Used to interact with the database and storage
  final ImageExchangeRepository imageExchangeRepository;

  /// Used to generate a unique id for the image
  final CryptoRepository cryptoRepository;

  /// Used to get the current time
  final Clock clock;

  /// {@macro receive_image_from_curator}
  Future<Either<Failure, String>> call({
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

  Future<Either<Failure, String>> _checkIfCuratorXFramePaired({
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

  Future<Either<Failure, String>> _generateImageId({
    required String curatorId,
    required String frameId,
    required List<int> imageBytes,
  }) async {
    final String imageId = cryptoRepository.generateUuid();

    return _saveImage(
      curatorId: curatorId,
      frameId: frameId,
      imageId: imageId,
      imageBytes: imageBytes,
    );
  }

  Future<Either<Failure, String>> _saveImage({
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

  Future<Either<Failure, String>> _saveImageToDb({
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

    return saveImageToDbEither.fold(
      Left.new,
      (None none) => _returnImageId(imageId: imageId),
    );
  }

  Future<Either<Failure, String>> _returnImageId({
    required String imageId,
  }) async {
    return Right(imageId);
  }
}
