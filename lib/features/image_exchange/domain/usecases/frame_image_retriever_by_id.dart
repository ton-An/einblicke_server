import 'package:dartz/dartz.dart';
import 'package:einblicke_server/features/image_exchange/domain/models/image.dart';
import 'package:einblicke_server/features/image_exchange/domain/repositories/image_exchange_repository.dart';
import 'package:einblicke_server/features/image_exchange/domain/usecases/get_image_from_id.dart';
import 'package:einblicke_shared/einblicke_shared.dart';

/*
  To-Do:
    - [ ] Add failures to docs
    - [ ] Write tests
*/

/// {@template frame_image_retriever_by_id}
/// __Frame Image Retriever By Id__ retrieves an [Image] from storage
/// using the given image id if it is associated with the given frame id.
///
/// Parameters:
/// - [String] frameId
/// - [String] imageId
///
/// Returns:
/// - [Image]
///
/// Failures:
/// - [DatabaseReadFailure]
/// - [StorageReadFailure]
/// - [ImageNotFoundFailure]
/// {@endtemplate}
class FrameImageRetrieverById {
  /// {@macro frame_image_retriever_by_id}
  const FrameImageRetrieverById({
    required this.getImageFromId,
    required this.imageExchangeRepository,
  });

  /// Used for getting the image from storage
  final GetImageFromId getImageFromId;

  /// Used for checking if the image is associated with the frame
  final ImageExchangeRepository imageExchangeRepository;

  /// {@macro frame_image_retriever_by_id}
  Future<Either<Failure, Image>> call({
    required String frameId,
    required String imageId,
  }) async {
    return _checkIfImageBelongsToFrame(frameId: frameId, imageId: imageId);
  }

  Future<Either<Failure, Image>> _checkIfImageBelongsToFrame({
    required String frameId,
    required String imageId,
  }) async {
    final Either<Failure, bool> isImageAssociatedWithFrameEither =
        await imageExchangeRepository.isImageAssociatedWithFrame(
      frameId: frameId,
      imageId: imageId,
    );

    return isImageAssociatedWithFrameEither.fold(
      Left.new,
      (bool isImageAssociatedWithFrame) {
        if (isImageAssociatedWithFrame) {
          return _getImage(imageId: imageId);
        }

        return Left(const ImageNotFoundFailure());
      },
    );
  }

  Future<Either<Failure, Image>> _getImage({required String imageId}) async {
    final Either<Failure, Image> imageEither =
        await getImageFromId(imageId: imageId);

    return imageEither;
  }
}
