import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/authentication/domain/models/picture_frame.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_latest_image.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/// {@template get_latest_frame_image_for_curator}
/// __Get Latest Frame Image For Curator__ gets the latest image of a given
/// [Frame] for a [Curator].
///
/// Parameters:
/// - [String] curatorId
/// - [String] frameId
///
/// Failures:
/// - [DatabaseReadFailure]
/// - [NoImagesFoundFailure]
/// - [StorageReadFailure]
/// - [NotPairedFailure]
/// {@endtemplate}
class GetLatestFrameImageForCurator {
  /// {@macro get_latest_frame_image_for_curator}
  const GetLatestFrameImageForCurator({
    required this.getLatestImage,
    required this.imageExchangeRepository,
  });

  final GetLatestImage getLatestImage;
  final ImageExchangeRepository imageExchangeRepository;

  /// {@macro get_latest_frame_image_for_curator}
  Future<Either<Failure, Image>> call({
    required String curatorId,
    required String frameId,
  }) async {
    return _checkIfCuratorXFramePaired(
      curatorId: curatorId,
      frameId: frameId,
    );
  }

  Future<Either<Failure, Image>> _checkIfCuratorXFramePaired({
    required String curatorId,
    required String frameId,
  }) async {
    final Either<Failure, bool> areCuratorXFramePairedEither =
        await imageExchangeRepository.areCuratorXFramePaired(
      curatorId: curatorId,
      frameId: frameId,
    );

    return areCuratorXFramePairedEither.fold(
      Left.new,
      (areCuratorXFramePaired) {
        if (areCuratorXFramePaired) {
          return _getLatestImage(frameId: frameId);
        } else {
          return const Left(NotPairedFailure());
        }
      },
    );
  }

  Future<Either<Failure, Image>> _getLatestImage({
    required String frameId,
  }) async {
    return getLatestImage(frameId: frameId);
  }
}
