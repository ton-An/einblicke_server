import 'package:dartz/dartz.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/models/image.dart';
import 'package:dispatch_pi_dart/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:dispatch_pi_shared/dispatch_pi_shared.dart';

/// {@template get_latest_image}
/// Gets the latest image for a specific frame
///
/// Parameters:
/// - [String] frameId
///
/// Returns:
/// - [Image]
///
/// Failures:
/// - [DatabaseReadFailure]
/// - [NoImagesFoundFailure]
/// - [StorageReadFailure]
/// {@endtemplate}
class GetLatestImage {
  /// {@macro get_latest_image}
  const GetLatestImage({
    required this.imageExchangeRepository,
  });

  /// Used to get the image
  final ImageExchangeRepository imageExchangeRepository;

  /// {@macro get_latest_image}
  Future<Either<Failure, Image>> call({
    required String frameId,
  }) async {
    return _getLatestImageId(frameId: frameId);
  }

  Future<Either<Failure, Image>> _getLatestImageId({
    required String frameId,
  }) async {
    final Either<Failure, String> latestImageIdEither =
        await imageExchangeRepository.getLatestImageIdFromDb(
      frameId: frameId,
    );

    return latestImageIdEither.fold(Left.new, (String latestImageId) async {
      return _getImageFromStorage(imageId: latestImageId);
    });
  }

  Future<Either<Failure, Image>> _getImageFromStorage({
    required String imageId,
  }) async {
    return imageExchangeRepository.getImageById(
      imageId: imageId,
    );
  }
}
